import 'package:flutter/material.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'My Libraries'),
      body: Center(child: Text('My Library')),
    );
  }
}
