import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class TaskUrgency extends StatelessWidget {
  const TaskUrgency({
    super.key,
    required this.selectedUrgency,
    required this.onChanged,
  });

  final String selectedUrgency;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _UrgencyButton(
              title: 'High',
              description: '3 Days',
              isSelected: selectedUrgency == 'high',
              onTap: () => onChanged('high'),
              color: AppColors.grey600,
            ),

            const SizedBox(width: 10),

            _UrgencyButton(
              title: 'Medium',
              description: '6 Days',
              isSelected: selectedUrgency == 'medium',
              onTap: () => onChanged('medium'),
              color: AppColors.grey500,
            ),

            const SizedBox(width: 10),

            _UrgencyButton(
              title: 'Low',
              description: '10 Days',
              isSelected: selectedUrgency == 'low',
              onTap: () => onChanged('low'),
              color: AppColors.grey400,
            ),
          ],
        ),
      ],
    );
  }
}

class _UrgencyButton extends StatelessWidget {
  const _UrgencyButton({
    required this.title,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: onTap,
        child: AnimatedContainer(
          height: 50,
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: .02) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.buttonPrimary
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 1 : 0,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: color.withValues(alpha: .15),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.activeButtonText
                      : AppColors.black,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF64748B),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
