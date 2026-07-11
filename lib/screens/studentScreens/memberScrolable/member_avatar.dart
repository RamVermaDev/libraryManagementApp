import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String? imageUrl;
  final int memberNumber;
  final Color backgroundColor;

  const MemberAvatar({
    super.key,
    this.imageUrl,
    required this.memberNumber,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      width: 60,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              border: Border.all(color: const Color(0xFF98A2B3), width: 1),
            ),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      imageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const _DefaultAvatar();
                      },
                    )
                  : const _DefaultAvatar(),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            memberNumber.toString().padLeft(3, '0'),
            maxLines: 1,
            style: const TextStyle(
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475467),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/Avatar.png',
      width: 42,
      height: 42,
      fit: BoxFit.cover,
    );
  }
}
