import 'package:flutter/material.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/authScreens/login_screen.dart';
import 'package:library_management/global_varaible.dart';

import 'package:http/http.dart' as http;
import 'package:library_management/models/user_model.dart';
import 'package:library_management/screens/library_profile_screen.dart';
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
                return LibraryProfileScreen();
                //--------here i Have to check if already library or not
                //---- count library number and if user select one then save that
                //----if one library that directly to home page
              },
            ),
            (route) => false,
          );
          showSnackBar(context, 'You are Signed In');
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Signup Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
