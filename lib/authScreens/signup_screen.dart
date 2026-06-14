import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/authScreens/login_screen.dart';
import 'package:library_management/components/app_logo_header.dart';
import 'package:library_management/components/app_text_field.dart';
import 'package:library_management/validator/form_validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // static const double _maxContentWidth = 420;
  static const double _fieldGap = 8;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitSignup() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account details look good.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = (constraints.maxWidth * 0.06)
                .clamp(20.0, 32.0)
                .toDouble();
            final logoSize = (constraints.maxHeight * 0.2)
                .clamp(110.0, 170.0)
                .toDouble();

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                24,
                horizontalPadding,
                24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppLogoHeader(
                        logoSize: logoSize,
                        heading: 'Register',
                        subHeading: 'Create your Account',
                      ),
                      const SizedBox(height: 64),
                      _SignupForm(
                        nameController: _nameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        onSubmit: _submitSignup,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          hintTxt: 'Name',
          textEditingController: nameController,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          validator: FormValidators.nameValidator,
        ),
        const SizedBox(height: _SignupScreenState._fieldGap),
        AppTextField(
          hintTxt: 'Email',
          textEditingController: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: FormValidators.emailValidator,
        ),
        const SizedBox(height: _SignupScreenState._fieldGap),
        AppTextField(
          hintTxt: 'Password',
          textEditingController: passwordController,
          obscureTxt: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          validator: FormValidators.passwordValidator,
        ),
        const SizedBox(height: _SignupScreenState._fieldGap),
        AppTextField(
          hintTxt: 'Confirm Password',
          textEditingController: confirmPasswordController,
          obscureTxt: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          validator: (value) => FormValidators.confirmPasswordValidator(
            value,
            passwordController,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Sign Up'),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              'Already have an account?',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.body,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ],
    );
  }
}
