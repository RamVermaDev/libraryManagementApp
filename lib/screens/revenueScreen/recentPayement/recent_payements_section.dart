import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/payement_tile.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';

class RecentPaymentsSection extends StatelessWidget {
  const RecentPaymentsSection({
    super.key,
    required this.payments,
    required this.isloading,
  });

  final List<PaymentModel>? payments;
  final bool isloading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Payments',
          fontSize: 18,

          trailing: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(60, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'View all',
              style: TextStyle(
                color: AppColors.info,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Container(
          decoration: AppCardDecoration.standard(),
          clipBehavior: Clip.antiAlias,
          child: payments!.isEmpty
              ? const _EmptyPaymentWidget()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: payments!.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF1F3F5),
                  ),
                  itemBuilder: (_, index) {
                    return PaymentTile(payment: payments![index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyPaymentWidget extends StatelessWidget {
  const _EmptyPaymentWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        children: [
          Icon(Icons.payments_outlined, size: 34, color: AppColors.caption),

          const SizedBox(height: 12),

          const Text(
            'No Payments Yet',
            style: TextStyle(
              color: AppColors.heading,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Payments will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.caption,
              fontSize: 8,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
