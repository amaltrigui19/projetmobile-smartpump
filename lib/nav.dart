import 'package:flutter/material.dart';
import 'home/home.dart';
import 'profil/monprofile.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? const HomePage()
          : const ProfilePage(),

      /// ===== BARRE DE NAVIGATION =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF4A6B3E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () => setState(() => _currentIndex = 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: _currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'accueil',
                    style: TextStyle(
                      color: _currentIndex == 0 ? Colors.white : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => _currentIndex = 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: _currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Mon profile',
                    style: TextStyle(
                      color: _currentIndex == 1 ? Colors.white : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}