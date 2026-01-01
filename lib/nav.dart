import 'package:flutter/material.dart';
import 'home.dart';
import 'monprofile.dart';

// Mock data (temporaire)
const List<System> mockSystems = [];
const List<AlertItem> mockAlerts = [];

class HomeShell extends StatefulWidget {
  const HomeShell({Key? key}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? HomePage(
              systems: mockSystems,
              alerts: mockAlerts,
              onSystemClick: (_) {},
              onAddSystem: () {},
            )
          : const ProfilePage(),

      // ✅ BARRE DE NAVIGATION
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF4A5D3F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() => _currentIndex = 0);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.home, color: Colors.white),
                  SizedBox(height: 6),
                  Text(
                    'accueil',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() => _currentIndex = 1);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person, color: Colors.white70),
                  SizedBox(height: 6),
                  Text(
                    'Mon profile',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 12),
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
