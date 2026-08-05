import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/provider/app_mode_provider.dart';
import 'package:library_management/provider/token_provider.dart';

Map<String, String> getApiHeaders(WidgetRef ref) {
  final token = ref.read(tokenProvider);
  final mode = ref.read(appModeProvider);

  final headers = <String, String>{
    'Content-Type': 'application/json',
    'x-app-mode': mode.key,
  };

  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'Bearer $token';
  }

  return headers;
}
