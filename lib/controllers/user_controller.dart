import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/authScreens/login_screen.dart';
import 'package:library_management/global_varaible.dart';

import 'package:http/http.dart' as http;
import 'package:library_management/local_storage.dart';
import 'package:library_management/models/user_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/screens/main_screen.dart';
import 'package:library_management/services/manage_http_response.dart';

class UserController {
  Future<void> signup({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserModel userModel = UserModel(
        id: '',
        name: name,
        email: email,
        password: password,
        isEmailVerified: false,
        role: '',
        status: '',
        libraries: [],
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/register'),
        body: userModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ),
            (route) => false,
          );
          //showSnackBar(context, 'Accout has been created');
          AppNotification.show(context, message: 'Account Created');
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Signup Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> signIn({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
  }) async {
    try {
      UserModel userModel = UserModel(
        id: '',
        name: '',
        email: email,
        password: password,
        isEmailVerified: false,
        role: '',
        status: '',
        libraries: [],
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/login'),
        body: userModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          print(response.body);

          //getting data from backend
          final data = jsonDecode(response.body);

          //seperating user and token
          final user = data['user'];
          final token = data['token'];
          final userJson = jsonEncode(user);

          //get Libraries
          final libraries = user['libraries'] as List<dynamic>;

          //saving data to local storage
          await LocalStorage.saveLogin(token: token, userJson: userJson);

          //saving current library id there
          if (libraries.isNotEmpty) {
            final String currentLibraryId = libraries.first.toString();
            await LocalStorage.saveCurrentLibrary(libraryId: currentLibraryId);
            ref
                .read(currentLibraryProvider.notifier)
                .setLibrary(currentLibraryId);
          }

          //update riverpod
          ref.read(userProvider.notifier).setUser(userJson);
          ref.read(tokenProvider.notifier).setToken(token);

          //print(ref.read(tokenProvider));
          //final localdata = await LocalStorage.getUser();
          //print('data from localtorage $localdata');

          print('LibrarID: ${ref.read(currentLibraryProvider)}');

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainScreen();
                // return libraries.isEmpty
                //     ? LibraryProfileScreen()
                //     : MainScreen();
                //--------here i Have to check if already library or not
                //---- count library number and if user select one then save that
                //----if one library that directly to home page
              },
            ),
            (route) => false,
          );
          AppNotification.show(context, message: 'Signed In');
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Signup Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> updateProfile({
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    required String email,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return;
      }

      final response = await http.put(
        Uri.parse('$uri/api/profile'),
        body: jsonEncode({'name': name.trim(), 'email': email.trim()}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final data = jsonDecode(response.body);
          final userJson = jsonEncode(data['user']);

          await LocalStorage.saveLogin(token: token, userJson: userJson);
          ref.read(userProvider.notifier).setUser(userJson);

          if (!context.mounted) return;

          Navigator.pop(context);
          AppNotification.show(context, message: 'Profile Updated');
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Update Profile Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<bool> sendEmailVerificationOtp({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return false;
      }

      final response = await http.post(
        Uri.parse('$uri/api/verify-email'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (!context.mounted) return false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppNotification.show(context, message: 'OTP sent to your email');
        return true;
      }

      showSnackBar(context, getMessageFromResponse(response));
      return false;
    } catch (e, stackTrace) {
      debugPrint("Send Email OTP Error: $e");
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        showSnackBar(context, "Unable to send OTP");
      }
      return false;
    }
  }

  Future<bool> verifyEmailOtp({
    required BuildContext context,
    required WidgetRef ref,
    required String otp,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return false;
      }

      final response = await http.post(
        Uri.parse('$uri/api/otp-verify'),
        body: jsonEncode({'otp': otp.trim()}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (!context.mounted) return false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final userJson = jsonEncode(data['user']);

        await LocalStorage.saveLogin(token: token, userJson: userJson);
        ref.read(userProvider.notifier).setUser(userJson);

        if (context.mounted) {
          AppNotification.show(context, message: 'Email Verified');
        }
        return true;
      }

      showSnackBar(context, getMessageFromResponse(response));
      return false;
    } catch (e, stackTrace) {
      debugPrint("Verify Email OTP Error: $e");
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        showSnackBar(context, "Unable to verify OTP");
      }
      return false;
    }
  }
}
