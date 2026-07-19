import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';

enum SlotMenuAction { edit, status, delete }

class SlotCard extends StatelessWidget {
  const SlotCard({
    super.key,
    required this.slotName,
    required this.startMinute,
    required this.endMinute,
    required this.price,
    required this.isActive,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onChangeStatus,
  });

  final String slotName;
  final int startMinute;
  final int endMinute;
  final String price;
  final bool isActive;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onChangeStatus;

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppColors.buttonPrimary.withValues(alpha: 0.2)
                  : const Color(0xffECEEF3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      slotName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17 * scale,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2D3748),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xffE8F0FF)
                          : const Color(0xffF2F4F7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xff3563E9)
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),

                  PopupMenuButton<SlotMenuAction>(
                    padding: EdgeInsets.zero,
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    icon: const Icon(
                      Icons.more_vert,
                      size: 18,
                      color: Color(0xff667085),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case SlotMenuAction.edit:
                          onEdit?.call();
                          break;

                        case SlotMenuAction.status:
                          onChangeStatus?.call();
                          break;

                        case SlotMenuAction.delete:
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        height: 36,
                        value: SlotMenuAction.edit,
                        child: _menuItems(
                          icon: Icons.edit_outlined,
                          text: 'Edit',
                        ),
                      ),
                      PopupMenuItem(
                        height: 36,
                        value: SlotMenuAction.status,
                        child: _menuItems(
                          icon: isActive
                              ? Icons.pause_circle_outline
                              : Icons.check_circle_outline,
                          text: isActive ? 'Deactivate' : 'Activate',
                        ),
                      ),

                      PopupMenuItem(
                        height: 36,
                        value: SlotMenuAction.delete,
                        child: _menuItems(
                          icon: Icons.delete_outline,
                          text: 'Delete',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Time
              Row(
                children: [
                  const Icon(
                    Icons.access_time_filled_rounded,
                    size: 16,
                    color: Color(0xff98A2B3),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${_formatTime(startMinute)} - ${_formatTime(endMinute)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// Price
              Text(
                price,
                style: TextStyle(
                  color: AppColors.buttonPrimaryHover,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatTime(int totalMinutes) {
  final hour = totalMinutes ~/ 60;
  final minute = totalMinutes % 60;

  final period = hour >= 12 ? "PM" : "AM";
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;

  return "${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
}

Widget _menuItems({required IconData icon, required String text}) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Color(0xff475467)),
      SizedBox(width: 12),
      Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
    ],
  );
}
