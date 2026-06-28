import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/global_varaible.dart';
import 'package:library_management/local_storage.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/screens/library_profile_screen.dart';
import 'package:library_management/screens/main_screen.dart';
import 'package:library_management/screens/welcome_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late final Future<Widget> _startScreen;

  @override
  void initState() {
    super.initState();
    // Safely initialize the future inside initState
    // so that 'ref' is fully available and mounted is reliable.
    _startScreen = _loadStartScreen();
  }

  Future<Widget> _loadStartScreen() async {
    // Guard: if widget was disposed before async work begins, bail out early.
    if (!mounted) return const WelcomeScreen();

    final token = await LocalStorage.getToken();

    if (token == null || token.isEmpty) {
      return const WelcomeScreen();
    }

    // Set token in provider only if still mounted.
    if (!mounted) return const WelcomeScreen();
    ref.read(tokenProvider.notifier).setToken(token);

    try {
      final response = await http.get(
        Uri.parse('$uri/api/verify-token'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // Guard after await: widget may have been disposed during the HTTP call.
      if (!mounted) return const WelcomeScreen();

      if (response.statusCode != 200) {
        await LocalStorage.clearLogin();
        return const WelcomeScreen();
      }

      final data = jsonDecode(response.body);

      final userJson = jsonEncode(data['user']);

      await LocalStorage.saveLogin(token: token, userJson: userJson);

      ref.read(userProvider.notifier).setUser(userJson);

      final user = ref.read(userProvider)!;

      if (user.libraries.isEmpty) {
        return const LibraryProfileScreen();
      }

      return const MainScreen();
    } on http.ClientException catch (e, st) {
      // Network-level errors (no internet, connection refused, etc.)
      debugPrint('AuthGate: Network error: $e\n$st');
      //await LocalStorage.clearLogin();
      return const WelcomeScreen();
    } catch (e, st) {
      // Any other unexpected error
      debugPrint('AuthGate: Unexpected error: $e\n$st');
      await LocalStorage.clearLogin();
      return const WelcomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _startScreen,
      builder: (context, snapshot) {
        // Show error state if future completed with an error.
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          debugPrint('AuthGate FutureBuilder error: ${snapshot.error}');
          return const WelcomeScreen();
        }

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return snapshot.data!;
        }

        // Loading state while the future is pending.
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
