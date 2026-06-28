import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/auth_gate.dart';
import 'package:library_management/drawer/drawer_screen/available_seat_screen.dart';
import 'package:library_management/drawer/drawer_screen/enrolement_fee_screen.dart';
import 'package:library_management/drawer/drawer_screen/library/my_library_screen.dart';
import 'package:library_management/drawer/drawer_screen/profile/my_profile_screen.dart';
import 'package:library_management/drawer/drawer_screen/plan_setup_screen.dart';
import 'package:library_management/drawer/drawer_screen/program_setup_screen.dart';
import 'package:library_management/drawer/drawer_screen/subscription_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/profile': (context) => const MyProfileScreen(),
        '/library': (context) => const MyLibraryScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/enrolement': (context) => const EnrolementFeeScreen(),
        '/plan': (context) => const PlanSetupScreen(),
        '/program': (context) => const ProgramSetupScreen(),
        '/seat': (context) => const AvailableSeatScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Library Pro',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
    );
  }
}
