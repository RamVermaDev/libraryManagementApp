import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/widgets/card/info_row.dart';

class DueStudentCard extends StatelessWidget {
  const DueStudentCard({
    super.key,
    required this.onTap,
    this.img,
    this.studentNumber = 0,
    required this.studentName,
    required this.lableOne,
    required this.valueOne,
    required this.lableTwo,
    required this.valueTwo,
    this.cardItemsColor = AppColors.activeButtonText,
  });
  final VoidCallback onTap;
  final String? img;
  final int studentNumber;
  final String studentName;
  final String lableOne;
  final String valueOne;
  final String lableTwo;
  final String valueTwo;
  final Color cardItemsColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: cardItemsColor,
                              child: img == null
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 45,
                                    )
                                  : Image.network(img!, fit: BoxFit.cover),
                            ),
                            SizedBox(height: 4),
                            Text(
                              studentNumber.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 2),
                              InfoRow(label: lableOne, value: valueOne),

                              InfoRow(label: lableTwo, value: valueTwo),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Center(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.call, size: 30),
                                color: cardItemsColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.secondary100,
                    border: Border(top: BorderSide(width: 0.4)),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InfoRow(label: 'Pending', value: '200'),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Paid',
                                style: TextStyle(
                                  color: AppColors.activeButtonText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Discount',
                                style: TextStyle(
                                  color: AppColors.buttonSecondaryHover,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
