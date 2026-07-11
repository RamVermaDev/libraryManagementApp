// Future<void> _fetchAllMembers() async {
//     _startLoading();

//     try {
//       await _studentController.getAllStudents(
//         ref: ref,
//         libraryId: '6a422593f2ed24f734e41864',
//         page: 1,
//         limit: 20,
//       );
//     } catch (error) {
//       _handleError(error);
//     } finally {
//       _stopLoading();
//     }
//   }

//   Future<void> _fetchMoreStudents() async {
//     setState(() {
//       _isMoreLoading = true;
//     });

//     final nextPage = _page + 1;

//     try {
//       final hasMoreStudents = await _studentController.getAllStudents(
//         ref: ref,
//         libraryId: '6a422593f2ed24f734e41864',
//         page: nextPage,
//         limit: 20,
//         append: true,
//       );

//       if (mounted) {
//         setState(() {
//           if (hasMoreStudents) {
//             _page = nextPage;
//           } else {
//             _hasMore = false;
//           }
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isMoreLoading = false;
//         });
//       }
//     }
//   }

//   Future<void> _fetchAllMembers() async {
//     _startLoading();

//     try {
//       // TODO: Call your API/controller to fetch ALL members.
//       //
//       // Example:
//       //
//       // final result = await studentController.getAllStudents();
//       //
//       // if (!mounted) return;
//       //
//       // setState(() {
//       //   _members
//       //     ..clear()
//       //     ..addAll(result);
//       // });

//       await Future<void>.delayed(const Duration(milliseconds: 300));
//     } catch (error) {
//       _handleError(error);
//     } finally {
//       _stopLoading();
//     }
//   }

//   /// =============================================================
//   /// FETCH ACTIVE MEMBERS
//   /// =============================================================

//   Future<void> _fetchActiveMembers() async {
//     _startLoading();

//     try {
//       // TODO: Call your API/controller to fetch ACTIVE members.

//       await Future<void>.delayed(const Duration(milliseconds: 300));
//     } catch (error) {
//       _handleError(error);
//     } finally {
//       _stopLoading();
//     }
//   }

//   /// =============================================================
//   /// FETCH EXPIRING MEMBERS
//   /// =============================================================

//   Future<void> _fetchExpiringMembers({required MemberDayFilter filter}) async {
//     _startLoading();

//     try {
//       final int startDay = filter.startDay;
//       final int endDay = filter.endDay;

//       // TODO: Call your API/controller to fetch EXPIRING members.
//       //
//       // Send:
//       // status   = expiring
//       // startDay = startDay
//       // endDay   = endDay
//       //
//       // Example:
//       //
//       // await studentController.getExpiringStudents(
//       //   startDay: startDay,
//       //   endDay: endDay,
//       // );

//       debugPrint('Fetch EXPIRING: $startDay to $endDay days');

//       await Future<void>.delayed(const Duration(milliseconds: 300));
//     } catch (error) {
//       _handleError(error);
//     } finally {
//       _stopLoading();
//     }
//   }

//   /// =============================================================
//   /// FETCH EXPIRED MEMBERS
//   /// =============================================================

//   Future<void> _fetchExpiredMembers({required MemberDayFilter filter}) async {
//     _startLoading();

//     try {
//       final int startDay = filter.startDay;
//       final int endDay = filter.endDay;

//       // TODO: Call your API/controller to fetch EXPIRED members.
//       //
//       // Send:
//       // status   = expired
//       // startDay = startDay
//       // endDay   = endDay

//       debugPrint('Fetch EXPIRED: $startDay to $endDay days');

//       await Future<void>.delayed(const Duration(milliseconds: 300));
//     } catch (error) {
//       _handleError(error);
//     } finally {
//       _stopLoading();
//     }
//   }


















// // import 'dart:async';

// // import 'package:flutter/material.dart';
// // import 'package:library_management/screens/studentScreens/memberScrolable/empty_state.dart';
// // import 'package:library_management/screens/studentScreens/memberScrolable/error_state.dart';
// // import 'package:library_management/screens/studentScreens/memberScrolable/loading_state.dart';
// // import 'package:library_management/screens/studentScreens/memberScrolable/member_card_style.dart';
// // import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

// // /// ===============================================================
// // /// MEMBER STATUS
// // /// ===============================================================



// /// ===============================================================
// /// MEMBERS SCREEN ARGUMENTS
// ///
// /// Every dashboard button sends one of these objects.
// /// ===============================================================



