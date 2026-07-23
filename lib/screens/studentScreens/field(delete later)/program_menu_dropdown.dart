// import 'package:flutter/material.dart';

// class ProgramMenuDropdown extends StatefulWidget {
//   const ProgramMenuDropdown({
//     super.key,

//     this.height = 52,
//     this.padding = 18,

//     required this.selectedValue,
//     required this.onChange,
//   });

//   final double height;
//   final double padding;

//   final int selectedValue;

//   final ValueChanged<int> onChange;

//   @override
//   State<ProgramMenuDropdown> createState() => _ProgramMenuDropdownState();
// }

// class _ProgramMenuDropdownState extends State<ProgramMenuDropdown> {
//   final List<int> programs = [30, 60, 90, 120];

//   @override
//   Widget build(BuildContext context) {
//     final double menuWidth = MediaQuery.of(context).size.width * 0.40;

//     return Container(
//       height: widget.height,
//       padding: EdgeInsets.symmetric(horizontal: widget.padding),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.black26),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               'Program',
//               style: TextStyle(fontSize: 18, color: Colors.black87),
//             ),
//           ),

//           PopupMenuButton<int>(
//             constraints: BoxConstraints(
//               minWidth: menuWidth,
//               maxWidth: menuWidth,
//             ),
//             position: PopupMenuPosition.under,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             onSelected: (value) {
//               widget.onChange(value);
//             },
//             itemBuilder: (context) => programs
//                 .map(
//                   (e) =>
//                       PopupMenuItem<int>(value: e, child: Text(e.toString())),
//                 )
//                 .toList(),
//             child: Row(
//               children: [
//                 Text(
//                   '${widget.selectedValue} Days',
//                   style: const TextStyle(fontSize: 18, color: Colors.black54),
//                 ),
//                 const SizedBox(width: 6),
//                 const Icon(Icons.keyboard_arrow_down),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
