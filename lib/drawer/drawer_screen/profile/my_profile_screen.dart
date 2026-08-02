import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/user_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawer_screen/library/my_library_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/active_devices_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/edit_profile_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/email_verification_dialog.dart';
import 'package:library_management/drawer/drawer_screen/profile/privacy_policy_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/terms_service_screen.dart';
import 'package:library_management/drawer/drawer_screen/subscription_screen.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  String _formatRoleLabel(String? role) {
    final r = (role ?? '').toLowerCase();
    if (r == 'admin' || r == 'owner') return 'Admin';
    if (r == 'librarian' || r == 'staff' || r == 'reception')
      return 'Receptionist';
    return 'General';
  }

  Color _roleColor(String label) {
    if (label == 'Admin') return const Color(0xFF7C3AED); // Purple
    if (label == 'Receptionist') return const Color(0xFF2563EB); // Blue
    return const Color(0xFF475569); // Slate Grey
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userController = UserController();

    final userName = user?.name.isNotEmpty == true
        ? user!.name
        : 'Library Owner';
    final userEmail = user?.email ?? 'owner@library.com';
    final roleLabel = _formatRoleLabel(user?.role);
    final userIsVerified = user?.isEmailVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'My Profile & Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          children: [
            // ==========================================
            // HEADER AVATAR & NAME CARD
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2.5),
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'L',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // CONTAINER 1: PERSONAL INFORMATION
            // ==========================================
            _buildSectionCard(
              title: 'Personal Information',
              titleIcon: Icons.person_outline_rounded,
              trailingWidget: IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              children: [
                _buildStackedRow(
                  icon: Icons.badge_outlined,
                  label: 'Full Name',
                  child: Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                _buildInsetDivider(),
                _buildStackedRow(
                  icon: Icons.email_outlined,
                  label: 'Email Address',
                  child: Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.heading,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==========================================
            // CONTAINER 2: ACCOUNT DETAILS & MEMBERSHIPS
            // ==========================================
            _buildSectionCard(
              title: 'Account Details',
              titleIcon: Icons.verified_user_outlined,
              children: [
                _buildStackedRow(
                  icon: Icons.admin_panel_settings_outlined,
                  label: 'Account Role',
                  child: _buildStatusBadge(
                    roleLabel,
                    _roleColor(roleLabel),
                    Icons.shield_outlined,
                  ),
                ),
                _buildInsetDivider(),
                _buildStackedRow(
                  icon: Icons.mark_email_read_outlined,
                  label: 'Email Verification',
                  child: userIsVerified
                      ? _buildStatusBadge(
                          'Verified',
                          AppColors.success,
                          Icons.verified_rounded,
                        )
                      : InkWell(
                          onTap: () async {
                            if (user == null) return;
                            final isSent = await userController
                                .sendEmailVerificationOtp(
                                  context: context,
                                  ref: ref,
                                );
                            if (!context.mounted || !isSent) return;
                            await showEmailVerificationOtpDialogBox(
                              context: context,
                              ref: ref,
                            );
                          },
                          child: _buildStatusBadge(
                            'Verify Now',
                            AppColors.error,
                            Icons.warning_amber_rounded,
                          ),
                        ),
                ),
                _buildInsetDivider(),
                _buildStackedRow(
                  icon: Icons.other_houses_outlined,
                  label: 'My Libraries',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyLibraryScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${user?.libraries.length ?? 0} Libraries',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.heading,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.caption,
                      ),
                    ],
                  ),
                ),
                _buildInsetDivider(),
                _buildStackedRow(
                  icon: Icons.card_membership_outlined,
                  label: 'Subscription',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(
                        'Pro Plan',
                        AppColors.primary,
                        Icons.star_rounded,
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.caption,
                      ),
                    ],
                  ),
                ),
                _buildInsetDivider(),
                _buildStackedRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Member Since',
                  child: const Text(
                    'June 28, 2026',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.heading,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==========================================
            // CONTAINER 3: SECURITY
            // ==========================================
            _buildSectionCard(
              title: 'Security',
              titleIcon: Icons.security_outlined,
              children: [
                _buildClickableRow(
                  icon: Icons.devices_outlined,
                  label: 'Active Devices',
                  subtitle: 'Manage devices logged into your account',
                  valueWidget: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.caption,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActiveDevicesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ==========================================
            // CONTAINER 4: APP INFORMATION & SUPPORT
            // ==========================================
            _buildSectionCard(
              title: 'App Information & Support',
              titleIcon: Icons.info_outline_rounded,
              children: [
                _buildInfoRow(
                  icon: Icons.smartphone_outlined,
                  label: 'Version',
                  value: 'v1.0.0+1',
                ),
                _buildInsetDivider(),
                _buildClickableRow(
                  icon: Icons.policy_outlined,
                  label: 'Privacy Policy',
                  valueWidget: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.caption,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),
                _buildInsetDivider(),
                _buildClickableRow(
                  icon: Icons.description_outlined,
                  label: 'Terms of Service',
                  valueWidget: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.caption,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsServiceScreen(),
                      ),
                    );
                  },
                ),
                _buildInsetDivider(),
                _buildClickableRow(
                  icon: Icons.star_outline_rounded,
                  label: 'Rate Our Application',
                  valueWidget: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.caption,
                  ),
                  onTap: () {
                    showSnackBar(context, 'Thank you for rating Library Pro!');
                  },
                ),
                _buildInsetDivider(),

                // STACKED SUPPORT & CONTACT DETAILS AT BOTTOM
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Support & Contact',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.heading,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'support@librarypro.app',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.body,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '+91 9876543210',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.body,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildSectionCard({
    required String title,
    required IconData titleIcon,
    required List<Widget> children,
    Widget? trailingWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(titleIcon, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                if (trailingWidget != null) trailingWidget,
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ...children,
        ],
      ),
    );
  }

  static Widget _buildInsetDivider() {
    return const Divider(
      height: 1,
      indent: 48,
      endIndent: 16,
      color: AppColors.border,
    );
  }

  static Widget _buildStackedRow({
    required IconData icon,
    required String label,
    required Widget child,
    VoidCallback? onTap,
  }) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 19, color: AppColors.caption),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.caption,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                child,
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: content);
    }
    return content;
  }

  static Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.caption),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.body),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  static Widget _buildClickableRow({
    required IconData icon,
    required String label,
    String? subtitle,
    required Widget valueWidget,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.caption),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, color: AppColors.body),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.caption,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            valueWidget,
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
