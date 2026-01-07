import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/ai_model_data_widget.dart';
import '../models/system_model.dart';
import 'weather.dart'; 

class SystemDetailPage extends StatefulWidget {
  final System system;

  const SystemDetailPage({super.key, required this.system});

  @override
  State<SystemDetailPage> createState() => _SystemDetailPageState();
}

class _SystemDetailPageState extends State<SystemDetailPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Palette de couleurs harmonisée
  final Color primaryGreen = const Color(0xFF4B6038); // Vert foncé
  final Color lightGreenBg = const Color(0xFFA6BD8B); // Vert sauge
  final Color cardWhite = const Color(0xFFF7FBF4);    // Fond des cartes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "info sur le système",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        // "En ligne" supprimé ici
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. BLOC MÉTÉO (Cliquable)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherPage(
                      lat: widget.system.latitude,
                      lon: widget.system.longitude,
                      systemName: widget.system.name,
                    ),
                  ),
                );
              },
              child: _buildWeatherHeader(),
            ),

            // 2. MÉTRIQUES DU SYSTÈME (Temps réel Firebase)
            _buildMetricsGrid(),
            
            const SizedBox(height: 10),

            // 3. SECTION IA (Couleurs modifiées pour correspondre au design)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  // On injecte les couleurs dans le thème local du widget
                  primaryColor: primaryGreen,
                  cardColor: cardWhite,
                ),
                child: AIModelDataWidget(
                  systemId: widget.system.id,
                  systemName: widget.system.name,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Maintenant", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Nuageux", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Ressenti : 31°", style: TextStyle(color: Colors.black.withOpacity(0.6))),
                ],
              )
            ],
          ),
          Row(
            children: [
              const Text("26°", style: TextStyle(fontSize: 68, fontWeight: FontWeight.bold)),
              const SizedBox(width: 15),
              const Icon(Icons.wb_cloudy_outlined, size: 64, color: Colors.white),
            ],
          ),
          const Text("Max: 28°  Min: 24°", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('systems')
          .doc(widget.system.id)
          .snapshots(),
      builder: (context, snapshot) {
        Map<String, dynamic> metrics = {};
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          metrics = data['metrics'] ?? {};
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildMetricCard("Puissance actuelle", "${metrics['current_power'] ?? '0'}", "kW", Icons.sync),
              _buildMetricCard("Énergie du jour", "${metrics['daily_energy'] ?? '0'}", "kWh", Icons.battery_charging_full),
              _buildMetricCard("Efficacité", "${metrics['efficiency'] ?? '0'}", "%", Icons.speed_outlined),
              _buildMetricCard("Débit total", "${metrics['total_flow'] ?? '0'}", "m³", Icons.water_drop, iconColor: Colors.lightBlue),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String title, String value, String unit, IconData icon, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor ?? primaryGreen, size: 30),
              Expanded(
                child: Text(
                  title, 
                  textAlign: TextAlign.right, 
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black54)
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      color: primaryGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(Icons.home_outlined, "accueil"),
          _bottomNavItem(Icons.person_outline, "Mon profil"),
        ],
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}