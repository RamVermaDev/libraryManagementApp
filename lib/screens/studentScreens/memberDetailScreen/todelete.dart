import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class MemberInfoScreen extends StatelessWidget {
  const MemberInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxWidth / 430).clamp(0.82, 1.12);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                18 * scale,
                0,
                18 * scale,
                28 * scale,
              ),
              child: Column(
                children: [
                  _TopBar(scale: scale),

                  SizedBox(height: 18 * scale),

                  //_ProfileCard(scale: scale),
                  SizedBox(height: 18 * scale),

                  //_ActionCard(scale: scale),
                  SizedBox(height: 24 * scale),

                  //_MembershipCard(scale: scale),
                  SizedBox(height: 24 * scale),

                  //PaymentCard(scale: scale),
                  SizedBox(height: 18 * scale),

                  //_AdmissionsCard(scale: scale),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// COLORS
// ============================================================


// ============================================================
// TOP BAR
// ============================================================

class _TopBar extends StatelessWidget {
  final double scale;

  const _TopBar({required this.scale});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.maybePop(context),
              iconSize: 27 * scale,
              splashRadius: 24 * scale,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.heading,
              ),
            ),
          ),

          Text(
            'Member Info',
            style: TextStyle(
              color: AppColors.heading,
              fontSize: 24 * scale,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 8 * scale,
                  vertical: 12 * scale,
                ),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 17 * scale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE CARD
// ============================================================





// ============================================================
// ACTION CARD
// ============================================================



// ============================================================
// MEMBERSHIP CARD
// ============================================================

// ============================================================
// PAYMENT CARD
// ============================================================

// ============================================================
// ADMISSIONS CARD
// ============================================================



// ============================================================
// SHARED DECORATION
// ============================================================
