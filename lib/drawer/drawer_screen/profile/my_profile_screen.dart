import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/user_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_button_widget.dart';
import 'package:library_management/drawer/drawer_screen/profile/edit_profile_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/email_verification_dialog.dart';
import 'package:library_management/drawer/drawer_screen/profile/logout_confirmation_dialog.dart';
import 'package:library_management/drawer/drawer_screen/profile/profile_tile.dart';
import 'package:library_management/provider/user_provider.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userController = UserController();
    final userName = user != null ? user.name : 'Your Name';
    final userEmail = user != null ? user.email : 'gmail.com';
    final userIsActive = user != null ? 'Active' : "Not Active";
    final userEmailVerify = user != null
        ? user.isEmailVerified
              ? 'Verified'
              : 'Verify'
        : 'Not Verified';
    final userNumberOfLibrary = user != null ? user.libraries.length : 0;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'My Profile',
        actionIcon: Icons.logout,
        onActionPressed: () {
          showLogoutConfirmationDialog(context: context, ref: ref);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFD0E6FF),
              child: Icon(Icons.person, size: 60, color: AppColors.accent),
            ),

            const SizedBox(height: 10),

            Text(
              // name will update from backend
              userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              //email from backend
              userEmail,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    ProfileTile(title: "Name", value: userName),
                    Divider(),

                    ProfileTile(title: "Email", value: userEmail),
                    Divider(),

                    ProfileTile(
                      title: "Email Verification",
                      value: userEmailVerify,
                      isIconValue: user?.isEmailVerified ?? false,
                      iconValue: Icons.verified,
                      isClickable: user != null && !user.isEmailVerified,
                      clickableValue: () async {
                        if (user == null || user.isEmailVerified) return;

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
                    ),
                    Divider(),

                    ProfileTile(title: "Subscription", value: userIsActive),
                    Divider(),

                    ProfileTile(
                      title: "Libraries",
                      value: userNumberOfLibrary.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            DrawerButtonWidget(
              buttonText: 'Edit Profile',
              buttonIcon: Icons.edit,
              buttonRoutes: true,
              screenChange: EditProfileScreen(),
            ),

            SizedBox(height: 15),

            InkWell(
              onTap: () {},
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
