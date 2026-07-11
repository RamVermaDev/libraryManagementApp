import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card_style.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MemberCardFooter extends StatelessWidget {
  final MemberStatus status;
  final double? pendingAmount;
  final DateTime? date;
  final VoidCallback? onRenew;
  final VoidCallback? onPaid;
  final VoidCallback? onGiveDiscount;

  const MemberCardFooter({
    super.key,
    required this.status,
    this.pendingAmount,
    this.date,
    this.onRenew,
    this.onPaid,
    this.onGiveDiscount,
  });

  @override
  Widget build(BuildContext context) {
    final style = MemberCardStyle.fromStatus(status);
    final int days = _calculateDays(date);

    final bool hasPending = (pendingAmount ?? 0) > 0;

    final List<Widget> footers = [];

    // 1. First show expired or expiring status
    if (status == MemberStatus.expired) {
      footers.add(
        _FooterLayout(
          left: _StatusText(
            text: days == 0
                ? 'Expired today'
                : 'Expired since ${days.abs()} ${_dayText(days)}',
            color: style.accent,
          ),
          actions: [
            _FooterButton(label: 'Renew', color: style.accent, onTap: onRenew),
          ],
        ),
      );
    }

    if (status == MemberStatus.expiring) {
      footers.add(
        _FooterLayout(
          left: _StatusText(
            text: days == 0
                ? 'Expiring today'
                : 'Expiring in ${days.abs()} ${_dayText(days)}',
            color: style.accent,
          ),
          actions: [
            _FooterButton(label: 'Renew', color: style.accent, onTap: onRenew),
          ],
        ),
      );
    }

    // 2. Then show pending status
    if (hasPending) {
      if (footers.isNotEmpty) {
        footers.add(const SizedBox(height: 8));
      }

      footers.add(
        _FooterLayout(
          left: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Pending: '),
                TextSpan(
                  text: '₹${pendingAmount!.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            style: TextStyle(
              color: style.accent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            _FooterButton(label: 'Paid', color: style.accent, onTap: onPaid),
            _FooterButton(
              label: 'Give Discount',
              color: style.accent,
              onTap: onGiveDiscount,
            ),
          ],
        ),
      );
    }

    if (footers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(mainAxisSize: MainAxisSize.min, children: footers);
  }

  int _calculateDays(DateTime? date) {
    if (date == null) return 0;

    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final targetDate = DateTime(date.year, date.month, date.day);

    return targetDate.difference(today).inDays;
  }

  String _dayText(int days) {
    return days.abs() == 1 ? 'day' : 'days';
  }
}

class _StatusText extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}

class _FooterLayout extends StatelessWidget {
  final Widget left;
  final List<Widget> actions;

  const _FooterLayout({required this.left, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 10),
        ...actions.map(
          (action) =>
              Padding(padding: const EdgeInsets.only(left: 6), child: action),
        ),
      ],
    );
  }
}

class _FooterButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _FooterButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
