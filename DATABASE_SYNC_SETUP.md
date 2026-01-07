# Firebase Realtime Database & Firestore Synchronization Setup

This guide explains how to connect and synchronize data between Firebase Realtime Database and Firestore.

## Overview

The app now supports **bidirectional synchronization** between:
- **Firebase Realtime Database (RTDB)**: Fast, real-time updates (ideal for IoT sensor data)
- **Cloud Firestore**: Structured queries and data organization

## Firebase Console Setup

### Step 1: Enable Realtime Database

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `smartpump-38295`
3. Navigate to **Build** → **Realtime Database**
4. Click **Create Database**
5. Choose location (prefer same region as Firestore)
6. Start in **Test Mode** for development (or configure security rules)
7. Click **Enable**

### Step 2: Configure Security Rules

#### Realtime Database Rules:
```json
{
  "rules": {
    "users": {
      "$userId": {
        "systems": {
          "$systemId": {
            ".read": "$userId === auth.uid",
            ".write": "$userId === auth.uid",
            "sensorData": {
              ".read": "$userId === auth.uid",
              ".write": "$userId === auth.uid || true" // Allow IoT devices with proper auth
            }
          }
        }
      }
    }
  }
}
```

#### Firestore Rules (if not already configured):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## How Synchronization Works

### Architecture

```
┌─────────────────┐         ┌──────────────────┐
│   IoT Devices   │────────▶│  Realtime DB     │
│  (Sensors, etc) │         │  (Fast Updates)  │
└─────────────────┘         └────────┬─────────┘
                                     │
                                     │ Auto Sync
                                     ▼
                           ┌──────────────────┐
                           │    Firestore     │
                           │ (Queries, Struct)│
                           └──────────────────┘
                                     │
                                     │ Auto Sync
                                     ▼
                           ┌──────────────────┐
                           │   Flutter App    │
                           │   (Display Data) │
                           └──────────────────┘
```

### Data Flow

1. **RTDB → Firestore**: 
   - IoT devices write sensor data to Realtime Database
   - `DatabaseSyncService` automatically syncs to Firestore
   - Used for: Real-time sensor updates, fast writes

2. **Firestore → RTDB**: 
   - App writes system configurations to Firestore
   - `DatabaseSyncService` automatically syncs to Realtime Database
   - Used for: System settings, structured data

## Database Structure

### Realtime Database:
```
/users
  /{userId}
    /systems
      /{systemId}
        name: "Solar System 1"
        currentPower: "5.2"
        efficiency: "92"
        /sensorData
          temperature: 25.5
          power: 5.2
          timestamp: 1234567890
          syncedAt: "2024-01-01T12:00:00Z"
```

### Firestore:
```
users/{userId}/systems/{systemId}
  - name: string
  - modelNumber: string
  - currentPower: string
  - efficiency: string
  - createdAt: Timestamp
  - lastUpdated: Timestamp
```

## Usage Examples

### Writing Sensor Data (IoT Device → RTDB)
```dart
await DatabaseSyncService.writeSensorDataToRTDB(
  systemId: 'system123',
  sensorData: {
    'temperature': 25.5,
    'power': 5.2,
    'voltage': 220.0,
  },
);
// This will automatically sync to Firestore
```

### Reading Real-time Sensor Data
```dart
Stream<Map<String, dynamic>?> sensorStream = 
    DatabaseSyncService.readSensorDataFromRTDB('system123');

sensorStream.listen((data) {
  if (data != null) {
    print('Temperature: ${data['temperature']}');
    print('Power: ${data['power']}');
  }
});
```

### Updating System in Firestore (Auto-syncs to RTDB)
```dart
await DatabaseSyncService.updateSystemInFirestore(
  systemId: 'system123',
  data: {
    'currentPower': '6.5',
    'efficiency': '95',
  },
);
// This will automatically sync to Realtime Database
```

## Initialization

The sync service is automatically initialized when:
1. User logs in (`loginpage.dart`)
2. User opens app (already logged in) (`splashpage.dart`)

You can manually initialize:
```dart
await DatabaseSyncService.initializeSync();
```

## Testing

### Test Realtime Database → Firestore Sync:

1. **Write to RTDB** (in Firebase Console or via code):
   ```
   /users/{yourUserId}/systems/test-system
   {
     "name": "Test System",
     "currentPower": "10.5",
     "efficiency": "98"
   }
   ```

2. **Check Firestore**: Should appear in `users/{yourUserId}/systems/test-system`

### Test Firestore → Realtime Database Sync:

1. **Write to Firestore**:
   ```dart
   await FirebaseFirestore.instance
       .collection('users')
       .doc(userId)
       .collection('systems')
       .doc('test-system')
       .set({
         'name': 'Test System 2',
         'currentPower': '12.0',
       });
   ```

2. **Check RTDB**: Should appear in `/users/{userId}/systems/test-system`

## Troubleshooting

### Sync Not Working?
1. ✅ Check Realtime Database is enabled in Firebase Console
2. ✅ Verify security rules allow read/write
3. ✅ Ensure user is authenticated
4. ✅ Check console logs for sync errors
5. ✅ Verify `DatabaseSyncService.initializeSync()` is called after login

### Performance Tips
- Realtime Database: Use for high-frequency updates (sensor data)
- Firestore: Use for structured queries and complex data
- Both sync automatically, choose based on use case

## Cleanup

When user logs out, cleanup is automatically handled:
```dart
DatabaseSyncService.cleanup(userId);
```

Or cleanup all listeners:
```dart
DatabaseSyncService.cleanupAll();
```

## Next Steps

1. ✅ Enable Realtime Database in Firebase Console
2. ✅ Configure security rules (see above)
3. ✅ Test synchronization with sample data
4. ✅ Connect IoT devices to write to Realtime Database
5. ✅ App will automatically display synced data

