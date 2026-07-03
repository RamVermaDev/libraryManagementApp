import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/sample/plan_data_list.dart';

class PlanMenuDropdown extends StatefulWidget {
  const PlanMenuDropdown({
    super.key,
    this.height = 52,
    this.padding = 18,
    required this.planSelected,
    required this.onChanged,
  });

  final double height;
  final double padding;

  final String planSelected;

  final ValueChanged<int> onChanged;

  @override
  State<PlanMenuDropdown> createState() => _PlanMenuDropdownState();
}

class _PlanMenuDropdownState extends State<PlanMenuDropdown> {
  @override
  Widget build(BuildContext context) {
    final double menuWidth = MediaQuery.of(context).size.width * 0.40;

    return Container(
      height: widget.height,
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Plan',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),

          PopupMenuButton<int>(
            constraints: BoxConstraints(
              minWidth: menuWidth,
              maxWidth: menuWidth,
            ),
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (value) {
              setState(() {
                //for animantion
                //widget.planSelected = value;
              });
              widget.onChanged(value);
            },
            itemBuilder: (context) => planDataList
                .map(
                  (plan) => PopupMenuItem<int>(
                    value: plan.id,
                    child: Text(plan.name),
                  ),
                )
                .toList(),
            child: Row(
              children: [
                Text(
                  widget.planSelected,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
