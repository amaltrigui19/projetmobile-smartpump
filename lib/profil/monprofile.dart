import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'editprofile.dart';
import 'services.dart';
import 'gerer_systemes.dart';
import 'parametre.dart';
import '../details/loginpage.dart';
import '../l10n/app_localizations.dart';
import '../widgets/locale_rebuilder.dart';

// Brand colors
const Color customGreen = Color(0xFF4A5D3F);
const Color bgColor = Color(0xFFF7F8F4);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profilePhoto;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      final photoPath = prefs.getString('profile_photo_path_${user.uid}');
      if (photoPath != null && File(photoPath).existsSync()) {
        setState(() {
          _profilePhoto = File(photoPath);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current Firebase user
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return LocaleRebuilder(
      child: Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          l10n.myProfile,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: customGreen,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: customGreen,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      // Use a StreamBuilder to listen to profile changes in Firestore
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          String displayName = "Chargement...";
          String displayPhone = "...";

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            displayName = data['name'] ?? "Utilisateur";
            displayPhone = data['phone'] ?? "Sans numéro";
          }

          return SingleChildScrollView(
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
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: _profilePhoto != null ? FileImage(_profilePhoto!) : null,
                          child: _profilePhoto == null
                              ? const Icon(Icons.person, size: 50, color: customGreen)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        displayName, // Dynamic Name
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2), // Updated for Flutter 3.38
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              displayPhone, // Dynamic Phone
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfilePage()),
                          );
                          // Reload photo after returning from edit page if profile was updated
                          if (result == true) {
                            _loadProfilePhoto();
                          }
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(l10n.editProfile),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: customGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                        title: l10n.services,
                        icon: Icons.design_services,
                        iconBgColor: const Color(0xFF6B8E5D),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicesPage())),
                      ),
                      const SizedBox(height: 12),
                      ProfileMenuItem(
                        title: l10n.manageSystems,
                        icon: Icons.build,
                        iconBgColor: const Color(0xFF7A9D6E),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageSystemsPage())),
                      ),
                      const SizedBox(height: 12),
                      ProfileMenuItem(
                        title: l10n.settings,
                        icon: Icons.settings,
                        iconBgColor: const Color(0xFF89AC7D),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                      ),
                      const SizedBox(height: 30),
                      ProfileMenuItem(
                        title: l10n.logout,
                        icon: Icons.logout,
                        iconBgColor: Colors.red.shade400,
                        isLogout: true,
                        onTap: () async {
                          await FirebaseAuth.instance.signOut(); // Real Firebase Logout
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}
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
                color: Colors.black.withValues(alpha: 0.05), // Updated for Flutter 3.38
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
                  // Updated for Flutter 3.38
                  color: iconBgColor.withValues(alpha: 0.15),
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
                color: isLogout ? Colors.red.shade400 : customGreen.withValues(alpha: 0.5),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Your ProfileMenuItem remains the same (just updated withOpacity to withValues for the icon container)