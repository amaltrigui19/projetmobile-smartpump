import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlertItem {
  final String id;
  final String title;
  final String body;
  final String urgency;
  final bool technicianRequired;
  final String systemId;
  final String severity;
  final String errorType;
  final Map<String, dynamic>? sensorData;
  final DateTime createdAt;
  final bool isResolved;
  final String? location;

  AlertItem({
    required this.id,
    required this.title,
    required this.body,
    required this.urgency,
    required this.technicianRequired,
    required this.systemId,
    required this.severity,
    required this.errorType,
    this.sensorData,
    required this.createdAt,
    required this.isResolved,
    this.location,
  });

  factory AlertItem.fromMap(Map<String, dynamic> data, String id) {
    return AlertItem(
      id: id,
      title: data['title'] ?? 'No title',
      body: data['body'] ?? '',
      urgency: data['urgency'] ?? data['severity'] ?? 'MEDIUM',
      technicianRequired: data['technicianRequired'] ?? data['requires_technician'] ?? false,
      systemId: data['systemId'] ?? '',
      severity: data['severity'] ?? 'MEDIUM',
      errorType: data['error_type'] ?? data['errorType'] ?? 'Unknown',
      sensorData: data['sensor_data'] ?? data['sensorData'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? 
                 (data['alert_timestamp'] as Timestamp?)?.toDate() ?? 
                 DateTime.now(),
      isResolved: data['isResolved'] ?? false,
      location: data['location'] != null ? 
                (data['location'] is String ? data['location'] : 
                (data['location'] as Map<String, dynamic>?)?.toString()) : null,
    );
  }

  // Parse error from the Python format
  factory AlertItem.fromPythonFormat(Map<String, dynamic> data, String id) {
    final title = data['title'] ?? '';
    final body = data['body'] ?? '';
    final urgency = data['urgency'] ?? 'HIGH';
    final technicianRequired = (data['technician'] ?? 'NO').toString().toUpperCase() == 'YES';
    
    // Extract system/pump ID from title
    String systemId = '';
    final pumpMatch = RegExp(r'pump_(\d+)').firstMatch(title);
    if (pumpMatch != null) {
      systemId = pumpMatch.group(0) ?? '';
    }

    // Extract severity from error data
    String severity = data['severity'] ?? 'HIGH';
    if (urgency == 'HIGH') severity = 'CRITICAL';
    else if (urgency == 'MEDIUM') severity = 'HIGH';
    else if (urgency == 'LOW') severity = 'MEDIUM';

    // Extract error type from title
    String errorType = 'Unknown';
    if (title.contains('overheat')) errorType = 'overheat';
    else if (title.contains('low power')) errorType = 'low_power';
    else if (title.contains('motor fault')) errorType = 'motor_fault';
    else if (title.contains('sensor fault')) errorType = 'sensor_fault';
    else if (title.contains('low flow')) errorType = 'low_flow';

    return AlertItem(
      id: id,
      title: title,
      body: body,
      urgency: urgency,
      technicianRequired: technicianRequired,
      systemId: systemId,
      severity: severity,
      errorType: errorType,
      sensorData: data['sensor_data'],
      createdAt: DateTime.now(),
      isResolved: false,
      location: data['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'urgency': urgency,
      'technicianRequired': technicianRequired,
      'systemId': systemId,
      'severity': severity,
      'error_type': errorType,
      'sensor_data': sensorData,
      'createdAt': Timestamp.fromDate(createdAt),
      'isResolved': isResolved,
      'location': location,
    };
  }

  // Format the alert for display in system detail
  Map<String, String> get formattedDetails {
    return {
      'Titre': title,
      'Description': body,
      'Urgence': urgency,
      'Sévérité': severity,
      'Type d\'erreur': errorType,
      'Technicien requis': technicianRequired ? 'OUI' : 'NON',
      'Date': '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}',
    };
  }

  // Get color based on severity
  Color get severityColor {
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

  // Get icon based on error type
  IconData get errorIcon {
    switch (errorType.toLowerCase()) {
      case 'overheat':
        return Icons.thermostat;
      case 'low_power':
        return Icons.power_off;
      case 'motor_fault':
        return Icons.build;
      case 'sensor_fault':
        return Icons.sensors_off;
      case 'low_flow':
        return Icons.water_drop;
      default:
        return Icons.warning;
    }
  }
}