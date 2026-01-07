import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'system_detail_page.dart';
import '../models/system_model.dart';
import '../models/alert_model.dart';
import '../services/google_sheets_service.dart';
import 'ajoutsystem.dart';
import '/maintenance_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color darkGreen = Color(0xFF4A6B3E);       // Vert principal foncé
  static const Color mediumGreen = Color(0xFF55744A);      // Vert moyen
  static const Color lightGreen = Color(0xFFCFEBC1);       // Vert clair
  static const Color bgMain = Color(0xFFF9F9F7);           // Fond principal
  static const Color accentGreen = Color(0xFF3B523C);      // Vert accent pour textes
  static const Color alertLabelGreen = Color(0xFF4A6B3E);  // Vert pour label alertes

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: bgMain,
      body: SafeArea(
        child: Column(
          children: [
            // Header with user name
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
              builder: (context, userSnapshot) {
                String userName = "Utilisateur";
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final data = userSnapshot.data!.data() as Map<String, dynamic>;
                  userName = data['name'] ?? "Utilisateur";
                }
                return _buildHeader(context, userName);
              },
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('systems')
                    .snapshots(),
                builder: (context, systemsSnapshot) {
                  List<System> systems = [];
                  if (systemsSnapshot.hasData) {
                    systems = systemsSnapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return System.fromMap(data, doc.id);
                    }).toList();
                  }

                  double avgEfficiency = 0.0;
                  int functioningSystemsCount = 0;
                  double totalEfficiency = 0.0;
                  
                  for (var system in systems) {
                    final currentPower = double.tryParse(system.currentPower) ?? 0.0;
                    if (currentPower > 0) {
                      final eff = double.tryParse(system.efficiency) ?? 0.0;
                      totalEfficiency += eff;
                      functioningSystemsCount++;
                    }
                  }
                  
                  avgEfficiency = functioningSystemsCount > 0 ? totalEfficiency / functioningSystemsCount : 0.0;
                  bool hasFunctioningSystems = functioningSystemsCount > 0;

                  // Fetch alerts from Google Sheets (direct connection)
                  return FutureBuilder<List<AlertItem>>(
                    future: GoogleSheetsService.fetchAlerts(),
                    builder: (context, alertsSnapshot) {
                      List<AlertItem> alerts = [];
                      if (alertsSnapshot.hasData) {
                        alerts = alertsSnapshot.data!;
                      } else if (alertsSnapshot.hasError) {
                        // Fallback to Firestore if Google Sheets fails
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .collection('alerts')
                              .where('isResolved', isEqualTo: false)
                              .orderBy('createdAt', descending: true)
                              .limit(10)
                              .snapshots(),
                          builder: (context, firestoreSnapshot) {
                            List<AlertItem> firestoreAlerts = [];
                            if (firestoreSnapshot.hasData) {
                              firestoreAlerts = firestoreSnapshot.data!.docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return AlertItem.fromMap(data, doc.id);
                              }).toList();
                            }
                            return _buildContent(context, systems, avgEfficiency, hasFunctioningSystems, firestoreAlerts);
                          },
                        );
                      }
                      return _buildContent(context, systems, avgEfficiency, hasFunctioningSystems, alerts);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<System> systems, double avgEfficiency, bool hasFunctioningSystems, List<AlertItem> alerts) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEfficiencyCard(avgEfficiency),
          const SizedBox(height: 30),
          const Text("Vos Systèmes", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (systems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: lightGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "Aucun système ajouté",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else
            ...systems.map((system) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSystemRectangle(context, system),
                )),
          
          // Show alerts section if there are alerts (from Google Sheets)
          if (alerts.isNotEmpty) ...[
            const SizedBox(height: 30),
            _buildAlertsSection(context, alerts, systems),
          ],
        ],
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.white, radius: 18, child: Icon(Icons.person, color: darkGreen)),
              const SizedBox(width: 12),
              Text("Bonjour $userName", 
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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

  // --- Efficiency Card ---
  Widget _buildEfficiencyCard(double efficiency) {
    final efficiencyPercent = efficiency.round();
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$efficiencyPercent%", style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
                const Text("Efficacité", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(
                  efficiencyPercent > 0 
                      ? "Optimisez votre énergie pour une production efficace"
                      : "Aucun système fonctionnel",
                  style: const TextStyle(color: Colors.white70, fontSize: 12)
                ),
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

  // --- System Card ---
  Widget _buildSystemRectangle(BuildContext context, System system) {
    return InkWell(
      onTap: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => SystemDetailPage(system: system))
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        decoration: BoxDecoration(
          color: lightGreen,
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

  // --- Alerts Section - fetches from Firestore ---
  Widget _buildAlertsSection(BuildContext context, List<AlertItem> alerts, List<System> systems) {
    // Get system name by ID
    String getSystemName(String systemId) {
      try {
        final system = systems.firstWhere((s) => s.id == systemId);
        return system.name;
      } catch (e) {
        return 'Système inconnu';
      }
    }

    // Get severity color
    Color getSeverityColor(String severity) {
      switch (severity.toLowerCase()) {
        case 'critical':
          return Colors.red;
        case 'high':
          return Colors.orange;
        case 'medium':
          return Colors.amber;
        case 'low':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge Titre
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: alertLabelGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'Dernières alertes',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // List of alerts from Firestore
          ...alerts.map((alert) {
            final systemName = getSystemName(alert.systemId);
            final severityColor = getSeverityColor(alert.severity);
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildAlertItem(
                context,
                alert.title,
                systemName,
                severityColor,
                () {
                  // Navigate to system detail if system exists
                  try {
                    final system = systems.firstWhere((s) => s.id == alert.systemId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SystemDetailPage(system: system),
                      ),
                    );
                  } catch (e) {
                    // System not found, show maintenance page instead
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MaintenancePompePage(),
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // Widget helper pour les lignes d'alertes
  Widget _buildAlertItem(BuildContext context, String title, String subtitle, Color severityColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: lightGreen.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: severityColor.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
          ],
        ),
      ),
    );
  }
}