import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_actions.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_avatar.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card_footer.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card_style.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_information.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MemberCard extends StatelessWidget {
  // final MemberListItem member;
  // final MemberStatus status;
  // final VoidCallback onTap;
  //

  const MemberCard({
    super.key,
    // required this.member,
    // required this.status,
    // required this.onTap,
    // required this.onCall,
    // required this.onMessage,
    required this.onTap,
    this.img,
    this.expireDate,
    required this.memberNumber,
    required this.name,
    required this.plan,
    required this.status,
    required this.number,
    required this.message,
    this.pendingAmount,
    this.onRenew,
    this.onPaid,
    this.onGiveDiscount,
  });

  final VoidCallback onTap;
  final String? img;
  final int memberNumber;
  final String name;
  final DateTime? expireDate;
  final String plan;

  final MemberStatus status;
  final String number;
  final String message;

  final double? pendingAmount;

  final VoidCallback? onRenew;
  final VoidCallback? onPaid;
  final VoidCallback? onGiveDiscount;

  @override
  Widget build(BuildContext context) {
    final style = MemberCardStyle.fromStatus(status);

    return Material(
      color: style.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: style.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  MemberAvatar(
                    imageUrl: img,
                    backgroundColor: style.avatarBackground,
                    memberNumber: memberNumber,
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: MemberInformation(
                      statusColor: style.accent,
                      expireDate: expireDate,
                      memberName: name,
                      plan: plan,
                    ),
                  ),

                  const SizedBox(width: 8),

                  MemberActions(number: number, message: message),
                ],
              ),

              if (status == MemberStatus.expired ||
                  status == MemberStatus.expiring)
              //status == MemberStatus.pending)
              ...[
                const SizedBox(height: 12),

                Divider(height: 1, color: style.border),

                const SizedBox(height: 8),

                MemberCardFooter(
                  status: status,
                  pendingAmount: pendingAmount,
                  onRenew: onRenew,
                  onPaid: onPaid,
                  onGiveDiscount: onGiveDiscount,
                  date: expireDate,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
