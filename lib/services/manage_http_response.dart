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

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String getMessageFromResponse(http.Response response) {
  try {
    final Map<String, dynamic> body = jsonDecode(response.body);
    final message = body['message'] ?? body['err'];
    print(body);
    return message?.toString() ?? 'something went wrong here';
  } catch (err) {
    print(err.toString());
    return 'Something went wrong here';
  }
}
