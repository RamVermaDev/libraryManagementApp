import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

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
                      SizedBox(height: 25),
                      Text(
                        'My Library Pro',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight(800),
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 5),
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
                ElevatedButton(onPressed: () {}, child: Text("Let's Start")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
