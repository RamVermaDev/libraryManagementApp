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
    String cleanPhoneNumber = phoneNumber.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    // Prepend country code 91 if 10-digit mobile number
    if (cleanPhoneNumber.length == 10) {
      cleanPhoneNumber = '91$cleanPhoneNumber';
    }

    final Uri whatsappAppUri = Uri.parse(
      'whatsapp://send?phone=$cleanPhoneNumber&text=${Uri.encodeComponent(message)}',
    );

    final Uri whatsappWebUri = Uri.parse(
      'https://api.whatsapp.com/send?phone=$cleanPhoneNumber&text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappAppUri)) {
      await launchUrl(whatsappAppUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(whatsappWebUri)) {
      await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open WhatsApp for $phoneNumber');
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
