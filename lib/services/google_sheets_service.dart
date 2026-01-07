import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alert_model.dart';

/// Service to fetch alerts directly from Google Sheets
class GoogleSheetsService {
  // Google Sheet URL - extract the sheet ID
  static const String sheetId = '1IX0RuXaSPnRVMK55IyTwLGdXozM3ESz3jheJIM4fW2c';
  
  // CSV export URL (no authentication needed for public sheets)
  static String get csvUrl => 'https://docs.google.com/spreadsheets/d/$sheetId/export?format=csv&gid=0';

  /// Fetch alerts from Google Sheets
  static Future<List<AlertItem>> fetchAlerts() async {
    try {
      final response = await http.get(Uri.parse(csvUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch Google Sheet: ${response.statusCode}');
      }

      // Parse CSV data
      final csvData = utf8.decode(response.bodyBytes);
      final lines = csvData.split('\n');
      
      List<AlertItem> alerts = [];
      
      // Skip header rows and parse alert data
      // Looking for rows that contain "TITLE:" pattern
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty || !line.contains('TITLE:')) continue;
        
        try {
          final alert = _parseAlertLine(line, i);
          if (alert != null) {
            alerts.add(alert);
          }
        } catch (e) {
          print('Error parsing alert at line ${i + 1}: $e');
        }
      }
      
      return alerts;
    } catch (e) {
      print('Error fetching alerts from Google Sheets: $e');
      return [];
    }
  }

  /// Parse a single alert line from the sheet
  static AlertItem? _parseAlertLine(String line, int rowIndex) {
    try {
      // Extract TITLE
      final titleMatch = RegExp(r'TITLE:\s*(.+?)(?:\.|BODY:)', caseSensitive: false).firstMatch(line);
      String title = titleMatch?.group(1)?.trim() ?? 'Unknown Alert';
      
      // Extract BODY
      final bodyMatch = RegExp(r'BODY:\s*(.+?)(?:URGENCY:)', caseSensitive: false).firstMatch(line);
      String body = bodyMatch?.group(1)?.trim() ?? 'No description';
      
      // Extract URGENCY
      final urgencyMatch = RegExp(r'URGENCY:\s*([A-Z]+)', caseSensitive: false).firstMatch(line);
      String urgency = urgencyMatch?.group(1)?.trim().toUpperCase() ?? 'MEDIUM';
      
      // Extract TECHNICIAN
      final technicianMatch = RegExp(r'TECHNICIAN:\s*(YES|NO)', caseSensitive: false).firstMatch(line);
      bool technicianRequired = (technicianMatch?.group(1)?.trim().toUpperCase() ?? 'NO') == 'YES';
      
      // Extract system ID from title (e.g., "pump_001", "pump_1", "Pump pump_001")
      String systemId = 'unknown';
      final systemMatch = RegExp(r'(?:pump|Pump)[_ ]?(\w+)', caseSensitive: false).firstMatch(title);
      if (systemMatch != null) {
        systemId = 'pump_${systemMatch.group(1)}';
      }
      
      // Extract error type and severity from title
      String errorType = 'unknown';
      String severity = urgency;
      
      if (title.toLowerCase().contains('overheat')) {
        errorType = 'overheat';
        severity = 'HIGH';
      } else if (title.toLowerCase().contains('power')) {
        errorType = 'low_power';
      } else if (title.toLowerCase().contains('motor')) {
        errorType = 'motor_fault';
      } else if (title.toLowerCase().contains('sensor')) {
        errorType = 'sensor_fault';
      } else if (title.toLowerCase().contains('flow')) {
        errorType = 'low_flow';
      }
      
      // Extract temperature if available
      Map<String, dynamic>? sensorData;
      final tempMatch = RegExp(r'(\d+\.?\d*)\s*°?C', caseSensitive: false).firstMatch(title);
      if (tempMatch != null) {
        sensorData = {'temperature': double.tryParse(tempMatch.group(1) ?? '')};
      }
      
      return AlertItem(
        id: 'sheet_alert_${rowIndex}_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        urgency: urgency,
        technicianRequired: technicianRequired,
        systemId: systemId,
        severity: severity,
        errorType: errorType,
        sensorData: sensorData,
        createdAt: DateTime.now(),
        isResolved: false,
        location: null,
      );
    } catch (e) {
      print('Error parsing alert line: $e');
      return null;
    }
  }

  /// Fetch alerts as a stream (for real-time updates)
  /// Polls the sheet every [pollInterval] seconds
  static Stream<List<AlertItem>> fetchAlertsStream({Duration pollInterval = const Duration(seconds: 30)}) async* {
    while (true) {
      try {
        final alerts = await fetchAlerts();
        yield alerts;
        await Future.delayed(pollInterval);
      } catch (e) {
        print('Error in alert stream: $e');
        await Future.delayed(pollInterval);
      }
    }
  }
}
