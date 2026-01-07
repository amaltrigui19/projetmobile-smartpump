# Google Sheets Direct Integration

Your Flutter app is now directly connected to your Google Sheet for alerts!

## How It Works

The app fetches alerts directly from your Google Sheet:
- **Sheet URL**: https://docs.google.com/spreadsheets/d/1IX0RuXaSPnRVMK55IyTwLGdXozM3ESz3jheJIM4fW2c

## Sheet Format

The service parses alerts from rows that contain the following format:
```
TITLE: [Alert Title]
BODY: [Alert Description]
URGENCY: [HIGH/MEDIUM/LOW]
TECHNICIAN: [YES/NO]
```

Example (Row 3):
```
TITLE: Pump pump_001 is reporting an overheat error with a temperature of 74.26°C.
BODY: Immediately shut down pump pump_001 to prevent further damage. A technician needs to inspect the system and identify the cause of the overheating.
URGENCY: HIGH
TECHNICIAN: YES
```

## How It Works

1. **Google Sheets Service** (`lib/services/google_sheets_service.dart`):
   - Fetches data via CSV export (no authentication needed for public sheets)
   - Parses alert format automatically
   - Extracts system IDs, error types, and severity

2. **Home Page Integration**:
   - Displays alerts from Google Sheets on the home page
   - Falls back to Firestore if Google Sheets is unavailable
   - Shows alerts in real-time (refreshes when you reload)

## Making the Sheet Public (Required)

For the CSV export to work, your Google Sheet must be:
1. **Public or "Anyone with the link can view"**
   - Click "Share" button in Google Sheets
   - Change access to "Anyone with the link" → "Viewer"
   - Click "Done"

## Automatic Refresh

The app fetches alerts when:
- The home page loads
- You navigate back to the home page
- You can add a refresh button for manual updates

## Adding Real-Time Updates

If you want automatic polling (e.g., every 30 seconds), you can use:
```dart
StreamBuilder<List<AlertItem>>(
  stream: GoogleSheetsService.fetchAlertsStream(pollInterval: Duration(seconds: 30)),
  builder: (context, snapshot) {
    // Display alerts
  },
)
```

## Troubleshooting

**Alerts not showing?**
- Make sure the sheet is public ("Anyone with the link can view")
- Check that rows contain the TITLE:, BODY:, URGENCY:, TECHNICIAN: format
- Verify the sheet ID is correct: `1IX0RuXaSPnRVMK55IyTwLGdXozM3ESz3jheJIM4fW2c`

**Parse errors?**
- Ensure each alert row has all required fields (TITLE, BODY, URGENCY, TECHNICIAN)
- Check console logs for parsing errors

## Next Steps

1. **Make your sheet public** (see above)
2. **Test the app** - alerts should appear automatically
3. **Add more alerts** to your sheet using the same format
4. Optionally: Add a refresh button or automatic polling for real-time updates
