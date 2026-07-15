import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/all_payment_screen.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/payement_tile.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';

class RecentPaymentsSection extends StatelessWidget {
  const RecentPaymentsSection({
    super.key,
    required this.payments,
    required this.scale,
  });

  final List<PaymentModel>? payments;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final items = payments ?? const <PaymentModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Payments',
          fontSize: 18 * scale,
          scale: scale,

          trailing: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AllPaymentScreen();
                  },
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(60 * scale, 36 * scale),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View all',
              style: TextStyle(
                color: AppColors.info,
                fontSize: 14 * scale,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        SizedBox(height: 14 * scale),

        Container(
          decoration: AppCardDecoration.standard(),
          clipBehavior: Clip.antiAlias,
          child: items.isEmpty
              ? _EmptyPaymentWidget(scale: scale)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF1F3F5),
                  ),
                  itemBuilder: (_, index) {
                    return PaymentTile(payment: items[index], scale: scale);
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyPaymentWidget extends StatelessWidget {
  const _EmptyPaymentWidget({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        children: [
          Icon(
            Icons.payments_outlined,
            size: 34 * scale,
            color: AppColors.caption,
          ),

          SizedBox(height: 12 * scale),

          Text(
            'No Payments Yet',
            style: TextStyle(
              color: AppColors.heading,
              fontSize: 11 * scale,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 6 * scale),

          Text(
            'Payments will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.caption,
              fontSize: 8 * scale,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
