import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/widgets/card/info_row.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
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

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
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
                            ? Icon(Icons.person, color: Colors.white, size: 45)
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
                          onPressed: () {
                            makePhoneCall("7905615826");
                          },
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
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
