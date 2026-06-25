import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/screens/main_screen.dart';
import 'package:library_management/services/manage_http_response.dart';

class LibraryController {
  Future<void> createLibrary({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryName,
    required String tagLine,
    required String whatsappNumber,
    required String city,
    required String state,
    required String pinCode,
  }) async {
    try {
      LibraryModel libraryModel = LibraryModel(
        libraryName: libraryName,
        tagLine: tagLine,
        whatsappNumber: whatsappNumber,
        city: city,
        state: state,
        pinCode: pinCode,
        totalStudents: 0,
        totalSeats: 0,
      );

      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return;
      }

      http.Response response = await http.post(
        Uri.parse('$uri/api/createlibrary'),
        body: libraryModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
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
                return MainScreen();
              },
            ),
            (route) => false,
          );
          //showSnackBar(context, 'Accout has been created');
          AppNotification.show(context, message: 'Library Created');
        },
      );
    } catch (e, stackTrace) {
      debugPrint("Signup Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
