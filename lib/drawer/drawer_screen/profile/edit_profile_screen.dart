import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/user_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawerWidgets/drawer_text_form_field.dart';
import 'package:library_management/provider/user_provider.dart';
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
                validator: FormValidators.nameValidator,
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 20),

              DrawerTextFormField(
                controller: _emailController,
                lable: 'Email Adress',
                prefixIcon: Icons.email_outlined,
                validator: FormValidators.emailValidator,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  onPressed: _isLoading ? null : saveProfile,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
