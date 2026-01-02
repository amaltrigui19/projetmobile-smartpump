import 'package:flutter/material.dart';
import 'details/system_detail_page.dart';
import 'models/system_model.dart';
import 'models/alert_model.dart';
import 'details/ajoutsystem.dart'; 

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

  static const Color bgMain = Color(0xFFF5F5F0);
  static const Color darkGreen = Color(0xFF4A5D3F);
  static const Color midGreen = Color(0xFF5D7350);
  static const Color lightGreen = Color(0xFFD4E4C8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMain,
      body: SafeArea(
        child: Column(
          children: [
            /// ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                color: darkGreen,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(26)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: darkGreen),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bonjour",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      Text("Foulen",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.white, size: 28),
                    onPressed: () async {
                      // Navigation vers la page d'ajout de système
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddSystemPage(),
                        ),
                      );
                      
                      // Si des données sont retournées, appeler le callback
                      if (result != null) {
                        onAddSystem();
                      }
                    },
                  )
                ],
              ),
            ),

            /// ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ===== EFFICACITÉ CARD =====
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [midGreen, darkGreen],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Efficacité",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13)),
                                SizedBox(height: 8),
                                Text("95%",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 44,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(
                                  "Optimisez votre énergie\npour une production efficace",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Image.asset(
                              'assets/images/image 27.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.solar_power,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ===== SYSTEMS TITLE =====
                    const Text(
                      "Mes systèmes",
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// ===== SYSTEMS LIST =====
                    ...systems.map(
                      (system) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SystemDetailPage(system: system),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: lightGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.solar_power,
                                      color: darkGreen),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    system.name,
                                    style: const TextStyle(
                                        color: darkGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: darkGreen),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ===== ALERTES =====
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _alertHeader(),
                          const SizedBox(height: 12),
                          ...alerts.map(
                            (alert) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F0E0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(alert.title,
                                              style: const TextStyle(
                                                  color: darkGreen,
                                                  fontWeight:
                                                      FontWeight.w500)),
                                          if (alert.subtitle != null)
                                            Text(alert.subtitle!,
                                                style: const TextStyle(
                                                    color: Color(0xFF7A8D6F),
                                                    fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right,
                                        color: Color(0xFF7A8D6F)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alertHeader() {
    return Row(
      children: const [
        Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 18),
        SizedBox(width: 8),
        Text(
          'Dernières alertes',
          style: TextStyle(
              color: darkGreen,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}