import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/bulk_import/bulk_import_screen.dart';

class BulkImportBanner extends StatelessWidget {
  const BulkImportBanner({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 14 * scale),
      decoration: BoxDecoration(
        color: AppColors.primary, // Using AppColors.primary (0xFF536FE7) from theme
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: EdgeInsets.all(10 * scale),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12 * scale),
            ),
            child: Icon(
              Icons.group_add_rounded,
              color: Colors.white,
              size: 24 * scale,
            ),
          ),

          SizedBox(width: 14 * scale),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Members in Bulk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  'Import many members at once from Excel',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12 * scale,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10 * scale),

          // White Import Action Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BulkImportScreen()),
              );
            },
            borderRadius: BorderRadius.circular(20 * scale),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14 * scale,
                vertical: 8 * scale,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20 * scale),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.upload_file_rounded,
                    color: AppColors.primary,
                    size: 16 * scale,
                  ),
                  SizedBox(width: 4 * scale),
                  Text(
                    'Import',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.bold,
                    ),
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
