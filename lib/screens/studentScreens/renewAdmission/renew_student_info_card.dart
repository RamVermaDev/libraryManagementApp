import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

class RenewStudentInfoCard extends StatelessWidget {
  const RenewStudentInfoCard({
    super.key,
    required this.member,
    required this.scale,
    this.slotDisplay,
    this.seatDisplay,
  });

  final StudentModel member;
  final double scale;
  final String? slotDisplay;
  final String? seatDisplay;

  String _formattedDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = member.currentExpireDate != null &&
        member.currentExpireDate!.isBefore(DateTime.now());

    final statusBgColor = isExpired
        ? AppColors.error.withValues(alpha: .1)
        : AppColors.success.withValues(alpha: .1);

    final statusTextColor = isExpired ? AppColors.error : AppColors.success;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FB),
        borderRadius: BorderRadius.circular(18 * scale),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Student Info Column
          Padding(
            padding: EdgeInsets.all(14 * scale),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 26 * scale,
                  backgroundColor: Colors.white,
                  backgroundImage: member.profileImage != null &&
                          member.profileImage!.isNotEmpty
                      ? NetworkImage(member.profileImage!)
                      : null,
                  child: (member.profileImage == null ||
                          member.profileImage!.isEmpty)
                      ? Text(
                          member.name.isNotEmpty
                              ? member.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 20 * scale,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 12 * scale),

                // Name, Phone & Expiry Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: TextStyle(
                          fontSize: 17 * scale,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 6 * scale),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14 * scale,
                            color: AppColors.grey600,
                          ),
                          SizedBox(width: 6 * scale),
                          Text(
                            member.phone,
                            style: TextStyle(
                              fontSize: 13 * scale,
                              color: AppColors.grey600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4 * scale),
                      Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 14 * scale,
                            color:
                                isExpired ? AppColors.error : AppColors.grey600,
                          ),
                          SizedBox(width: 6 * scale),
                          Text(
                            'Expires: ${_formattedDate(member.currentExpireDate)}',
                            style: TextStyle(
                              fontSize: 13 * scale,
                              color: isExpired
                                  ? AppColors.error
                                  : AppColors.grey600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * scale,
                    vertical: 5 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12 * scale),
                  ),
                  child: Text(
                    isExpired ? 'Expired' : 'Active',
                    style: TextStyle(
                      fontSize: 11 * scale,
                      fontWeight: FontWeight.w700,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border.withValues(alpha: 0.7),
          ),

          // Bottom Section: Previous Slot & Previous Seat Row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14 * scale,
              vertical: 10 * scale,
            ),
            child: Row(
              children: [
                // Previous Slot
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15 * scale,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6 * scale),
                      Expanded(
                        child: Text(
                          slotDisplay ?? 'Loading slot...',
                          style: TextStyle(
                            fontSize: 12 * scale,
                            fontWeight: FontWeight.w600,
                            color: AppColors.heading,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10 * scale),

                // Previous Seat
                Row(
                  children: [
                    Icon(
                      Icons.event_seat_outlined,
                      size: 15 * scale,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6 * scale),
                    Text(
                      seatDisplay ?? (member.seatId != null ? 'Seat assigned' : 'No seat'),
                      style: TextStyle(
                        fontSize: 12 * scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
