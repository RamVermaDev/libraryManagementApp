import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/card_decoration.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/profile_info.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.scale,
    required this.name,
    required this.phone,
    required this.id,
    required this.number,
  });

  final double scale;
  final String name;
  final String phone;
  final String? id;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        21 * scale,
        23 * scale,
        20 * scale,
        25 * scale,
      ),
      decoration: cardDecoration(radius: 20 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 96 * scale,
                height: 96 * scale,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  size: 72 * scale,
                  color: const Color(0xFF7896F1),
                ),
              ),

              SizedBox(height: 11 * scale),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14 * scale,
                  vertical: 7 * scale,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10 * scale),
                ),
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    color: AppColors.primarys,
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 25 * scale),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.darkText,
                      fontSize: 22 * scale,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),

                  SizedBox(height: 16 * scale),

                  // ProfileInfo(
                  //   scale: scale,
                  //   icon: Icons.person_rounded,
                  //   text: 'Male',
                  // ),

                  //SizedBox(height: 13 * scale),
                  ProfileInfo(
                    scale: scale,
                    icon: Icons.phone_rounded,
                    text: '+91 $phone',
                  ),

                  SizedBox(height: 13 * scale),

                  ProfileInfo(
                    scale: scale,
                    icon: Icons.mail_rounded,
                    text: id ?? 'N/A',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
