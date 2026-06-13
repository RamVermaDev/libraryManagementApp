import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/authScreens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/library_logo.png'),
                      SizedBox(height: 40),
                      Text(
                        'MY LIBRARY PRO',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight(900),
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your Library Organised',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight(500),
                          color: AppColors.heading,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 56),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignupScreen();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Let's Start", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_right_alt),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
