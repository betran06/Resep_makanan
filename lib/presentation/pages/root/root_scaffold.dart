// lib/presentation/pages/root/root_scaffold.dart
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../components/nav/app_bottom_nav.dart';
import '../home/home_page.dart';
import '../library/library_page.dart';
import '../profile/profile_page.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _currentIndex = AppTabs.home;

  // PageStorageBucket agar posisi scroll per tab tersimpan otomatis
  final PageStorageBucket _bucket = PageStorageBucket();

  // Tiga halaman inti (bisa di-lazy load jika mau)
  late final List<Widget> _pages = const [
    HomePage(key: PageStorageKey('home_page')),
    LibraryPage(key: PageStorageKey('library_page')),
    ProfilePage(key: PageStorageKey('profile_page')),
  ];

  Future<bool> _onWillPop() async {
    // Jika bukan di tab Home, kembali ke Home dulu saat tombol back
    if (_currentIndex != AppTabs.home) {
      setState(() => _currentIndex = AppTabs.home);
      return false;
    }
    return true; // allow system back
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageStorage(
          bucket: _bucket,
          child: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}
