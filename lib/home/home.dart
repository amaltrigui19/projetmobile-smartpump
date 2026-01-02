import 'package:flutter/material.dart';
import 'system_detail_page.dart';
import '../models/system_model.dart';
import '../models/alert_model.dart';
import 'ajoutsystem.dart';

class HomePage extends StatelessWidget {
  final List<System> systems;
  final List<AlertItem> alerts;
  final VoidCallback onAddSystem;

  const HomePage({
    super.key,
    required this.systems,
    required this.alerts,
    required this.onAddSystem,
  });

  static const Color darkGreen = Color(0xFF2D442E);
  static const Color lightGreenTile = Color(0xFFD7E5D0);
  static const Color bgMain = Color(0xFFF9F9F7);
  static const Color alertLabelGreen = Color(0xFF3B523C);

  @override
  Widget build(BuildContext context) {
    // FIX: Updated the dummy system to match the new Model requirements
    final displaySystem = systems.isNotEmpty 
        ? systems[0] 
        : System(
            id: "1", 
            name: "Système 1",
            modelNumber: "N/A",
            surface: "0",
            locationName: "Localisation inconnue",
            currentPower: "0.0",
            dailyEnergy: "0.0",
            efficiency: "95",
            totalFlow: "0.0",
            latitude: 36.8065, // Default Tunis
            longitude: 10.1815,
          );

    return Scaffold(
      backgroundColor: bgMain,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEfficiencyCard(),
                    const SizedBox(height: 30),
                    const Text("Vos Systèmes", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildSystemRectangle(context, displaySystem),
                    const SizedBox(height: 30),
                    _buildAlertsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Header remains the same ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              CircleAvatar(backgroundColor: Colors.white, radius: 18, child: Icon(Icons.person, color: darkGreen)),
              SizedBox(width: 12),
              Text("Bonjour Foulen", 
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddSystemPage())),
          )
        ],
      ),
    );
  }

  // --- Efficiency Card remains the same ---
  Widget _buildEfficiencyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF233524), Color(0xFF436345)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("95%", style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
                Text("Efficacité", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Text("Optimisez votre énergie pour une production efficace",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.solar_power_outlined, size: 45, color: darkGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemRectangle(BuildContext context, System system) {
    return InkWell(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => SystemDetailPage(system: system))
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: lightGreenTile,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(system.name, 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkGreen)),
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.chevron_right, color: darkGreen, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // --- Alerts Section remains the same ---
  Widget _buildAlertsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: alertLabelGreen, borderRadius: BorderRadius.circular(8)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text("Dernières alertes", style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => _navigateToAlertDetail(context),
            borderRadius: BorderRadius.circular(15),
            child: _buildSingleAlertTile("Réparation urgente du système", "Système 1"),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleAlertTile(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGreenTile.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: darkGreen)),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 14,
            child: Icon(Icons.chevron_right, size: 18, color: darkGreen),
          ),
        ],
      ),
    );
  }

  void _navigateToAlertDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: bgMain,
          appBar: AppBar(
            backgroundColor: darkGreen,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("Système 1", style: TextStyle(color: Colors.white)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Réparation urgente du système",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD32F2F), 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: darkGreen, 
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: const Text("URGENT", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "La pompe solaire ne démarre pas. La batterie est défectueuse ou le panneau est sale.",
                        style: TextStyle(color: darkGreen, fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}