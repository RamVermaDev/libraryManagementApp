import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class TermsServiceScreen extends StatelessWidget {
  const TermsServiceScreen({super.key});

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
          'Terms of Service',
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
              'Terms of Service',
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
              title: '1. Acceptance of Terms',
              points: [
                'By creating an account or using Library Pro, you agree to these Terms of Service.',
                'If you use Library Pro on behalf of a study library or institution, you warrant that you are authorized to bind that entity.',
              ],
            ),

            _buildSection(
              title: '2. Account Responsibilities',
              points: [
                'You are responsible for maintaining the confidentiality of your login credentials and OTPs.',
                'You agree not to upload fraudulent student records, illegal content, or malicious code.',
                'Admin account owners are responsible for managing receptionist permissions and access.',
              ],
            ),

            _buildSection(
              title: '3. SaaS Subscriptions & Billing',
              points: [
                'Subscription plans (Basic, Pro, Enterprise) are billed on a recurring monthly or annual basis.',
                'Payments are processed securely via Razorpay.',
                'Subscriptions can be upgraded or cancelled at any time from your account settings.',
              ],
            ),

            _buildSection(
              title: '4. Service Availability & Support',
              points: [
                'We strive for 99.9% platform uptime and zero data loss.',
                'Scheduled maintenance window alerts will be notified in advance via app notification.',
              ],
            ),

            _buildSection(
              title: '5. Limitation of Liability',
              points: [
                'Library Pro is provided "as is". We are not liable for indirect financial losses resulting from unauthorized account sharing or third-party downtime.',
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
