import 'package:flutter/material.dart';
import 'changer_password.dart';
import 'choisir_langue.dart';
import 'help_support.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Colors based on your specific design
  static const Color darkGreen = Color(0xFF4A5D3F);
  static const Color dividerColor = Color(0xFFB0BEA9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: darkGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // We use a Stack to place the illustration at the very bottom
      body: Stack(
        children: [
          // 1. Background Illustration at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 0.4, // Adjust this to show more/less of the image
              child: Image.asset(
                'assets/images/image 21.png', // Ensure this matches your pubspec.yaml
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Paramétres",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 50),
                
                // --- Menu Item 1: Changer le mot de passe ---
                _buildSimpleMenuItem(
                  context,
                  icon: Icons.lock_outline,
                  title: "Changer le mot de passe",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChangerPasswordPage()),
                    );
                  },
                ),
                const Divider(color: dividerColor, thickness: 1.5),
                
                // --- Menu Item 2: Choisir langue ---
                _buildSimpleMenuItem(
                  context,
                  icon: Icons.language_outlined,
                  title: "Choisir langue",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChoisirLanguePage()),
                    );
                  },
                ),
                const Divider(color: dividerColor, thickness: 1.5),
                
                // --- Menu Item 3: Help ---
                _buildSimpleMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: "Help",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                    );
                  },
                ),
                const Divider(color: dividerColor, thickness: 1.5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build each menu row
  Widget _buildSimpleMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: darkGreen.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: darkGreen, size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: darkGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios, 
              color: darkGreen, 
              size: 20
            ),
          ],
        ),
      ),
    );
  }
}