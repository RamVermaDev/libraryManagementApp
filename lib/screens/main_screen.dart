import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_layout.dart';
import 'package:library_management/screens/revenueScreen/revenue_screen.dart';
import 'package:library_management/screens/studentsScreen/students_screen.dart';
import 'package:library_management/screens/taskScreen/task_form_screen.dart';
import 'package:library_management/screens/taskScreen/task_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final screens = [StudentsScreen(), TaskScreen(), RevenueAnalyticsScreen()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar
      appBar: AppBar(
        title: const Text(
          "Svadhyaya Library",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.inputBorder,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TaskFormScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      //Drawer
      drawer: DrawerLayout(),

      //Bottom Navigator
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        indicatorColor: AppColors.background,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.people), label: 'Students'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'To-Do'),
          NavigationDestination(
            icon: Icon(Icons.currency_rupee),
            label: 'Income',
          ),
        ],
      ),

      body: screens[_selectedIndex],
    );
  }
}
