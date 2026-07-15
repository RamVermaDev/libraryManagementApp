import 'package:flutter/material.dart';

class TaskAssignToggle extends StatelessWidget {
  const TaskAssignToggle({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.selected,
    required this.onChanged,
    this.height = 42,
  });

  final String leftTitle;
  final String rightTitle;
  final String selected;
  final ValueChanged<String> onChanged;
  final double height;

  bool get _isLeftSelected => selected == leftTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFDDE6FA),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              /// Sliding Background
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: _isLeftSelected ? 3 : width / 2 + 1.5,
                top: 3,
                bottom: 3,
                width: width / 2 - 4.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F57D5),
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3F57D5).withOpacity(.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(height / 2),
                      onTap: () => onChanged(leftTitle),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isLeftSelected
                                ? Colors.white
                                : const Color(0xFF4B5563),
                          ),
                          child: Text(leftTitle),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(height / 2),
                      onTap: () => onChanged(rightTitle),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: !_isLeftSelected
                                ? Colors.white
                                : const Color(0xFF4B5563),
                          ),
                          child: Text(rightTitle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
