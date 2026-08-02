import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/drawer/drawer_screen/library/components/library_avatar.dart';
import 'package:library_management/drawer/drawer_screen/library/components/library_info_pill.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/services/manage_http_response.dart';

class LibrarySummaryCard extends StatelessWidget {
  const LibrarySummaryCard({
    super.key,
    required this.library,
    required this.isCurrent,
    required this.onActiveChanged,
    required this.onEdit,
    required this.scale,
  });

  final LibraryModel library;
  final bool isCurrent;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onEdit;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18 * scale),
        color: AppColors.surface,
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.border,
          width: isCurrent ? 2 * scale : 1 * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LibraryAvatar(title: library.libraryName, scale: scale),

                SizedBox(width: 14 * scale),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        library.libraryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.bold,
                          color: AppColors.heading,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Minimal Chips using strictly AppColors
                      Wrap(
                        spacing: 6 * scale,
                        runSpacing: 4 * scale,
                        children: [
                          if (library.whatsappNumber.isNotEmpty)
                            _buildInfoChip(
                              icon: Icons.phone_outlined,
                              label: library.whatsappNumber,
                              scale: scale,
                            ),
                          if (library.city.isNotEmpty)
                            _buildInfoChip(
                              icon: Icons.location_on_outlined,
                              label: library.city,
                              scale: scale,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3-Dots Options Menu
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.heading,
                    size: 22,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'edit_seat') {
                      Navigator.pushNamed(context, '/seat');
                    } else if (value == 'delete') {
                      showSnackBar(context, 'Delete feature coming soon');
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: AppColors.heading),
                          SizedBox(width: 10),
                          Text('Edit', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'edit_seat',
                      child: Row(
                        children: [
                          Icon(Icons.event_seat_outlined, size: 18, color: AppColors.heading),
                          SizedBox(width: 10),
                          Text('Edit Seat', style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 14 * scale),

            // Bottom Info Pill
            LibraryInfoPill(
              seats: library.totalSeats,
              isCurrent: isCurrent,
              onChanged: onActiveChanged,
              scale: scale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required double scale,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12 * scale, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11 * scale,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}
