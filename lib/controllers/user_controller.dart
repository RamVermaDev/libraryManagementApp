import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/authScreens/login_screen.dart';
import 'package:library_management/global_varaible.dart';

import 'package:http/http.dart' as http;
import 'package:library_management/models/user_model.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/screens/library_profile_screen.dart';
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
        onSuccess: () {
          print(response.body);

          final user = jsonDecode(response.body)['user'];

          final userJson = jsonEncode(user);
          ref.read(userProvider.notifier).setUser(userJson);
          final token = jsonDecode(response.body)['token'];
          ref.read(tokenProvider.notifier).setToken(token);
          print(ref.read(tokenProvider));

          //check libraries number
          final libraries = ref.read(userProvider)!.libraries;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return libraries.isEmpty
                    ? LibraryProfileScreen()
                    : MainScreen();
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
}
