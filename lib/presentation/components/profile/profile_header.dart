// lib/presentation/components/profile/profile_header.dart
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String backgroundAsset;
  final String avatarAsset;
  final String name;
  final String email;
  final VoidCallback? onEditProfile;
  final VoidCallback? onEditAvatar;

  const ProfileHeader({
    super.key,
    required this.backgroundAsset,
    required this.avatarAsset,
    required this.name,
    required this.email,
    this.onEditProfile,
    this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        // Background pattern (atas)
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(.9),
            image: DecorationImage(
              image: AssetImage(backgroundAsset),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                cs.primaryContainer.withOpacity(.75),
                BlendMode.srcATop,
              ),
            ),
          ),
        ),
        // Card profil (bawah)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar melayang
                  PositionedAvatar(
                    size: 72,
                    asset: avatarAsset,
                    onTap: onEditAvatar,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        if (onEditProfile != null)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: const Size(0, 36),
                            ),
                            onPressed: onEditProfile,
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit Profile'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PositionedAvatar extends StatelessWidget {
  final double size;
  final String asset;
  final VoidCallback? onTap;
  const PositionedAvatar({
    super.key,
    required this.size,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: size / 2,
            backgroundImage: AssetImage(asset),
          ),
        ),
      ],
    );
  }
}
