import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppColors.heading,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.heading),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Last updated: July 2026',
              style: TextStyle(fontSize: 13, color: AppColors.caption),
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: '1. Information We Collect',
              points: [
                'Account Details: Name, email address, phone number, and library profile info upon signup.',
                'Library Data: Student records, fee billing history, attendance, and seat slot allocations.',
                'Payment Data: Payment transactions processed securely via Razorpay. Card or banking credentials are never stored on our servers.',
                'Device Info: Device model, operating system, and push notification tokens.',
              ],
            ),

            _buildSection(
              title: '2. How We Use Your Information',
              points: [
                'To provide, operate, and maintain your multi-library SaaS platform.',
                'To process fee billing, manage student rosters, and generate receipts.',
                'To send real-time push notifications for student registrations and dues.',
                'To protect account security and prevent unauthorized access.',
              ],
            ),

            _buildSection(
              title: '3. Data Security & Protection',
              points: [
                'Industry-standard SSL/TLS encryption for all data transmitted between app and servers.',
                'Passwords hashed using bcrypt with salt rounds.',
                'Strict isolation between library accounts and role permissions.',
              ],
            ),

            _buildSection(
              title: '4. Data Sharing & Third Parties',
              points: [
                'We do NOT sell, rent, or trade your personal or library data to third parties.',
                'Secure third-party integrations: Razorpay (payments), Brevo (email OTPs), Cloudinary (photos), and Firebase (notifications).',
              ],
            ),

            _buildSection(
              title: '5. Your Rights',
              points: [
                'Access, update, or request export of your library roster at any time.',
                'Request full account and data deletion via Support.',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> points}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.body,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
