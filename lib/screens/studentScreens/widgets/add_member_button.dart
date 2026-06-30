import 'package:flutter/material.dart';

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 55,
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,

        child: Row(
          children: [
            Text(
              'Add Members',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
