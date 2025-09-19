// lib/presentation/pages/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/providers/settings_provider.dart';
import '../../components/profile/profile_header.dart';
import '../../components/profile/settings_section.dart';
import '../../components/profile/settings_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user — ganti dengan data asli dari auth/user provider kamu
    const String userName = 'tolakanginboy';
    const String userEmail = 'tolakanginboy@gmail.com';
    // Asset pattern & avatar: siapkan file sesuai path ini
    const String bgPatternAsset = 'assets/images/profile_bg.png';
    const String avatarAsset   = 'assets/images/avatar.png';

    return ChangeNotifierProvider(
      create: (_) => SettingsProvider()..load(), // load preferensi
      child: Builder(
        builder: (context) {
          final sp = context.watch<SettingsProvider>();

          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFFFFAF0), // krem lembut
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    ProfileHeader(
                      backgroundAsset: bgPatternAsset,
                      avatarAsset: avatarAsset,
                      name: userName,
                      email: userEmail,
                      onEditProfile: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const _StubPage(title: 'Edit Profile'),
                        ));
                      },
                      onEditAvatar: () {
                        // TODO: open image picker / file picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit avatar - coming soon')),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Section: Akun
                    SettingsSection(
                      title: 'Akun',
                      children: [
                        SettingsTile(
                          icon: Icons.image_outlined,
                          label: 'My Profile',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const _StubPage(title: 'My Profile'),
                            ));
                          },
                        ),
                        SettingsTile(
                          icon: Icons.key_outlined,
                          label: 'Password',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const _StubPage(title: 'Ubah Password'),
                            ));
                          },
                        ),
                      ],
                    ),

                    // Section: Aplikasi
                    SettingsSection(
                      title: 'Aplikasi',
                      children: [
                        SettingsTile(
                          icon: Icons.bookmark_outline,
                          label: 'Bookmark',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const _StubPage(title: 'Bookmark'),
                            ));
                          },
                        ),
                        SettingsTile(
                          icon: Icons.info_outline,
                          label: 'About App',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => const _StubPage(title: 'About App'),
                            ));
                          },
                        ),
                        // Quick toggles sesuai catatan kamu
                        SettingsTile.switcher(
                          icon: Icons.dark_mode_outlined,
                          label: 'Dark Mode',
                          value: sp.isDark,
                          onChanged: (v) => sp.setDarkMode(v),
                        ),
                        SettingsTile.dropdown<String>(
                          icon: Icons.language_outlined,
                          label: 'Language',
                          value: sp.language,
                          items: const [
                            DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
                            DropdownMenuItem(value: 'en', child: Text('English')),
                          ],
                          onChanged: (v) {
                            if (v != null) sp.setLanguage(v);
                          },
                        ),
                        SettingsTile.switcher(
                          icon: Icons.notifications_none_outlined,
                          label: 'Notifications',
                          value: sp.notificationsEnabled,
                          onChanged: (v) => sp.setNotifications(v),
                        ),
                      ],
                    ),

                    // Logout (dibuat terpisah & tegas)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: SettingsTile(
                        icon: Icons.door_back_door_outlined,
                        label: 'Logout',
                        color: Colors.orange.shade600,
                        onTap: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text('Yakin ingin keluar?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true) {
                            // TODO: panggil auth.signOut(); lalu arahkan ke login
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged out')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Halaman stub untuk navigasi sementara
class _StubPage extends StatelessWidget {
  final String title;
  const _StubPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title page')),
    );
  }
}
 