import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/user_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_text_form_field.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';
import 'package:library_management/validator/form_validators.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    Future<void> saveProfile() async {
      if (!_formKey.currentState!.validate()) return;

      setState(() {
        _isLoading = true;
      });

      await _userController.updateProfile(
        context: context,
        ref: ref,
        name: _nameController.text,
        email: _emailController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: const AppBarWidget(title: "Edit Profile"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffD0E6FF),
                      child: Icon(
                        Icons.person,
                        size: 60 * scale,
                        color: AppColors.accent,
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.accent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18 * scale,
                          ),
                          onPressed: () {
                            // Pick Image
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30 * scale),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30 * scale),

                    /// Full Name
                    TitleText(
                      title: 'Full Name',
                      fontSize: 12 * scale,
                      weight: FontWeight.w600,
                      fontColor: AppColors.formLabel,
                    ),

                    SizedBox(height: 8 * scale),

                    DrawerTextFormField(
                      controller: _nameController,
                      hintText: 'Enter your full name',
                      validator: FormValidators.nameValidator,
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: 24 * scale),

                    /// Email
                    TitleText(
                      title: 'Email Address',
                      fontSize: 12 * scale,
                      weight: FontWeight.w600,
                      fontColor: AppColors.formLabel,
                    ),

                    SizedBox(height: 8 * scale),

                    DrawerTextFormField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      validator: FormValidators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: 30 * scale),

                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isLoading ? () {} : saveProfile,

                        child: _isLoading
                            ? SpinKitThreeBounce(
                                size: 16,
                                color: AppColors.buttonPrimary,
                              )
                            : Text('Save Changes'),
                      ),
                    ),
                    SizedBox(height: 30 * scale),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
