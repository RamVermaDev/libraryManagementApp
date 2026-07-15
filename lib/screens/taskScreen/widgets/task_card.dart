import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
    this.scale = 1,
    required this.urgency,
  });

  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String urgency;

  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final double scale;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isExpanded = false;

  bool get _isOverdue {
    if (widget.isCompleted) return false;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final dueDate = DateTime(
      widget.dueDate.year,
      widget.dueDate.month,
      widget.dueDate.day,
    );

    return dueDate.isBefore(today);
  }

  void _toggleCard() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleCard,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 10, 10, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isOverdue
                  ? const Color(0xFFFECACA)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(width: 300 * widget.scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AssignTask(
                    scale: widget.scale,
                    assignFrom: 'ADMIN',
                    assignTo: 'RECEPTION',
                  ),
                  // Actions remain fixed at top
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!widget.isCompleted)
                        _ActionButton(
                          icon: Icons.edit_outlined,
                          tooltip: 'Edit task',
                          onTap: widget.onEdit,
                        ),

                      if (!widget.isCompleted)
                        SizedBox(height: 6 * widget.scale),

                      _ActionButton(
                        icon: Icons.delete_outline_rounded,
                        tooltip: 'Delete task',
                        onTap: widget.onDelete,
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2 * widget.scale),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  _TaskCheckbox(
                    isCompleted: widget.isCompleted,
                    onChanged: widget.onChanged,
                    scale: widget.scale,
                  ),

                  SizedBox(width: 8 * widget.scale),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.title,
                            maxLines: _isExpanded ? null : 1,
                            overflow: _isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16 * widget.scale,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                              color: widget.isCompleted
                                  ? const Color(0xFF98A2B3)
                                  : const Color(0xFF0B1F44),
                              decoration: widget.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Description
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.description,
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ),

                        SizedBox(height: 22 * widget.scale),

                        // Due date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _DueDate(
                              date: DateFormatter.shortDateWithYear(
                                widget.dueDate,
                              ),
                              isOverdue: _isOverdue,
                              scale: widget.scale,
                            ),

                            _Urgency(
                              urgency: widget.urgency,
                              scale: widget.scale,
                            ),
                          ],
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

class _Urgency extends StatelessWidget {
  const _Urgency({required this.urgency, required this.scale});

  final String urgency;
  final double scale;

  @override
  Widget build(Object context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonPrimaryHover,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      margin: EdgeInsets.only(right: 10),
      child: Text(
        urgency.toUpperCase(),
        style: TextStyle(
          fontSize: 8 * scale,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DueDate extends StatelessWidget {
  const _DueDate({
    required this.date,
    required this.isOverdue,
    required this.scale,
  });

  final String date;
  final bool isOverdue;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOverdue
            ? const Color.fromARGB(105, 254, 242, 242)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14 * scale,
            color: isOverdue ? AppColors.error : AppColors.buttonPrimary,
          ),

          SizedBox(width: 4 * scale),

          SizedBox(width: 7 * scale),

          Text(
            date,
            style: TextStyle(
              fontSize: 10 * scale,
              fontWeight: FontWeight.w600,
              color: isOverdue ? AppColors.error : AppColors.buttonPrimaryHover,
            ),
          ),

          if (isOverdue) ...[
            const SizedBox(width: 7),
            Container(
              height: 5 * scale,
              width: 5 * scale,
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              'Overdue',
              style: TextStyle(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssignTask extends StatelessWidget {
  const _AssignTask({
    required this.scale,
    required this.assignFrom,
    required this.assignTo,
  });

  final String assignFrom;
  final String assignTo;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.fromLTRB(28, 0, 0, 0),
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            assignFrom,
            style: TextStyle(
              fontSize: 8 * scale,
              fontWeight: FontWeight.w500,
              color: AppColors.buttonPrimary,
            ),
          ),
          SizedBox(width: 10 * scale),
          Container(
            height: 4 * scale,
            width: 4 * scale,
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 28 * scale,
            height: 0.7 * scale,
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          Container(
            height: 4 * scale,
            width: 4 * scale,
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 7 * scale),

          Text(
            assignTo,
            style: TextStyle(
              fontSize: 8 * scale,
              fontWeight: FontWeight.w500,
              color: AppColors.buttonPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// class _TaskCheckbox extends StatelessWidget {
//   const _TaskCheckbox({required this.isCompleted, required this.onChange});

//   final bool isCompleted;
//   final ValueChanged<bool> onChange;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onChange(!isCompleted),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 180),
//         width: 24,
//         height: 24,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isCompleted ? const Color(0xFF45AD78) : Colors.transparent,
//           border: Border.all(
//             color: isCompleted
//                 ? const Color(0xFF45AD78)
//                 : const Color(0xFF98A2B3),
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }

class _TaskCheckbox extends StatelessWidget {
  const _TaskCheckbox({
    required this.isCompleted,
    required this.onChanged,
    required this.scale,
  });

  final bool isCompleted;
  final ValueChanged<bool?> onChanged;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22 * scale,
      height: 22 * scale,

      child: Transform.scale(
        scale: 1.1 * scale,
        child: Checkbox(
          value: isCompleted,
          onChanged: onChanged,
          activeColor: AppColors.buttonPrimary,
          checkColor: Colors.white,
          side: BorderSide(
            width: 1.8,
            color: isCompleted
                ? const Color(0xFF45AD78)
                : const Color(0xFF98A2B3),
          ),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: isDestructive
                ? AppColors.error
                : AppColors.buttonPrimaryHover,
          ),
        ),
      ),
    );
  }
}
