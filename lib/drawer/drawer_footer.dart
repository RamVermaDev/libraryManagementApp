import 'package:flutter/material.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Setting',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 8),
          Text('Any Complain', style: TextStyle(color: Colors.deepPurple)),
          SizedBox(height: 4),
          Text('Need Help ?', style: TextStyle(color: Colors.deepPurple)),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
