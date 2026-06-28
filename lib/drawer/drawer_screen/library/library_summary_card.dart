import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_screen/library/library_detail_screen.dart';
import 'package:library_management/models/library_model.dart';

class LibrarySummaryCard extends StatelessWidget {
  const LibrarySummaryCard({super.key, required this.library});

  final LibraryModel library;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.caption,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LibraryDetailScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0E6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_library_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          library.libraryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.heading,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${library.city}, ${library.state}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.body),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.caption),
                ],
              ),
              if (library.tagLine.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  library.tagLine,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.body),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  _SummaryItem(
                    icon: Icons.people_outline,
                    label: 'Students',
                    value: library.totalStudents.toString(),
                  ),
                  const SizedBox(width: 12),
                  _SummaryItem(
                    icon: Icons.event_seat_outlined,
                    label: 'Seats',
                    value: '${library.availableSeats}/${library.totalSeats}',
                  ),
                  const Spacer(),
                  _StatusChip(status: library.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: AppColors.caption),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withOpacity(0.12)
            : AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isActive ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}
