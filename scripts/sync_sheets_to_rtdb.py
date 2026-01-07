"""
Google Sheets to Firebase Realtime Database Sync Script
This script continuously reads data from Google Sheets (populated by AI model)
and writes it to Firebase Realtime Database, which then syncs to Firestore.
"""

import gspread
import firebase_admin
from firebase_admin import credentials, db
import time
import json
from datetime import datetime

# Configuration
SERVICE_ACCOUNT_KEY = "serviceAccountKey.json"  # Google Sheets service account
FIREBASE_CREDENTIALS = "firebase_admin_sdk.json"  # Firebase Admin SDK key
SHEET_URL = "https://docs.google.com/spreadsheets/d/1IX0RuXaSPnRVMK55IyTwLGdXozM3ESz3jheJIM4fW2c/edit?pli=1&gid=0#gid=0"  # Your Google Sheet URL

# System IDs mapping (if you have multiple systems)
SYSTEM_IDS = {
    "SystemName_1": "system_id_1",  # Map sheet system name to your Firestore system ID
    # Add more mappings as needed
}

def setup_firebase():
    """Initialize Firebase Admin SDK"""
    try:
        cred = credentials.Certificate(FIREBASE_CREDENTIALS)
        firebase_admin.initialize_app(cred, {
            'databaseURL': 'https://smartpump-38295-default-rtdb.firebaseio.com/'  # Your RTDB URL
        })
        print("✅ Firebase initialized")
        return True
    except Exception as e:
        print(f"❌ Firebase initialization error: {e}")
        return False

def setup_google_sheets():
    """Initialize Google Sheets API"""
    try:
        gc = gspread.service_account(filename=SERVICE_ACCOUNT_KEY)
        sh = gc.open_by_url(SHEET_URL)
        worksheet = sh.sheet1
        print("✅ Google Sheets connected")
        return worksheet
    except Exception as e:
        print(f"❌ Google Sheets connection error: {e}")
        return None

def sync_sheet_to_rtdb(worksheet):
    """Read latest data from Google Sheets and write to Realtime Database"""
    try:
        # Get all records from the sheet
        records = worksheet.get_all_records()
        
        if not records:
            print("⚠️ Sheet is empty")
            return
        
        # Get the latest row (assuming last row is most recent)
        latest_row = records[-1]
        
        # Extract data from sheet
        # Adjust column names based on your Google Sheet structure
        system_name = latest_row.get("SystemName", latest_row.get("System Name", "Unknown"))
        power = latest_row.get("Power", latest_row.get("Current Power", 0))
        efficiency = latest_row.get("Efficiency", latest_row.get("Efficiency %", 0))
        temperature = latest_row.get("Temperature", latest_row.get("Temp", None))
        voltage = latest_row.get("Voltage", latest_row.get("Volt", None))
        timestamp = latest_row.get("Timestamp", datetime.now().isoformat())
        
        # Get system ID (map from sheet name or use default)
        system_id = SYSTEM_IDS.get(system_name, "default_system")
        user_id = "ZacjQ6zispft2R0h9KQgGA4JZkb2"  # Replace with your user ID or make it dynamic
        
        # Prepare data for Realtime Database
        sensor_data = {
            "temperature": float(temperature) if temperature else None,
            "power": float(power) if power else 0.0,
            "voltage": float(voltage) if voltage else None,
            "timestamp": timestamp,
            "syncedAt": datetime.now().isoformat(),
            "source": "AI_Model_GoogleSheets"
        }
        
        # Remove None values
        sensor_data = {k: v for k, v in sensor_data.items() if v is not None}
        
        # Also prepare system data
        system_data = {
            "name": system_name,
            "currentPower": str(power),
            "efficiency": str(efficiency),
            "lastUpdated": timestamp,
            "source": "AI_Model_GoogleSheets"
        }
        
        # Write to Realtime Database
        # Path: /users/{userId}/systems/{systemId}/sensorData
        rtdb_ref_sensor = db.reference(f'/users/{user_id}/systems/{system_id}/sensorData')
        rtdb_ref_sensor.set(sensor_data)
        
        # Also update system data
        rtdb_ref_system = db.reference(f'/users/{user_id}/systems/{system_id}')
        rtdb_ref_system.update(system_data)
        
        print(f"✅ Synced to RTDB - System: {system_name}, Power: {power}, Efficiency: {efficiency}")
        
        # The DatabaseSyncService in Flutter will automatically sync this to Firestore
        
    except Exception as e:
        print(f"❌ Error syncing sheet to RTDB: {e}")
        import traceback
        traceback.print_exc()

def main():
    """Main loop - runs continuously"""
    print("🚀 Starting Google Sheets to Firebase Realtime Database sync...")
    print("=" * 60)
    
    # Setup Firebase
    if not setup_firebase():
        print("❌ Failed to initialize Firebase. Exiting.")
        return
    
    # Setup Google Sheets
    worksheet = setup_google_sheets()
    if not worksheet:
        print("❌ Failed to connect to Google Sheets. Exiting.")
        return
    
    print("\n📊 Sync started. Checking Google Sheets every 10 seconds...")
    print("Press Ctrl+C to stop\n")
    
    # Continuous sync loop
    while True:
        try:
            sync_sheet_to_rtdb(worksheet)
            time.sleep(10)  # Check every 10 seconds (adjust as needed)
        except KeyboardInterrupt:
            print("\n\n⏹️  Sync stopped by user")
            break
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
            time.sleep(10)  # Wait before retrying

if __name__ == "__main__":
    main()

