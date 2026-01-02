import 'package:flutter/material.dart';
import '../models/system_model.dart';

class SystemDetailPage extends StatelessWidget {
  final System system;

  const SystemDetailPage({
    super.key,
    required this.system,
  });

  static const Color bgMain = Color(0xFFF5F5F0);
  static const Color headerGreen = Color(0xFF4A5D3F);
  static const Color greenText = Color(0xFF4A5D3F);
  static const Color darkText = Color(0xFF1A2A15);
  static const Color mutedText = Color(0xFF7A8D6F);
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
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Info sur le système',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
                  children: [
                    /// ===== WEATHER CARD =====
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardGreen,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        children: [
                          Text('Maintenant',
                              style:
                                  TextStyle(color: greenText, fontSize: 13)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ===== METRICS =====
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _MetricCard(
                          title: 'Puissance actuelle',
                          value: system.currentPower,
                          unit: 'kW',
                          background: Colors.white,
                        ),
                        _MetricCard(
                          title: 'Énergie du jour',
                          value: system.dailyEnergy,
                          unit: 'kWh',
                          background: Colors.white,
                        ),
                        _MetricCard(
                          title: 'Efficacité',
                          value: system.efficiency,
                          unit: '%',
                          background: paleGreen,
                        ),
                        _MetricCard(
                          title: 'Débit total',
                          value: system.totalFlow,
                          unit: 'm³',
                          background: paleGreen,
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

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.background,
  });

  static const Color mutedText = Color(0xFF7A8D6F);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Text(unit, style: const TextStyle(color: mutedText)),
            ],
          ),
        ],
      ),
    );
  }
}
