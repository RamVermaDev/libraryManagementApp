import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_screen/library/library_detail_screen.dart';
import 'package:library_management/models/library_model.dart';

class LibrarySummaryCard extends StatelessWidget {
  const LibrarySummaryCard({super.key, required this.library});

  final LibraryModel library;

  String getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));

    if (words.isEmpty) return "";

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return (words.first[0] + words.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getInitials(library.libraryName),
                      style: TextStyle(
                        color: AppColors.grey900,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          library.libraryName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          library.tagLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.heading),
                        ),
                      ],
                    ),
                  ),

                  //this will become tick for active library
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LibraryDetailScreen();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.edit, color: AppColors.caption),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              Container(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(172, 255, 255, 255),
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 50,
                child: Row(
                  children: [
                    _SummaryItem(
                      label: 'Students',
                      value: library.totalStudents.toString(),
                    ),
                    const SizedBox(width: 12),
                    _SummaryItem(
                      label: 'Seats',
                      value: (library.totalSeats).toString(),
                    ),
                    const Spacer(),
                    _StatusChip(status: library.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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
            ? AppColors.buttonSecondary
            : AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: isActive ? AppColors.background : AppColors.error,
        ),
      ),
    );
  }
}
