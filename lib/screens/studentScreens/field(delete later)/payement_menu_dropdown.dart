// import 'package:flutter/material.dart';
// import 'package:library_management/app_colors.dart';

// class PaymentMenuDropdown extends StatefulWidget {
//   const PaymentMenuDropdown({
//     super.key,
//     this.height = 52,
//     this.padding = 18,
//     required this.selectedValue,
//     required this.onChange,
//   });

//   final double height;
//   final double padding;
//   final String selectedValue;
//   final ValueChanged<String> onChange;

//   static const List<String> paymentMethods = ['Cash', 'Online'];

//   @override
//   State<PaymentMenuDropdown> createState() => _PaymentMenuDropdownState();
// }

// class _PaymentMenuDropdownState extends State<PaymentMenuDropdown> {
//   bool isOpen = false;

//   @override
//   Widget build(BuildContext context) {
//     final double menuWidth = 120;

//     return PopupMenuButton<String>(
//       onOpened: () => setState(() {
//         isOpen = true;
//       }),
//       onCanceled: () => setState(() {
//         isOpen = false;
//       }),
//       constraints: BoxConstraints(minWidth: menuWidth, maxWidth: menuWidth),
//       position: PopupMenuPosition.under,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//       onSelected: (value) {
//         setState(() {
//           isOpen = false;
//         });
//         widget.onChange(value);
//       },

//       itemBuilder: (context) => PaymentMenuDropdown.paymentMethods
//           .map(
//             (method) =>
//                 PopupMenuItem<String>(value: method, child: Text(method)),
//           )
//           .toList(),
//       child: Container(
//         height: widget.height,
//         width: 130,
//         padding: EdgeInsets.symmetric(horizontal: widget.padding),
//         decoration: BoxDecoration(
//           color: AppColors.background,
//           border: Border.all(color: Colors.black26),

//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               widget.selectedValue,
//               style: const TextStyle(fontSize: 18, color: Colors.black54),
//             ),
//             const SizedBox(width: 6),
//             AnimatedRotation(
//               turns: isOpen ? 0.5 : 0,
//               duration: const Duration(milliseconds: 200),
//               child: const Icon(Icons.keyboard_arrow_down),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
