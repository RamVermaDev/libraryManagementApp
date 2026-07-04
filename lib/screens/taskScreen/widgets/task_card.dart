import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
    required this.onChanged,
  });

  final String title;
  final String description;
  final String date;
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 110),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: isCompleted ? Color.fromARGB(255, 2, 34, 17) : null,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TaskCheckbox(
                      isCompleted: isCompleted,
                      onChanged: onChanged,
                    ),

                    const SizedBox(width: 22),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0B1F44),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Color(0xFF667085),
                                  ),

                                  const SizedBox(width: 7),

                                  Text(
                                    date,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCheckbox extends StatelessWidget {
  const _TaskCheckbox({required this.isCompleted, required this.onChanged});

  final bool isCompleted;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Transform.scale(
        scale: 1.3,
        child: Checkbox(
          value: isCompleted,
          onChanged: onChanged,
          activeColor: const Color(0xFF45AD78),
          checkColor: Colors.white,
          side: BorderSide(
            width: 2,
            color: isCompleted
                ? const Color(0xFF45AD78)
                : const Color(0xFF667085),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        ),
      ),
    );
  }
}
