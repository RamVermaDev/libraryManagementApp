import 'package:flutter/material.dart';

class DrawerHeading extends StatelessWidget {
  const DrawerHeading({
    super.key,
    required this.libraryName,
    this.padding = 12.0,
  });

  final String libraryName;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('hi', style: TextStyle(fontSize: 18)),

          //this we baset on backend data from the server
          Text(
            libraryName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
