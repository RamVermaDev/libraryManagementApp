import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_actions.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_avatar.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card_footer.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_information.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.onTap,
    this.img,
    this.expireDate,
    required this.memberNumber,
    this.idProof,
    required this.name,
    required this.plan,
    this.slotTiming,
    this.seatNumber,
    required this.status,
    this.rawStatus,
    required this.number,
    required this.message,
    this.pendingAmount,
    this.onRenew,
    this.onPause,
    this.onResume,
    this.onUnblock,
  });

  final VoidCallback onTap;
  final String? img;
  final int memberNumber;
  final String? idProof;
  final String name;
  final DateTime? expireDate;
  final String plan;
  final String? slotTiming;
  final String? seatNumber;

  final MemberStatus status;
  final String? rawStatus;
  final String number;
  final String message;

  final double? pendingAmount;

  final VoidCallback? onRenew;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onUnblock;

  @override
  Widget build(BuildContext context) {
    final String displayId = (idProof != null && idProof!.trim().isNotEmpty)
        ? 'ID: ${idProof!.trim()}'
        : 'ID: ${memberNumber.toString().padLeft(3, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Row: Avatar + Name/ID + Call/Message/WhatsApp
                Row(
                  children: [
                    MemberAvatar(
                      imageUrl: img,
                      size: 52,
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            displayId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Quick Action Buttons (Call, Message, WhatsApp)
                    MemberActions(
                      number: number,
                      message: message,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 2. Middle Info Grid (Plan, Expires, Timing, Seat)
                MemberInformation(
                  plan: plan,
                  expireDate: expireDate,
                  slotTiming: slotTiming,
                  seatNumber: seatNumber,
                ),

                const SizedBox(height: 18),

                // 3. Footer Row: Status Pill Badge + Dynamic Action Button
                MemberCardFooter(
                  status: status,
                  rawStatus: rawStatus,
                  expireDate: expireDate,
                  onRenew: onRenew,
                  onPause: onPause,
                  onResume: onResume,
                  onUnblock: onUnblock,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
