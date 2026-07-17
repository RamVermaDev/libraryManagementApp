import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/user_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_button_widget.dart';
import 'package:library_management/drawer/drawer_screen/profile/edit_profile_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/email_verification_dialog.dart';
import 'package:library_management/drawer/drawer_screen/profile/logout_confirmation_dialog.dart';
import 'package:library_management/drawer/drawer_screen/profile/build_profile_row.dart';
import 'package:library_management/provider/user_provider.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double scale = context.scale;
    final user = ref.watch(userProvider);
    final userController = UserController();
    final userName = user != null ? user.name : 'Your Name';
    final userEmail = user != null ? user.email : 'gmail.com';
    final userIsActive = user != null ? 'Active' : "Not Active";
    final userNumberOfLibrary = user != null ? user.libraries.length : 0;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'My Profile',
        actionIcon: Icons.logout_outlined,
        onActionPressed: () {
          showLogoutConfirmationDialog(context: context, ref: ref);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20 * scale),

            // Avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                // We'll replace this with your custom Avatar widget later
                CircleAvatar(
                  radius: 52 * scale,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 48 * scale,
                    backgroundColor: AppColors.border,
                    child: Icon(Icons.person, size: 65, color: AppColors.info),
                  ),
                ),

                // Verification Badge
                if (user?.isEmailVerified ?? false)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      width: 28 * scale,
                      height: 28 * scale,
                      decoration: BoxDecoration(
                        color: AppColors.caption,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 16 * scale,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 10 * scale),

            Text(
              // name will update from backend
              userName,
              style: TextStyle(
                fontSize: 24 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8 * scale),

            Text(
              //email from backend
              userEmail,
              style: TextStyle(color: AppColors.grey600, fontSize: 16 * scale),
            ),

            SizedBox(height: 30 * scale),

            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  buildProfileRow(
                    title: "Name",
                    child: Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * scale,
                      ),
                    ),
                  ),

                  _divider(),

                  buildProfileRow(
                    title: "Email",
                    child: Text(
                      userEmail,
                      style: TextStyle(
                        color: AppColors.grey700,
                        fontSize: 14 * scale,
                      ),
                    ),
                  ),

                  _divider(),

                  buildProfileRow(
                    title: "Email Verification",
                    child: user?.isEmailVerified ?? false
                        ? _statusChip(
                            text: "Verified",
                            color: AppColors.buttonPrimaryHover,
                            icon: Icons.verified,
                            scale: scale,
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
                            child: _statusChip(
                              text: "Verify",
                              color: AppColors.error,
                              icon: Icons.warning_amber,
                              scale: scale,
                            ),
                          ),
                  ),

                  _divider(),

                  buildProfileRow(
                    title: "Subscription",
                    child: _statusChip(
                      text: userIsActive,
                      color: Colors.green,
                      scale: scale,
                    ),
                  ),

                  _divider(),

                  buildProfileRow(
                    title: "Libraries",
                    child: Text(
                      "$userNumberOfLibrary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15 * scale,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30 * scale),

            DrawerButtonWidget(
              buttonText: 'Edit Profile',
              buttonIcon: Icons.edit_outlined,
              buttonRoutes: true,
              screenChange: EditProfileScreen(),
            ),

            SizedBox(height: 15 * scale),

            InkWell(
              onTap: () {},
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),

            SizedBox(height: 25 * scale),
          ],
        ),
      ),
    );
  }
}

Widget _divider() {
  return Divider(height: 1, thickness: 1, color: Colors.grey.shade200);
}

Widget _statusChip({
  required String text,
  required Color color,
  IconData? icon,
  required double scale,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .08),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 14 * scale, color: color),
        if (icon != null) const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12 * scale,
          ),
        ),
      ],
    ),
  );
}
