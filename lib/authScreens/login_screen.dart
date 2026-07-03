import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/authScreens/signup_screen.dart';
import 'package:library_management/components/app_logo_header.dart';
import 'package:library_management/components/app_text_field.dart';
import 'package:library_management/controllers/user_controller.dart';
import 'package:library_management/validator/form_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // static const double _maxContentWidth = 420;
  static const double _fieldGap = 8;

  bool _isLoading = false;
  final _userController = UserController();

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

  Future<void> _submitSignin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print(_emailController.text);

    try {
      await _userController.signIn(
        context: context,
        ref: ref,
        email: _emailController.text,
        password: _passwordController.text,
      );
      TextInput.finishAutofillContext();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                  child: AutofillGroup(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppLogoHeader(
                          logoSize: logoSize,
                          heading: 'Login',
                          subHeading: 'Reach to your Account',
                        ),
                        const SizedBox(height: 64),
                        _SigninForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onSubmit: _submitSignin,
                          loading: _isLoading,
                        ),
                      ],
                    ),
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

class _SigninForm extends StatelessWidget {
  const _SigninForm({
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.loading,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          hintTxt: 'Email',
          textEditingController: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: FormValidators.emailValidator,
        ),
        const SizedBox(height: _LoginScreenState._fieldGap),
        AppTextField(
          hintTxt: 'Password',
          textEditingController: passwordController,
          obscureTxt: true,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          validator: FormValidators.passwordValidator,
        ),

        const SizedBox(height: 20),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: loading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: loading
                ? Center(child: CircularProgressIndicator())
                : const Text('Sign In'),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: TextButton(
            onPressed: () {
              // TODO: Navigate to Forgot Password Screen
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => const ForgotPasswordScreen(),
              //   ),
              // );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text(
              "Don't have an account?",
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.body,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ],
    );
  }
}
