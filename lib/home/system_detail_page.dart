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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.system.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System info card
            _buildSystemInfoCard(),
            
            const SizedBox(height: 20),
            
            // Weather widget
            WeatherWidget(
              lat: widget.system.latitude,
              lon: widget.system.longitude,
            ),
            
            const SizedBox(height: 20),
            
            // AI Model Data and Error Alerts Widget
            AIModelDataWidget(
              systemId: widget.system.id,
              systemName: widget.system.name,
            ),
            
            const SizedBox(height: 20),
            
            // Additional system metrics
            _buildSystemMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.solar_power, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.system.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${widget.system.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Location
            if (widget.system.locationName.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    widget.system.locationName,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            
            const SizedBox(height: 12),
            
            // Status badge (based on current power)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (double.tryParse(widget.system.currentPower) ?? 0.0) > 0 
                        ? Colors.green.shade100 
                        : Colors.orange.shade100, 
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (double.tryParse(widget.system.currentPower) ?? 0.0) > 0 ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      color: (double.tryParse(widget.system.currentPower) ?? 0.0) > 0 
                          ? Colors.green 
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMetrics() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('systems')
          .doc(widget.system.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Container();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final metrics = data['metrics'] ?? {};

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Métriques du Système',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: [
                    _buildMetricTile(
                      icon: Icons.flash_on,
                      label: 'Puissance Actuelle',
                      value: metrics['current_power'] ?? '0 W',
                      color: Colors.amber,
                    ),
                    _buildMetricTile(
                      icon: Icons.energy_savings_leaf,
                      label: 'Énergie Quotidienne',
                      value: metrics['daily_energy'] ?? '0 kWh',
                      color: Colors.green,
                    ),
                    _buildMetricTile(
                      icon: Icons.speed,
                      label: 'Efficacité',
                      value: metrics['efficiency'] ?? '0%',
                      color: Colors.blue,
                    ),
                    _buildMetricTile(
                      icon: Icons.water_drop,
                      label: 'Débit Total',
                      value: metrics['total_flow'] ?? '0 L/min',
                      color: Colors.cyan,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}