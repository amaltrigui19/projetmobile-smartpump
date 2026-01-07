import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/alert_model.dart';
import '../services/database_sync_service.dart';

/// Widget to display real-time AI model data AND error alerts from Google Sheets
class AIModelDataWidget extends StatelessWidget {
  final String systemId;
  final String systemName;

  const AIModelDataWidget({
    super.key,
    required this.systemId,
    required this.systemName,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        // AI Model Data Section
        _buildAIDataSection(context, user),
        
        const SizedBox(height: 20),
        
        // Error Alerts Section
        _buildErrorAlertsSection(context, user),
      ],
    );
  }

  Widget _buildAIDataSection(BuildContext context, User? user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.psychology, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Données IA en Temps Réel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        'Source: Google Sheets → Firestore',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Data display
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .collection('systems')
                .doc(systemId)
                .snapshots(),
            builder: (context, snapshot) {
              // Also listen to RTDB for real-time updates
              return StreamBuilder<Map<String, dynamic>?>(
                stream: DatabaseSyncService.readSensorDataFromRTDB(systemId),
                builder: (context, rtdbSnapshot) {
                  Map<String, dynamic>? data;
                  
                  if (rtdbSnapshot.hasData && rtdbSnapshot.data != null) {
                    data = rtdbSnapshot.data;
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    final firestoreData = snapshot.data!.data() as Map<String, dynamic>?;
                    if (firestoreData != null && 
                        (firestoreData['source'] == 'AI_Model_GoogleSheets' ||
                         firestoreData['source'] == 'AI_Model_Sheet')) {
                      data = firestoreData;
                    }
                  }

                  if (data == null || data.isEmpty) {
                    return _buildEmptyDataState();
                  }

                  final power = data['power'] ?? data['currentPower'] ?? '0';
                  final efficiency = data['efficiency'] ?? '0';
                  final temperature = data['temperature'];
                  final voltage = data['voltage'];
                  final flowRate = data['flow_rate'] ?? data['flowRate'] ?? '0';
                  final vibration = data['vibration'] ?? '0';

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.flash_on,
                                label: 'Puissance',
                                value: power.toString(),
                                unit: 'kW',
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                icon: Icons.trending_up,
                                label: 'Efficacité',
                                value: efficiency.toString(),
                                unit: '%',
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        if (temperature != null || voltage != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (temperature != null)
                                Expanded(
                                  child: _buildMetricCard(
                                    icon: Icons.thermostat,
                                    label: 'Température',
                                    value: temperature.toString(),
                                    unit: '°C',
                                    color: Colors.red,
                                  ),
                                ),
                              if (temperature != null && voltage != null)
                                const SizedBox(width: 12),
                              if (voltage != null)
                                Expanded(
                                  child: _buildMetricCard(
                                    icon: Icons.electrical_services,
                                    label: 'Tension',
                                    value: voltage.toString(),
                                    unit: 'V',
                                    color: Colors.blue,
                                  ),
                                ),
                            ],
                          ),
                        ],

                        if (flowRate != '0' || vibration != '0') ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (flowRate != '0')
                                Expanded(
                                  child: _buildMetricCard(
                                    icon: Icons.water_drop,
                                    label: 'Débit',
                                    value: flowRate.toString(),
                                    unit: 'L/min',
                                    color: Colors.cyan,
                                  ),
                                ),
                              if (flowRate != '0' && vibration != '0')
                                const SizedBox(width: 12),
                              if (vibration != '0')
                                Expanded(
                                  child: _buildMetricCard(
                                    icon: Icons.vibration,
                                    label: 'Vibration',
                                    value: vibration.toString(),
                                    unit: 'mm/s',
                                    color: Colors.purple,
                                  ),
                                ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.circle, size: 8, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                'Données mises à jour en temps réel',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorAlertsSection(BuildContext context, User? user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('alerts')
          .where('systemId', isEqualTo: systemId)
          .where('isResolved', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(); // Return empty container if no alerts
        }

        final alerts = snapshot.data!.docs.map((doc) {
          return AlertItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.shade100, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with warning badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.warning, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alertes Actives (${alerts.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                            'Détails des erreurs détectées',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Alerts list
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: alerts.map((alert) => _buildAlertDetailCard(alert)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAlertDetailCard(AlertItem alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: alert.severityColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: alert.severityColor.withOpacity(0.3), width: 1),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: alert.severityColor,
            shape: BoxShape.circle,
          ),
          child: Icon(alert.errorIcon, color: Colors.white, size: 20),
        ),
        title: Text(
          alert.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: alert.severityColor,
          ),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy HH:mm').format(alert.createdAt),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Chip(
          label: Text(
            alert.severity.toUpperCase(),
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
          backgroundColor: alert.severityColor,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error details
                ...alert.formattedDetails.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '${entry.key}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 12),

                // Sensor data if available
                if (alert.sensorData != null && alert.sensorData!.isNotEmpty) ...[
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Données des capteurs:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: alert.sensorData!.entries.map((entry) {
                      String unit = '';
                      if (entry.key == 'temperature') unit = '°C';
                      else if (entry.key == 'voltage') unit = 'V';
                      else if (entry.key == 'current') unit = 'A';
                      else if (entry.key == 'flow_rate') unit = 'L/min';
                      else if (entry.key == 'vibration') unit = 'mm/s';

                      return Chip(
                        label: Text(
                          '${entry.key}: ${entry.value} $unit',
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: Colors.grey.shade100,
                      );
                    }).toList(),
                  ),
                ],

                // Action buttons
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text('Marquer comme résolu'),
                        onPressed: () {
                          // Implement mark as resolved functionality
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('Appeler technicien'),
                        onPressed: () {
                          // Implement call technician functionality
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDataState() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.hourglass_empty, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text(
              'En attente des données IA...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    Color darkerColor = Color.fromRGBO(
      (color.red * 0.7).round(),
      (color.green * 0.7).round(),
      (color.blue * 0.7).round(),
      1.0,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkerColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}