import 'package:flutter/material.dart';
import 'package:library_management/authScreens/signup_screen.dart';
import 'package:library_management/components/app_button.dart';
import 'package:library_management/components/app_logo_header.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = (constraints.maxWidth * 0.06)
                .clamp(20.0, 32.0)
                .toDouble();
            final logoSize = (constraints.maxHeight * 0.3)
                .clamp(150.0, 200.0)
                .toDouble();

            return Center(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    24,
                  ),
                  child: Column(
                    children: [
                      Expanded(child: AppLogoHeader(logoSize: logoSize)),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          screenChange: SignupScreen(),
                          buttonText: "Let's Start",
                          buttonRoutes: true,
                          buttonIcon: true,
                        ),
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
