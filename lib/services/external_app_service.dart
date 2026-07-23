import 'package:url_launcher/url_launcher.dart';

class ExternalAppService {
  ExternalAppService._();

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not call $phoneNumber');
    }
  }

  static Future<void> openWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    final String cleanPhoneNumber = phoneNumber.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final Uri uri = Uri.parse(
      'https://wa.me/$cleanPhoneNumber'
      '?text=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open WhatsApp');
    }
  }

  static Future<void> sendSms({
    required String phoneNumber,
    String? message,
  }) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null && message.isNotEmpty
          ? {'body': message}
          : null,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
