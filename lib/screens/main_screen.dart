import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/custom_bottom_navigation_bar.dart';
import 'package:library_management/drawer/drawer_layout.dart';
import 'package:library_management/screens/revenueScreen/revenue_analytic_screen.dart';
import 'package:library_management/screens/studentsScreen/students_screen.dart';
import 'package:library_management/screens/taskScreen/task_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final screens = [StudentsScreen(), TaskScreen(), RevenueAnalyticsScreen()];

  int _selectedIndex = 0;

  final screnName = ['STUDENTS', 'TASKS', 'REVENUE'];

  bool _isScrolled = false;

  void onScrollChanged(bool value) {
    if (_isScrolled != value) {
      setState(() {
        _isScrolled = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar
      appBar: AppBar(
        title: Text(
          screnName[_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: AppColors.background,
        centerTitle: true,
        //forceMaterialTransparency: true,
      ),

      //Drawer
      drawer: DrawerLayout(),

      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),

      body: screens[_selectedIndex],
    );
  }
}



// actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) {
        //             return TaskFormScreen();
        //           },
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.add),
        //   ),
        // ],

//Bottom Navigator
      // bottomNavigationBar: Container(
      //   height: 80,

      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(16),
      //       topRight: Radius.circular(16),
      //     ),
      //     color: Colors.amber,
      //   ),
      //   child: Theme(
      //     data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      //     child: BottomNavigationBar(
      //       currentIndex: _selectedIndex,
      //       onTap: (index) {
      //         setState(() => _selectedIndex = index);
      //       },
      //       type: BottomNavigationBarType.fixed,
      //       backgroundColor: Colors.transparent,
      //       elevation: 8,

      //       selectedItemColor: AppColors.primary,
      //       unselectedItemColor: Colors.grey,

      //       selectedFontSize: 15,
      //       unselectedFontSize: 13,

      //       selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      //       unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

      //       items: const [
      //         BottomNavigationBarItem(
      //           activeIcon: Icon(Icons.people),
      //           icon: Icon(Icons.people_outline),
      //           label: 'Students',
      //         ),
      //         BottomNavigationBarItem(
      //           activeIcon: Icon(Icons.assignment),
      //           icon: Icon(Icons.assignment_outlined),
      //           label: 'Tasks',
      //         ),
      //         BottomNavigationBarItem(
      //           activeIcon: Icon(Icons.currency_rupee),
      //           icon: Icon(Icons.currency_rupee_outlined),
      //           label: 'Revenue',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
