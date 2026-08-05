import 'package:flutter/material.dart';
import 'package:library_management/drawer/drawer_screen/subscription_screen.dart';
import 'package:library_management/models/user_model.dart';

/// Checks if the user's subscription (trial or paid) has expired.
/// Use this anywhere in the app to decide whether to lock a write action.
class SubscriptionGuard {
  /// Returns true if the subscription is expired and write actions should be blocked.
  static bool isExpired(UserModel? user) {
    if (user == null) return false;
    final endAt = user.subscription.endAt;
    if (endAt == null) return true; // consistent with SubscriptionModel.isExpired — null endAt = expired
    return DateTime.now().isAfter(endAt);
  }

  /// Shows the expired bottom sheet and returns.
  /// Call this instead of the normal action when [isExpired] is true.
  static void showExpiredSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _SubscriptionExpiredSheet(),
    );
  }
}

class _SubscriptionExpiredSheet extends StatelessWidget {
  const _SubscriptionExpiredSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lock icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_rounded,
              size: 36,
              color: Color(0xFFEF4444),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Subscription Expired',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Upgrade to Pro to continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          // Upgrade button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Upgrade Now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Not now
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Not Now',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
