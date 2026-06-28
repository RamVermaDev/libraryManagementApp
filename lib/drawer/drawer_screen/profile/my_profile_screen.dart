import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_button_widget.dart';
import 'package:library_management/drawer/drawer_screen/profile/edit_profile_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/profile_tile.dart';
import 'package:library_management/provider/user_provider.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: const AppBarWidget(title: 'My Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFD0E6FF),
              child: Icon(Icons.person, size: 60, color: AppColors.secondary),
            ),

            const SizedBox(height: 10),

            Text(
              // name will update from backend
              user != null ? user.name : 'Ramnedra',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              //email from backend
              user != null ? user.email : 'gmail.com',
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
                  children: const [
                    ProfileTile(title: "Name", value: "Ramendra Verma"),
                    Divider(),

                    ProfileTile(title: "Email", value: "ram@gmail.com"),
                    Divider(),

                    ProfileTile(title: "Status", value: "Active"),
                    Divider(),

                    ProfileTile(title: "Email Verification", value: "Verified"),
                    Divider(),

                    ProfileTile(title: "Libraries", value: "2"),
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
