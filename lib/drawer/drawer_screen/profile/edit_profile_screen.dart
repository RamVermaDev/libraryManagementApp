import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_button_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_text_form_field.dart';
import 'package:library_management/drawer/drawer_screen/profile/my_profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(
    text: "Ramendra Verma",
  );

  final TextEditingController _emailController = TextEditingController(
    text: "ram@gmail.com",
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Edit Profile", isAction: false),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const SizedBox(height: 10),

              Stack(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xffD0E6FF),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.secondary,
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.secondary,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          // Pick Image
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              DrawerTextFormField(
                controller: _nameController,
                lable: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  return null;
                },
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 20),

              DrawerTextFormField(
                controller: _emailController,
                lable: 'Email Adress',
                prefixIcon: Icons.email_outlined,
                validator: (value) => null,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              DrawerButtonWidget(
                screenChange: MyProfileScreen(),
                buttonText: 'Save Changes',
                buttonRoutes: false,
                buttonIcon: Icons.save,
                pop: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
