import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/drawer/drawer_screen/library/library_setup_screen.dart';

Future<void> showCreateLibraryRequiredDialog(BuildContext context) async {
  final double scale = context.scale;
  final shouldCreate = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SizedBox(
          width: 350 * scale,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon in a soft circular container
                Container(
                  width: 30 * scale,
                  height: 30 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.local_library_rounded,
                    size: 25 * scale,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 25 * scale),

                // Title
                Text(
                  'Create Library',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16 * scale,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 4 * scale),

                // Subtitle
                Text(
                  'Set up your library to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11 * scale,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 28 * scale),

                // Primary action
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * scale,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Secondary action (dismiss)
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10 * scale,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (shouldCreate == true && context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LibrarySetupScreen()),
    );
  }
}
