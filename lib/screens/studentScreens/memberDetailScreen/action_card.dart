import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/action_item.dart';
import 'package:library_management/services/external_app_service.dart';

enum PendingAction { paid, discount }

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.scale,
    required this.phone,
    required this.message,
    required this.pending,
    required this.expiryDate,
  });
  final double scale;
  final String phone;
  final String message;
  final double pending;
  final DateTime expiryDate;

  @override
  Widget build(BuildContext context) {
    final bool canRenew = expiryDate.difference(DateTime.now()).inDays <= 10;
    return Container(
      height: 90 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/call.png',
                label: 'Call',
                color: AppColors.primary,
                onTap: () async {
                  await ExternalAppService.makePhoneCall(phone);
                },
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/whatsapp.png',
                label: 'WhatsApp',
                color: AppColors.whatsapp,
                onTap: () async {
                  await ExternalAppService.openWhatsApp(
                    phoneNumber: phone,
                    message: message,
                  );
                },
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                icon: Icons.forum_outlined,
                label: 'Message',
                color: AppColors.primary,
                onTap: () async {
                  await ExternalAppService.sendSms(
                    phoneNumber: phone,
                    message: message,
                  );
                },
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                //icon: Icons.refresh_rounded,
                iconImage: 'assets/icons/refund.png',
                label: 'Renew',
                color: canRenew ? AppColors.purple : AppColors.grey200,
                labelColor: canRenew ? AppColors.purple : AppColors.grey400,
                onTap: canRenew ? () async {} : null,
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/pending.png',
                label: 'Pending',
                color: pending > 0 ? AppColors.purple : AppColors.grey200,
                labelColor: pending > 0 ? AppColors.purple : AppColors.grey400,
                onTap: pending > 0
                    ? () async {
                        final PendingAction? action = await showPendingDialog(
                          context,
                          pending,
                        );

                        switch (action) {
                          case PendingAction.paid:
                            break;
                          case PendingAction.discount:
                            break;
                          case null:
                            break;
                        }
                      }
                    : null,
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/refund.png',
                label: 'Refund',
                color: pending > 0 ? AppColors.purple : AppColors.grey200,
                labelColor: pending > 0 ? AppColors.purple : AppColors.grey400,
                onTap: pending > 0
                    ? () async {
                        final PendingAction? action = await showPendingDialog(
                          context,
                          pending,
                        );

                        switch (action) {
                          case PendingAction.paid:
                            break;
                          case PendingAction.discount:
                            break;
                          case null:
                            break;
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<PendingAction?> showPendingDialog(BuildContext context, double pending) {
  return showDialog<PendingAction>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text("Pending Amount"),
        content: Text("Pending Amount: ₹$pending"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, PendingAction.discount);
            },
            child: const Text("Discount"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, PendingAction.paid);
            },
            child: const Text("Paid"),
          ),
        ],
      );
    },
  );
}

class _ActionDivider extends StatelessWidget {
  final double scale;

  const _ActionDivider({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 60 * scale, color: AppColors.divider);
  }
}
