import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/screens/studentScreens/widgets/card/info_row.dart';
import 'package:library_management/screens/studentScreens/widgets/card/student_detail_card.dart';
import 'package:library_management/screens/studentScreens/widgets/receipt_container.dart';
import 'package:library_management/screens/studentScreens/widgets/student_detail_container.dart';
import 'package:library_management/screens/studentScreens/widgets/student_detail_payment_container.dart';

class StudentDetailedScreen extends StatelessWidget {
  const StudentDetailedScreen({
    super.key,
    this.img,
    required this.studentNumber,
  });

  final String? img;
  final int studentNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Student Detail',
        actionIcon: Icons.edit_document,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(16, 30, 16, 30),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: AppColors.activeButton,
                        child: img == null
                            ? Icon(Icons.person, color: Colors.white, size: 45)
                            : Image.network(img!, fit: BoxFit.cover),
                      ),
                      SizedBox(height: 4),
                      Text(
                        studentNumber.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 6),
                      InfoRow(label: 'Gender', value: 'Male'),
                      SizedBox(height: 2),
                      InfoRow(label: 'Phone', value: '9999999999'),
                      SizedBox(height: 2),
                      InfoRow(label: 'ID Proof', value: 'XXXXXXXXXXXX'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 15),
              Row(
                children: [
                  StudentDetailCard(icon: Icons.call, title: 'Call'),
                  SizedBox(width: 6),
                  StudentDetailCard(icon: Icons.message, title: 'WhatsApp'),
                  SizedBox(width: 6),
                  StudentDetailCard(icon: Icons.money, title: 'Pay'),
                  SizedBox(width: 6),
                  StudentDetailCard(icon: Icons.refresh, title: 'Renew'),
                ],
              ),
              SizedBox(height: 30),
              StudentDetailContainer(),

              SizedBox(height: 30),

              StudentDetailPaymentContainer(
                amount: '2000',
                title: 'Total Amount',
              ),
              SizedBox(height: 10),
              StudentDetailPaymentContainer(
                amount: '500',
                title: 'Total Discount',
              ),
              SizedBox(height: 10),
              StudentDetailPaymentContainer(
                amount: '200',
                title: 'Total Pending',
                containerColor: const Color.fromARGB(76, 244, 67, 54),
              ),
              SizedBox(height: 20),

              ReceiptContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
