import 'package:flutter/material.dart';

class ReceiptContainer extends StatefulWidget {
  const ReceiptContainer({super.key});

  @override
  State<ReceiptContainer> createState() => _ReceiptContainerState();
}

class _ReceiptContainerState extends State<ReceiptContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Receipt",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Text("Receipt No : 12345"),
                  SizedBox(height: 8),
                  Text("Amount : ₹500"),
                  SizedBox(height: 8),
                  Text("Date : 01/07/2026"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
