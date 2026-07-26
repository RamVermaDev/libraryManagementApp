import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const MemberAvatar({
    super.key,
    this.imageUrl,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF1F5F9),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _DefaultAvatar();
                },
              )
            : const _DefaultAvatar(),
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
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.person_rounded,
        color: Color(0xFF94A3B8),
        size: 32,
      ),
    );
  }
}
