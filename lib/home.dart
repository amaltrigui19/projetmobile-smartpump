import 'package:flutter/material.dart';
import 'details/system_detail_page.dart';

/// =====================
/// MODELS
/// =====================
class System {
  final String id;
  final String name;
  final String currentPower;
  final String dailyEnergy;
  final String efficiency;
  final String totalFlow;

  System({
    required this.id,
    required this.name,
    required this.currentPower,
    required this.dailyEnergy,
    required this.efficiency,
    required this.totalFlow,
  });
}

class AlertItem {
  final String id;
  final String title;
  final String? subtitle;

  AlertItem({required this.id, required this.title, this.subtitle});
}

/// =====================
/// HOME PAGE (CONTENU SEUL)
/// =====================
class HomePage extends StatelessWidget {
  final List<System> systems;
  final List<AlertItem> alerts;
  final Function(System) onSystemClick;
  final VoidCallback onAddSystem;

  const HomePage({
    super.key,
    required this.systems,
    required this.alerts,
    required this.onSystemClick,
    required this.onAddSystem,
  });

  static const Color bgMain = Color(0xFFF5F5F0);
  static const Color headerGreen = Color(0xFF4A5D3F);
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
              decoration: const BoxDecoration(
                color: headerGreen,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Salut foulen',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D7350),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onAddSystem,
                    child: const Row(
                      children: [
                        Text('Ajouter'),
                        SizedBox(width: 6),
                        Icon(Icons.add, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// ===== EFFICACITÉ CARD =====
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5D7350), Color(0xFF4A5D3F)],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Efficacité',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13)),
                                SizedBox(height: 6),
                                Text('95%',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 6),
                                Text('Gérez votre énergie',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                                Text('pour produire',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                                Text('efficacement',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 80,
                            margin: const EdgeInsets.only(left: 8),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/image 27.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// ===== SYSTEMS =====
                    ...systems.map(
                      (system) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => onSystemClick(system),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: lightGreen,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(system.name,
                                    style: const TextStyle(
                                        color: headerGreen, fontSize: 15)),
                                const Icon(Icons.chevron_right,
                                    color: headerGreen),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ===== ALERTES =====
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _alertHeader(),
                          const SizedBox(height: 10),
                          ...alerts.map(
                            (alert) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F0E0),
                                  borderRadius: BorderRadius.circular(10),
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
                                                  color: headerGreen)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5D7350),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text('Derniers alertes',
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
