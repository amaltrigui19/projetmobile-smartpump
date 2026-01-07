import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/alert_model.dart';

class DatabaseSyncService {
  static final FirebaseDatabase _rtdb = FirebaseDatabase.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Read sensor data from Realtime Database
  static Stream<Map<String, dynamic>?> readSensorDataFromRTDB(String systemId) {
    final ref = _rtdb.ref('/pumps/$systemId/readings').limitToLast(1);
    
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value == null) return null;
      
      final data = snapshot.value as Map<dynamic, dynamic>;
      final lastKey = data.keys.last;
      final lastData = data[lastKey] as Map<dynamic, dynamic>;
      
      // Convert to proper format
      return Map<String, dynamic>.from(lastData);
    });
  }

  // Sync Python alerts to Firestore
  static Future<void> syncPythonAlertToFirestore(Map<String, dynamic> alertData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Parse Python alert format
      final title = alertData['title'] ?? '';
      final body = alertData['body'] ?? '';
      final urgency = alertData['urgency'] ?? 'HIGH';
      final technician = alertData['technician'] ?? 'NO';
      
      // Extract system ID from title or data
      String systemId = alertData['systemId'] ?? '';
      if (systemId.isEmpty && title.contains('pump_')) {
        final match = RegExp(r'pump_(\w+)').firstMatch(title);
        if (match != null) {
          systemId = match.group(0)!;
        }
      }

      if (systemId.isEmpty) {
        print('⚠️ Could not extract system ID from alert');
        return;
      }

      // Create alert model
      final alert = AlertItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        urgency: urgency,
        technicianRequired: technician.toString().toUpperCase() == 'YES',
        systemId: systemId,
        severity: alertData['severity'] ?? 'HIGH',
        errorType: alertData['error_type'] ?? 'unknown',
        sensorData: alertData['sensor_data'],
        createdAt: DateTime.now(),
        isResolved: false,
        location: alertData['location'],
      );

      // Save to Firestore
      await _firestore.collection('alerts').doc(alert.id).set(alert.toMap());
      
      print('✅ Python alert synced to Firestore: ${alert.title}');
      
    } catch (e) {
      print('❌ Error syncing Python alert: $e');
    }
  }

  // Get alerts for a specific system
  static Stream<List<AlertItem>> getSystemAlerts(String systemId) {
    return _firestore
        .collection('alerts')
        .where('systemId', isEqualTo: systemId)
        .where('isResolved', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AlertItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Mark alert as resolved
  static Future<void> markAlertAsResolved(String alertId) async {
    try {
      await _firestore.collection('alerts').doc(alertId).update({
        'isResolved': true,
        'resolvedAt': DateTime.now(),
      });
    } catch (e) {
      print('❌ Error marking alert as resolved: $e');
    }
  }

  // Listen for real-time alerts from Python script
  static Stream<Map<String, dynamic>?> listenForPythonAlerts() {
    final ref = _rtdb.ref('/alerts').limitToLast(1);
    
    return ref.onValue.map((event) {
      final snapshot = event.snapshot;
      if (snapshot.value == null) return null;
      
      final data = snapshot.value as Map<dynamic, dynamic>;
      final lastKey = data.keys.last;
      final lastData = data[lastKey] as Map<dynamic, dynamic>;
      
      // Convert to proper format
      final alertData = Map<String, dynamic>.from(lastData);
      
      // Auto-sync to Firestore
      if (alertData['make_sent'] == true) {
        syncPythonAlertToFirestore(alertData);
      }
      
      return alertData;
    });
  }

  // Initialize sync service - placeholder method to prevent errors
  static Future<void> initializeSync() async {
    // This method can be implemented later if needed for RTDB-Firestore sync
    // For now, it's a placeholder to prevent compilation errors
    return;
  }
}