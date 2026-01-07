# AI Model Data Integration Guide

This guide explains how to integrate AI model data from Google Sheets into your Flutter app.

## 📊 Architecture Overview

```
┌─────────────────┐
│   AI Model      │
│   (Python)      │
└────────┬────────┘
         │ Writes data
         ▼
┌─────────────────┐
│  Google Sheets  │
│  (via API Key)  │
└────────┬────────┘
         │ Python Script reads
         │ every 10 seconds
         ▼
┌─────────────────┐
│ Realtime DB     │
│ (Firebase RTDB) │
└────────┬────────┘
         │ Auto-sync
         ▼
┌─────────────────┐
│   Firestore     │
│  (Firebase)     │
└────────┬────────┘
         │ Flutter App reads
         ▼
┌─────────────────┐
│   Flutter App   │
│   (UI Display)  │
└─────────────────┘
```

## 🔧 Setup Steps

### Step 1: Configure Google Sheets

1. **Create/Open Google Sheet** with columns:
   ```
   SystemName | Power | Efficiency | Temperature | Voltage | Timestamp
   ```

2. **Enable Google Sheets API**:
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Enable "Google Sheets API"

3. **Create Service Account**:
   - IAM & Admin → Service Accounts
   - Create service account
   - Download JSON key as `serviceAccountKey.json`

4. **Share Sheet** with service account email (found in JSON file)

### Step 2: Setup Python Bridge Script

1. **Install dependencies**:
   ```bash
   cd scripts
   pip install -r requirements.txt
   ```

2. **Get Firebase Admin SDK**:
   - Firebase Console → Project Settings → Service Accounts
   - Generate new private key → Save as `firebase_admin_sdk.json`

3. **Configure script** (`scripts/sync_sheets_to_rtdb.py`):
   - Update `SHEET_URL` with your Google Sheet URL
   - Update `SYSTEM_IDS` mapping
   - Update `user_id` with your Firebase user ID
   - Update Firebase Realtime Database URL

4. **Run script**:
   ```bash
   python sync_sheets_to_rtdb.py
   ```

### Step 3: Flutter App Integration

The app now has **2 data sources**:

1. **User Profile Data** (Static):
   - Name, phone, preferences
   - Stored in: `users/{userId}`

2. **AI Model Data** (Real-time):
   - Power, efficiency, temperature, voltage
   - Stored in: `users/{userId}/systems/{systemId}`
   - Tagged with: `source: "AI_Model_GoogleSheets"`

## 📱 Using the AI Model Data Widget

### In System Detail Page (Already Integrated):

The `AIModelDataWidget` is already added to `SystemDetailPage`. It automatically:
- ✅ Displays real-time AI model data
- ✅ Shows data from both Firestore and RTDB
- ✅ Updates automatically when new data arrives
- ✅ Shows "En attente" if no data is available

### Add to Home Page:

```dart
import '../widgets/ai_model_data_widget.dart';

// Inside your home page
AIModelDataWidget(
  systemId: 'your-system-id',
  systemName: 'System Name',
)
```

## 🎯 Data Sources in Your App

### Source 1: User Profile Data

```dart
// From Firestore
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots(),
  builder: (context, snapshot) {
    final data = snapshot.data?.data();
    final name = data['name'];
    final phone = data['phone'];
    // Display user info
  },
)
```

### Source 2: AI Model Data

```dart
// Already integrated via AIModelDataWidget
// OR manually:

// From Firestore (synced from RTDB)
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('systems')
      .doc(systemId)
      .snapshots(),
  builder: (context, snapshot) {
    final data = snapshot.data?.data();
    if (data['source'] == 'AI_Model_GoogleSheets') {
      // This is AI model data
      final power = data['power'];
      final efficiency = data['efficiency'];
    }
  },
)

// OR directly from Realtime Database (more real-time)
StreamBuilder<Map<String, dynamic>?>(
  stream: DatabaseSyncService.readSensorDataFromRTDB(systemId),
  builder: (context, snapshot) {
    final data = snapshot.data;
    // Real-time AI model data
  },
)
```

## 🔄 Automatic Sync

The `DatabaseSyncService` automatically syncs:
- ✅ RTDB → Firestore (happens automatically when data changes)
- ✅ Your app reads from Firestore (or RTDB for real-time)

## 📋 Google Sheet Format

Your Google Sheet should have this structure:

| SystemName | Power | Efficiency | Temperature | Voltage | Timestamp |
|------------|-------|------------|-------------|---------|-----------|
| System 1   | 5.2   | 92         | 25.5        | 220     | 2026-01-02T12:00:00 |

**Note**: Column names can be customized in the Python script.

## 🚀 Running the Python Script

### Development:
```bash
python scripts/sync_sheets_to_rtdb.py
```

### Production (Linux/Mac):
```bash
# Using screen
screen -S sheets_sync
python scripts/sync_sheets_to_rtdb.py
# Detach: Ctrl+A, then D
```

### Production (Windows):
Use Task Scheduler to run the script as a service.

## ✅ Verification

1. **Check Python Script**:
   - Should print "✅ Synced to RTDB" messages
   - Runs every 10 seconds

2. **Check Firebase Realtime Database**:
   - Path: `/users/{userId}/systems/{systemId}/sensorData`
   - Should see data with `source: "AI_Model_GoogleSheets"`

3. **Check Firestore**:
   - Path: `users/{userId}/systems/{systemId}`
   - Should see synced data

4. **Check Flutter App**:
   - Open System Detail Page
   - Should see "Données IA en Temps Réel" widget
   - Data should update automatically

## 🎨 Customization

### Customize Widget Appearance:

Edit `lib/widgets/ai_model_data_widget.dart`:
- Change colors
- Add/remove metrics
- Customize layout

### Customize Sync Frequency:

Edit `scripts/sync_sheets_to_rtdb.py`:
```python
time.sleep(10)  # Change to 5, 30, 60, etc.
```

### Customize Sheet Columns:

Edit the script's column mapping:
```python
system_name = latest_row.get("SystemName", "Unknown")
power = latest_row.get("Power", 0)
# Add more columns as needed
```

## 🔍 Troubleshooting

### Data not appearing in app?
1. ✅ Check Python script is running
2. ✅ Check RTDB has data
3. ✅ Check Firestore has synced data
4. ✅ Verify `systemId` matches

### "Permission denied" in Python script?
- Share Google Sheet with service account email
- Check service account JSON key path

### Data not syncing to Firestore?
- Verify `DatabaseSyncService.initializeSync()` is called on login
- Check sync logs in console

## 📊 Summary

✅ **Python Script** reads Google Sheets → writes to RTDB  
✅ **DatabaseSyncService** auto-syncs RTDB → Firestore  
✅ **AIModelDataWidget** displays data in your app  
✅ **2 Data Sources**: User profile + AI model data  
✅ **Real-time Updates**: Data updates automatically  

Your app now has access to both user profile data and AI model predictions! 🎉

