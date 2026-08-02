import 'package:flutter/material.dart';
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

  String _formatPriceDisplay(String rawPrice) {
    final clean = rawPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    final numVal = double.tryParse(clean);
    if (numVal == null) return rawPrice;
    final formatted = numVal.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    final String formattedPrice = _formatPriceDisplay(price);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEFF3F8), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Left Section: Title + Badge + Time Range
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Line 1: Slot Name + Active Status Badge
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            slotName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? "Active" : "Inactive",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Line 2: Clock Icon + Time Window Range
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${_formatTime(startMinute)} - ${_formatTime(endMinute)}",
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// Right Section: Price Tag + 3-Dot Circular Popup Menu
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Text(
                        "/mo",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  /// 3-Dot Circular Action Button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<SlotMenuAction>(
                      padding: EdgeInsets.zero,
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 18,
                        color: Color(0xFF2563EB),
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
                  ),
                ],
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
      Icon(icon, size: 16, color: const Color(0xFF475467)),
      const SizedBox(width: 12),
      Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    ],
  );
}
