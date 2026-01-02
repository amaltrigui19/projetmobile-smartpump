import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'editprofile.dart';
import 'services.dart';
import 'gerer_systemes.dart';
import 'parametre.dart';
import '../models/system_model.dart';
import '../details/loginpage.dart';

// Brand colors
const Color customGreen = Color(0xFF4A5D3F);
const Color lightGreen = Color(0xFF6B8E5D);
const Color bgColor = Color(0xFFF7F8F4);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Mon Profil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: customGreen,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: customGreen,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ===== HEADER WITH PROFILE =====
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: customGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: customGreen),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Foulen Fouleni",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          "22553322",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfilePage()),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text(
                        "Modifier le profil",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: customGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ===== MENU ITEMS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileMenuItem(
                    title: "Services",
                    icon: Icons.design_services,
                    iconBgColor: const Color(0xFF6B8E5D),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesPage())),
                  ),
                  const SizedBox(height: 12),

                  // FIX: Passing complete System objects to ManageSystemsPage
                  ProfileMenuItem(
                    title: "Gérer les systèmes",
                    icon: Icons.build,
                    iconBgColor: const Color(0xFF7A9D6E),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManageSystemsPage(
                            systems: [
                              System(
                                id: "1",
                                name: "Système Solaire A",
                                modelNumber: "SOL-2024",
                                surface: "2.5",
                                locationName: "Tunis",
                                currentPower: "12.5",
                                dailyEnergy: "45.0",
                                efficiency: "98",
                                totalFlow: "0.0",
                                latitude: 36.8065,
                                longitude: 10.1815,
                              ),
                              System(
                                id: "2",
                                name: "Pompe Éolienne B",
                                modelNumber: "WIND-X",
                                surface: "1.0",
                                locationName: "Sfax",
                                currentPower: "5.2",
                                dailyEnergy: "18.5",
                                efficiency: "92",
                                totalFlow: "150.0",
                                latitude: 34.7406,
                                longitude: 10.7603,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  ProfileMenuItem(
                    title: "Paramètres",
                    icon: Icons.settings,
                    iconBgColor: const Color(0xFF89AC7D),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                  ),
                  const SizedBox(height: 30),

                  ProfileMenuItem(
                    title: "Déconnexion",
                    icon: Icons.logout,
                    iconBgColor: Colors.red.shade400,
                    isLogout: true,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Keep your existing ProfileMenuItem component below...
class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconBgColor,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconBgColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isLogout ? Colors.red.shade600 : const Color(0xFF2D3E28),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isLogout ? Colors.red.shade400 : customGreen.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}