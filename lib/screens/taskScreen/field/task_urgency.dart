import 'package:flutter/material.dart';

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
              title: 'Low',
              isSelected: selectedUrgency == 'low',
              onTap: () => onChanged('low'),
            ),

            const SizedBox(width: 10),

            _UrgencyButton(
              title: 'Medium',
              isSelected: selectedUrgency == 'medium',
              onTap: () => onChanged('medium'),
            ),

            const SizedBox(width: 10),

            _UrgencyButton(
              title: 'High',
              isSelected: selectedUrgency == 'high',
              onTap: () => onChanged('high'),
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
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0B2A66) : Colors.white,
            borderRadius: BorderRadius.circular(isSelected ? 8 : 4),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0B2A66)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}
