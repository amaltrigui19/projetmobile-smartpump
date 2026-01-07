# Google Sheets to Firebase Sync Setup

This script syncs data from Google Sheets (populated by your AI model) to Firebase Realtime Database, which then automatically syncs to Firestore via your Flutter app.

## 📋 Prerequisites

1. **Google Cloud Project** with:
   - Google Sheets API enabled
   - Service Account created
   - Service account JSON key downloaded

2. **Firebase Project** with:
   - Realtime Database enabled
   - Firebase Admin SDK service account JSON key downloaded

3. **Google Sheet** shared with the service account email

## 🔧 Setup Steps

### Step 1: Install Python Dependencies

```bash
pip install -r requirements.txt
```

### Step 2: Get Google Sheets Service Account

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create or select a project
3. Enable **Google Sheets API**
4. Go to **IAM & Admin** → **Service Accounts**
5. Create a new service account or use existing
6. Create a key (JSON format) → Download as `serviceAccountKey.json`
7. **Important**: Share your Google Sheet with the service account email (found in the JSON file)

### Step 3: Get Firebase Admin SDK Credentials

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `smartpump-38295`
3. Go to **Project Settings** → **Service Accounts**
4. Click **Generate New Private Key** → Download as `firebase_admin_sdk.json`

### Step 4: Configure the Script

Edit `sync_sheets_to_rtdb.py`:

1. **Update paths**:
   ```python
   SERVICE_ACCOUNT_KEY = "serviceAccountKey.json"
   FIREBASE_CREDENTIALS = "firebase_admin_sdk.json"
   ```

2. **Update Google Sheet URL**:
   ```python
   SHEET_URL = "https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit"
   ```

3. **Update Firebase Realtime Database URL**:
   ```python
   'databaseURL': 'https://smartpump-38295-default-rtdb.firebaseio.com/'
   ```
   (Get this from Firebase Console → Realtime Database)

4. **Update System IDs mapping**:
   ```python
   SYSTEM_IDS = {
       "SystemName_1": "your_firestore_system_id_1",
       "SystemName_2": "your_firestore_system_id_2",
   }
   ```

5. **Update User ID**:
   ```python
   user_id = "ZacjQ6zispft2R0h9KQgGA4JZkb2"  # Or make it dynamic
   ```

### Step 5: Configure Google Sheet Structure

Your Google Sheet should have columns like:

| SystemName | Power | Efficiency | Temperature | Voltage | Timestamp |
|------------|-------|------------|-------------|---------|-----------|
| System 1   | 5.2   | 92         | 25.5        | 220     | 2026-01-02 |

Adjust column names in the script if your sheet uses different names:
```python
system_name = latest_row.get("SystemName", latest_row.get("System Name", "Unknown"))
```

### Step 6: Run the Script

```bash
python sync_sheets_to_rtdb.py
```

The script will:
- ✅ Read latest data from Google Sheets every 10 seconds
- ✅ Write to Firebase Realtime Database
- ✅ Your Flutter app's `DatabaseSyncService` will automatically sync to Firestore

## 🔄 Data Flow

```
Google Sheets (AI Model writes here)
    ↓
Python Script (reads every 10 seconds)
    ↓
Firebase Realtime Database
    ↓
DatabaseSyncService (auto-sync)
    ↓
Firestore
    ↓
Flutter App (displays data)
```

## 🚀 Running as a Service (Production)

### On Linux/Mac:

```bash
# Using screen
screen -S sheets_sync
python sync_sheets_to_rtdb.py

# Detach: Ctrl+A, then D
# Reattach: screen -r sheets_sync
```

### On Windows:

Use Task Scheduler or run as a Windows Service.

## 📝 Notes

- The script checks Google Sheets every 10 seconds (adjustable)
- Data is written to RTDB path: `/users/{userId}/systems/{systemId}/sensorData`
- Your Flutter app's sync service automatically transfers to Firestore
- The script tags data with `source: "AI_Model_GoogleSheets"` for identification

## 🔍 Troubleshooting

### "Permission denied" error
- Make sure the service account email has access to the Google Sheet
- Share the sheet with the email found in `serviceAccountKey.json`

### "Firebase not initialized" error
- Check that `firebase_admin_sdk.json` path is correct
- Verify the database URL matches your Firebase project

### "Sheet not found" error
- Verify the Sheet URL is correct
- Make sure the service account has access to the sheet

## 📊 Monitoring

The script prints sync status to console:
- ✅ Successful syncs
- ❌ Errors
- ⚠️ Warnings

Check logs to ensure data is being synced properly.

