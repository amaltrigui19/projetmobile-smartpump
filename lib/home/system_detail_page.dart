import 'package:flutter/material.dart';
import '../models/system_model.dart';
import 'weather.dart'; 

class SystemDetailPage extends StatelessWidget {
  final System system;

  const SystemDetailPage({
    super.key,
    required this.system,
  });

  // Color Palette
  static const Color bgMain = Color(0xFFF5F5F0);
  static const Color headerGreen = Color(0xFF4A5D3F);
  static const Color greenText = Color(0xFF4A5D3F);
  static const Color cardGreen = Color(0xFFD4E4C8);
  static const Color paleGreen = Color(0xFFE8F0E0);

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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Info sur le système',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            /// ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  children: [
                    /// ===== SYSTEM NAME DISPLAY =====
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, left: 4),
                        child: Text(
                          system.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: headerGreen),
                        ),
                      ),
                    ),

                    /// ===== WEATHER CARD (CLICKABLE) =====
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherPage())),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardGreen,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Maintenant', style: TextStyle(color: greenText, fontSize: 14)),
                                SizedBox(height: 4),
                                Text('24°C • Ensoleillé', 
                                  style: TextStyle(color: greenText, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Icon(Icons.wb_sunny_rounded, color: Colors.orangeAccent, size: 44),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ===== METRICS GRID =====
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1, 
                      children: [
                        _MetricCard(
                          title: 'Puissance actuelle',
                          value: system.currentPower,
                          unit: 'kW',
                          background: Colors.white,
                          icon: Icons.bolt,
                        ),
                        _MetricCard(
                          title: 'Énergie du jour',
                          value: system.dailyEnergy,
                          unit: 'kWh',
                          background: Colors.white,
                          icon: Icons.today,
                        ),
                        _MetricCard(
                          title: 'Efficacité',
                          value: system.efficiency,
                          unit: '%',
                          background: paleGreen,
                          icon: Icons.trending_up,
                        ),
                        _MetricCard(
                          title: 'Débit total',
                          value: system.totalFlow,
                          unit: 'm³',
                          background: paleGreen,
                          icon: Icons.water_drop,
                        ),
                      ],
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
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color background;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.background,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF7A8D6F), fontWeight: FontWeight.bold)),
              Icon(icon, size: 16, color: const Color(0xFF7A8D6F)),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A2A15))),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit, style: const TextStyle(color: Color(0xFF7A8D6F), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}