// /// ===============================================================
// /// DEMO MEMBER MODEL
// ///
// /// Replace this later with your existing StudentModel.
// /// ===============================================================

// class MemberListItem {
//   final String id;
//   final String name;
//   final String memberId;
//   final String plan;
//   final DateTime expiryDate;
//   final String? imageUrl;

//   const MemberListItem({
//     required this.id,
//     required this.name,
//     required this.memberId,
//     required this.plan,
//     required this.expiryDate,
//     this.imageUrl,
//   });
// }

// /// ===============================================================
// /// APP COLORS
// /// ===============================================================

// /// ===============================================================
// /// DASHBOARD EXAMPLE
// ///
// /// This demonstrates your exact 8-button requirement.
// ///
// /// You can copy only the navigation methods into your existing
// /// main screen if you already have one.
// /// ===============================================================

// class MemberDashboardExample extends StatelessWidget {
//   const MemberDashboardExample({super.key});

//   void _openMembers(BuildContext context, MembersScreenArgs args) {
//     Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (_) => MembersScreen(args: args)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MembersColors.background,
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [
//           /// BUTTON 1
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(context, const MembersScreenArgs.all());
//             },
//             child: const Text('All Members'),
//           ),

//           const SizedBox(height: 12),

//           /// BUTTON 2
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(context, const MembersScreenArgs.active());
//             },
//             child: const Text('Active Members'),
//           ),

//           const SizedBox(height: 24),

//           /// BUTTON 3
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(
//                 context,
//                 const MembersScreenArgs.expiring(
//                   filter: MemberDayFilter.oneToThree,
//                 ),
//               );
//             },
//             child: const Text('Expiring 1–3 Days'),
//           ),

//           const SizedBox(height: 12),

//           /// BUTTON 4
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(
//                 context,
//                 const MembersScreenArgs.expiring(
//                   filter: MemberDayFilter.fourToSix,
//                 ),
//               );
//             },
//             child: const Text('Expiring 4–6 Days'),
//           ),

//           const SizedBox(height: 12),

//           /// BUTTON 5
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(
//                 context,
//                 const MembersScreenArgs.expiring(
//                   filter: MemberDayFilter.sevenToTen,
//                 ),
//               );
//             },
//             child: const Text('Expiring 7–10 Days'),
//           ),

//           const SizedBox(height: 24),

//           /// BUTTON 6
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(
//                 context,
//                 const MembersScreenArgs.expired(
//                   filter: MemberDayFilter.oneToThree,
//                 ),
//               );
//             },
//             child: const Text('Expired 1–3 Days'),
//           ),

//           const SizedBox(height: 12),

//           /// BUTTON 7
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(
//                 context,
//                 const MembersScreenArgs.expired(
//                   filter: MemberDayFilter.fourToSix,
//                 ),
//               );
//             },
//             child: const Text('Expired 4–6 Days'),
//           ),

//           const SizedBox(height: 12),

//           /// BUTTON 8
//           ElevatedButton(
//             onPressed: () {
//               _openMembers(
//                 context,
//                 const MembersScreenArgs.expired(
//                   filter: MemberDayFilter.sevenToTen,
//                 ),
//               );
//             },
//             child: const Text('Expired 7–10 Days'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// ===============================================================
// /// MEMBERS SCREEN
// /// ===============================================================



// /// ===============================================================
// /// CUSTOM APP BAR
// /// ===============================================================

// class _MembersAppBar extends StatelessWidget {
//   const _MembersAppBar();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 68,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Row(
//           children: [
//             _CircularIconButton(
//               icon: Icons.arrow_back_rounded,
//               onTap: () {
//                 Navigator.maybePop(context);
//               },
//             ),

//             const Expanded(
//               child: Text(
//                 'Members',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: MembersColors.heading,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: -0.4,
//                 ),
//               ),
//             ),

//             _CircularIconButton(
//               icon: Icons.tune_rounded,
//               onTap: () {
//                 // TODO: Open advanced filter bottom sheet.
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// ===============================================================
// /// CIRCULAR ICON BUTTON
// /// ===============================================================



// /// ===============================================================
// /// SEARCH FIELD
// /// ===============================================================



// /// ===============================================================
// /// STATUS TABS
// /// ===============================================================



// /// ===============================================================
// /// SINGLE STATUS TAB
// /// ===============================================================



// /// ===============================================================
// /// DAY FILTER SECTION
// /// ===============================================================



// /// ===============================================================
// /// SINGLE DAY FILTER BUTTON
// /// ===============================================================



// /// ===============================================================
// /// MEMBERS BODY
// /// ===============================================================
