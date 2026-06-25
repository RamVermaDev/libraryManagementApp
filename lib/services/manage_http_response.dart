import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;

    case 400:
    case 401:
    case 403:
    case 404:
    case 500:
      showSnackBar(context, getMessageFromResponse(response));
      break;

    default:
      showSnackBar(context, getMessageFromResponse(response));
  }
}

void showSnackBar(
  BuildContext context,
  String message, {
  bool isSuccess = false,
}) {
  final messenger = ScaffoldMessenger.of(context);

  messenger.hideCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String getMessageFromResponse(http.Response response) {
  try {
    final Map<String, dynamic> body = jsonDecode(response.body);
    final message = body['message'] ?? body['err'];
    print(body);
    return message?.toString() ?? 'something went wrong heree';
  } catch (err) {
    print(err.toString());
    return 'Something went wrong her';
  }
}
