import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/drawer/drawer_screen/library/components/library_avatar.dart';
import 'package:library_management/drawer/drawer_screen/library/components/library_edit_button.dart';
import 'package:library_management/drawer/drawer_screen/library/components/library_info_pill.dart';
import 'package:library_management/models/library_model.dart';

class LibrarySummaryCard extends StatelessWidget {
  const LibrarySummaryCard({
    super.key,
    required this.library,
    required this.isCurrent,
    required this.onActiveChanged,
    required this.onEdit,
  });

  final LibraryModel library;
  final bool isCurrent;

  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return AnimatedScale(
      scale: isCurrent ? 1.0 : .98,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white,
          border: Border.all(
            color: isCurrent ? AppColors.primary : Colors.grey.shade200,
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? AppColors.primary.withValues(alpha: .10)
                  : Colors.black.withValues(alpha: .05),
              blurRadius: isCurrent ? 26 : 18,
              spreadRadius: isCurrent ? 1 : 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LibraryAvatar(title: library.libraryName, scale: scale),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          library.libraryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),
                        _rowTitle(
                          name: library.whatsappNumber,
                          icon: Icons.call_outlined,
                        ),

                        const SizedBox(height: 2),
                        _rowTitle(
                          name: library.city,
                          icon: Icons.location_city_outlined,
                        ),
                      ],
                    ),
                  ),

                  LibraryEditButton(onTap: onEdit, scale: scale),
                ],
              ),

              const SizedBox(height: 16),

              //-----------------------------------
              // Bottom Glass Pill
              //-----------------------------------
              LibraryInfoPill(
                seats: library.totalSeats,
                isCurrent: isCurrent,
                onChanged: onActiveChanged,
                scale: scale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _rowTitle({required String name, required IconData icon}) {
  return Row(
    children: [
      Icon(icon, color: AppColors.grey700, size: 14),
      SizedBox(width: 6),
      Text(
        name,
        style: TextStyle(color: AppColors.grey700, fontSize: 12, height: 1.35),
      ),
    ],
  );
}
