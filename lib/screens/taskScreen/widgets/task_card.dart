import 'package:flutter/material.dart';

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
  });

  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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

  String get _formattedDate {
    return '${widget.dueDate.day.toString().padLeft(2, '0')}-'
        '${widget.dueDate.month.toString().padLeft(2, '0')}-'
        '${widget.dueDate.year}';
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
        //borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 16, 10, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isOverdue
                  ? const Color(0xFFFECACA)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              _TaskCheckbox(
                isCompleted: widget.isCompleted,
                onChanged: widget.onChanged,
              ),

              const SizedBox(width: 8),

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
                          fontSize: 18,
                          height: 1.3,
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

                    const SizedBox(height: 7),

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
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Due date
                    _DueDate(date: _formattedDate, isOverdue: _isOverdue),
                  ],
                ),
              ),

              const SizedBox(width: 4),

              // Actions remain fixed at top
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isCompleted)
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      tooltip: 'Edit task',
                      onTap: widget.onEdit,
                    ),

                  if (!widget.isCompleted) const SizedBox(height: 6),

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
        ),
      ),
    );
  }
}

class _DueDate extends StatelessWidget {
  const _DueDate({required this.date, required this.isOverdue});

  final String date;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: isOverdue ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: isOverdue
                ? const Color(0xFFDC2626)
                : const Color(0xFF667085),
          ),

          const SizedBox(width: 7),

          Text(
            date,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isOverdue
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF667085),
            ),
          ),

          if (isOverdue) ...[
            const SizedBox(width: 7),
            const Text(
              'Overdue',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626),
              ),
            ),
          ],
        ],
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
      width: 28,
      height: 28,
      child: Transform.scale(
        scale: 1.15,
        child: Checkbox(
          value: isCompleted,
          onChanged: onChanged,
          activeColor: const Color(0xFF45AD78),
          checkColor: Colors.white,
          side: BorderSide(
            width: 1.8,
            color: isCompleted
                ? const Color(0xFF45AD78)
                : const Color(0xFF98A2B3),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
            size: 22,
            color: isDestructive
                ? const Color(0xFFDC2626)
                : const Color(0xFF667085),
          ),
        ),
      ),
    );
  }
}
