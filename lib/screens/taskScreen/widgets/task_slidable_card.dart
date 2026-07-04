import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'task_swipe_action.dart';

class TaskSlidableCard extends StatelessWidget {
  const TaskSlidableCard({
    super.key,
    required this.taskId,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    this.horizontalPadding = 16,
  });

  final String taskId;
  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(taskId),

      groupTag: 'task-cards',

      // Swipe from left to right → Edit
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          TaskSwipeAction(
            icon: Icons.edit_outlined,
            label: 'Edit',
            backgroundColor: const Color(0xFF3498DB),
            onTap: onEdit,
          ),
        ],
      ),

      // Swipe from right to left → Delete
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.28,
        children: [
          TaskSwipeAction(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            backgroundColor: const Color(0xFFEF4444),
            onTap: onDelete,
          ),
        ],
      ),

      // Only the card gets side padding.
      // The Slidable itself remains full width.
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: child,
      ),
    );
  }
}
