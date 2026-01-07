# How to Transfer and Fetch Data from Realtime Database

This guide shows you how to transfer data from Realtime Database to Firestore and how to fetch data directly from Realtime Database.

## 📥 Fetching Data from Realtime Database

### Option 1: Real-time Stream (Updates Automatically)

```dart
import 'package:flutter/material.dart';
import '../services/database_sync_service.dart';

StreamBuilder<Map<String, dynamic>?>(
  stream: DatabaseSyncService.readSensorDataFromRTDB('your-system-id'),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (!snapshot.hasData || snapshot.data == null) {
      return Text('No sensor data available');
    }
    
    final data = snapshot.data!;
    return Column(
      children: [
        Text('Temperature: ${data['temperature'] ?? 'N/A'}'),
        Text('Power: ${data['power'] ?? 'N/A'}'),
        Text('Voltage: ${data['voltage'] ?? 'N/A'}'),
      ],
    );
  },
)
```

### Option 2: One-Time Fetch (Sensor Data)

```dart
// Fetch sensor data once
final sensorData = await DatabaseSyncService.fetchSensorDataFromRTDB('system-id-123');

if (sensorData != null) {
  print('Temperature: ${sensorData['temperature']}');
  print('Power: ${sensorData['power']}');
} else {
  print('No sensor data found');
}
```

### Option 3: One-Time Fetch (Complete System Data)

```dart
// Fetch all system data from RTDB
final systemData = await DatabaseSyncService.fetchSystemDataFromRTDB('system-id-123');

if (systemData != null) {
  print('System Name: ${systemData['name']}');
  print('Current Power: ${systemData['currentPower']}');
  print('Efficiency: ${systemData['efficiency']}');
  // Access all fields
}
```

## 📤 Transferring Data from RTDB to Firestore

### Option 1: Transfer Single System

```dart
try {
  await DatabaseSyncService.transferRTDBToFirestore('system-id-123');
  print('Transfer successful!');
} catch (e) {
  print('Error: $e');
}
```

### Option 2: Transfer Sensor Data Only

```dart
// Transfer sensor data (updates system metrics in Firestore)
try {
  await DatabaseSyncService.transferSensorDataToFirestore(
    systemId: 'system-id-123',
  );
  print('Sensor data transferred!');
} catch (e) {
  print('Error: $e');
}

// Or provide sensor data directly
await DatabaseSyncService.transferSensorDataToFirestore(
  systemId: 'system-id-123',
  sensorData: {
    'temperature': 25.5,
    'power': 5.2,
    'voltage': 220.0,
  },
);
```

### Option 3: Transfer All Systems (Batch)

```dart
try {
  await DatabaseSyncService.transferAllSystemsFromRTDBToFirestore();
  print('All systems transferred!');
} catch (e) {
  print('Error: $e');
}
```

## 🔄 Automatic Sync (Already Configured)

When you log in, the sync service automatically transfers data:
- RTDB → Firestore (automatic)
- Firestore → RTDB (automatic)

You don't need to do anything manually unless you want to force a sync.

## 📋 Complete Example: Display RTDB Data in Your App

Here's a complete widget that fetches and displays RTDB data:

```dart
import 'package:flutter/material.dart';
import '../services/database_sync_service.dart';

class RTDBDataWidget extends StatefulWidget {
  final String systemId;

  const RTDBDataWidget({super.key, required this.systemId});

  @override
  State<RTDBDataWidget> createState() => _RTDBDataWidgetState();
}

class _RTDBDataWidgetState extends State<RTDBDataWidget> {
  Map<String, dynamic>? _systemData;
  Map<String, dynamic>? _sensorData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    // Fetch from RTDB
    final system = await DatabaseSyncService.fetchSystemDataFromRTDB(widget.systemId);
    final sensor = await DatabaseSyncService.fetchSensorDataFromRTDB(widget.systemId);
    
    setState(() {
      _systemData = system;
      _sensorData = sensor;
      _isLoading = false;
    });
  }

  Future<void> _transferToFirestore() async {
    try {
      await DatabaseSyncService.transferRTDBToFirestore(widget.systemId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Transferred to Firestore!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // System Data
        if (_systemData != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('System: ${_systemData!['name'] ?? 'Unknown'}'),
                  Text('Power: ${_systemData!['currentPower'] ?? 'N/A'}'),
                  Text('Efficiency: ${_systemData!['efficiency'] ?? 'N/A'}'),
                ],
              ),
            ),
          ),

        // Sensor Data (Real-time)
        StreamBuilder<Map<String, dynamic>?>(
          stream: DatabaseSyncService.readSensorDataFromRTDB(widget.systemId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No sensor data'),
                ),
              );
            }

            final sensorData = snapshot.data!;
            return Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 12),
                        const SizedBox(width: 8),
                        const Text('Live Sensor Data', 
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Temperature: ${sensorData['temperature'] ?? 'N/A'}'),
                    Text('Power: ${sensorData['power'] ?? 'N/A'}'),
                    Text('Voltage: ${sensorData['voltage'] ?? 'N/A'}'),
                  ],
                ),
              ),
            );
          },
        ),

        // Transfer Button
        ElevatedButton.icon(
          onPressed: _transferToFirestore,
          icon: const Icon(Icons.upload),
          label: const Text('Transfer to Firestore'),
        ),
      ],
    );
  }
}
```

## 🎯 When to Use Each Method

| Method | Use When |
|--------|----------|
| `readSensorDataFromRTDB()` (Stream) | Need real-time updates continuously |
| `fetchSensorDataFromRTDB()` | Need sensor data once |
| `fetchSystemDataFromRTDB()` | Need all system data once |
| `transferRTDBToFirestore()` | Want to manually sync one system |
| `transferSensorDataToFirestore()` | Want to update only sensor metrics |
| `transferAllSystemsFromRTDBToFirestore()` | Want to sync all systems at once |

## ✅ Summary

- **Fetch from RTDB**: Use `fetchSensorDataFromRTDB()` or `fetchSystemDataFromRTDB()`
- **Real-time updates**: Use `readSensorDataFromRTDB()` stream
- **Transfer to Firestore**: Use `transferRTDBToFirestore()` or `transferSensorDataToFirestore()`
- **Automatic sync**: Already configured, works automatically when you log in

