import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/authScreens/login_screen.dart';
import 'package:library_management/components/app_text_field.dart';
import 'package:library_management/validator/form_validators.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    children: [
                      Image(
                        image: AssetImage('assets/images/library_logo.png'),
                        height: 120,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight(800),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  AppTextField(
                    hintTxt: 'Name',
                    textEditingController: nameController,
                    validator: (value) => FormValidators.nameValidator(value),
                  ),
                  SizedBox(height: 10),
                  AppTextField(
                    hintTxt: 'Email',
                    textEditingController: emailController,
                    validator: (value) => FormValidators.emailValidator(value),
                  ),
                  SizedBox(height: 10),
                  AppTextField(
                    hintTxt: 'Password',
                    textEditingController: passwordController,
                    obscureTxt: true,
                    validator: (value) =>
                        FormValidators.passwordValidator(value),
                  ),
                  SizedBox(height: 10),
                  AppTextField(
                    hintTxt: 'Confirm Password',
                    textEditingController: confirmPasswordController,
                    validator: (value) =>
                        FormValidators.confirmPasswordValidator(
                          value,
                          passwordController,
                        ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(nameController.text);
                        print(emailController.text);
                        print(passwordController.text);
                      } else {
                        // At least one field is invalid
                        print("Form Invalid");
                      }
                    },
                    child: Text("Sign Up"),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have a Account?',
                        style: TextStyle(fontWeight: FontWeight(500)),
                      ),
                      SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
