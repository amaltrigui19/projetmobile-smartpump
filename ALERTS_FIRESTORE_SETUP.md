# Alerts in Firestore - Setup Guide

This guide explains how alerts are structured in Firestore and how to add/manage them.

## Firestore Structure

Alerts are stored in a separate collection under each user:

```
users/
  {userId}/
    alerts/
      {alertId}/
        title: string
        subtitle: string (optional)
        description: string (optional)
        systemId: string
        severity: 'low' | 'medium' | 'high' | 'critical'
        createdAt: Timestamp
        isResolved: boolean
        updatedAt: Timestamp (optional)
```

## Adding Alerts to Firestore

### Method 1: Using Firebase Console

1. Go to Firebase Console → Firestore Database
2. Navigate to: `users/{userId}/alerts`
3. Click "+ Start collection" (if alerts collection doesn't exist)
4. Click "Add document"
5. Add the following fields:

**Example Alert:**
```
title: "Low power detected"
subtitle: "sys1"
description: "System power below threshold (5W)"
systemId: "9IU0g1QyreQ7m1mjc9HF"  // Use your actual system ID
severity: "high"
createdAt: [Timestamp - Server Timestamp]
isResolved: false
```

### Method 2: Using Flutter Code

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createAlert({
  required String title,
  String? subtitle,
  String? description,
  required String systemId,
  String severity = 'medium',
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('alerts')
      .add({
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'systemId': systemId,
    'severity': severity,
    'createdAt': FieldValue.serverTimestamp(),
    'isResolved': false,
  });
}

// Example usage:
await createAlert(
  title: 'Low power detected',
  subtitle: 'sys1',
  description: 'System power below threshold',
  systemId: '9IU0g1QyreQ7m1mjc9HF',
  severity: 'high',
);
```

### Method 3: From IoT Device/Backend

If you have an IoT device or backend monitoring systems, you can create alerts programmatically:

```python
# Python example (using Firebase Admin SDK)
import firebase_admin
from firebase_admin import firestore

db = firestore.client()

def create_alert(user_id, system_id, title, severity='medium'):
    alert_ref = db.collection('users').document(user_id).collection('alerts')
    alert_ref.add({
        'title': title,
        'systemId': system_id,
        'severity': severity,
        'createdAt': firestore.SERVER_TIMESTAMP,
        'isResolved': False,
    })
```

## Alert Severities

- **`low`**: Informational alerts (blue color)
- **`medium`**: Moderate issues (amber/yellow color)
- **`high`**: Important issues (orange color)
- **`critical`**: Urgent issues (red color)

## Marking Alerts as Resolved

```dart
Future<void> resolveAlert(String alertId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('alerts')
      .doc(alertId)
      .update({
    'isResolved': true,
    'resolvedAt': FieldValue.serverTimestamp(),
  });
}
```

## Firestore Index Required

The alerts query uses:
- `where('isResolved', isEqualTo: false)`
- `orderBy('createdAt', descending: true)`

**If you get an error about a missing index:**
1. Click the link in the error message (it will open Firebase Console)
2. Click "Create Index"
3. Wait a few minutes for the index to build
4. The query will work automatically once the index is ready

Or create it manually:
- Collection: `users/{userId}/alerts`
- Fields: `isResolved` (Ascending), `createdAt` (Descending)
- Query scope: Collection

## Real-time Updates

The app automatically displays alerts in real-time. When you add/update/delete an alert in Firestore:
- The app will update immediately (no refresh needed)
- Alerts appear on the home page automatically
- Only unresolved alerts are shown

## Testing

1. **Create a test alert in Firebase Console:**
   - Go to Firestore
   - Navigate to `users/{yourUserId}/alerts`
   - Add a document with the fields above

2. **Verify it appears in the app:**
   - Open the app's home page
   - The alert should appear in the "Dernières alertes" section
   - Click the alert to navigate to the system detail page

3. **Test real-time updates:**
   - Keep the app open
   - Add/modify an alert in Firebase Console
   - The app should update automatically

## Example Alert Document

```json
{
  "title": "Low power detected",
  "subtitle": "sys1",
  "description": "System power is 2W, below minimum threshold of 5W",
  "systemId": "9IU0g1QyreQ7m1mjc9HF",
  "severity": "high",
  "createdAt": "2026-01-02T12:48:59.575717Z",
  "isResolved": false
}
```

## Integration with Systems

Each alert is linked to a system via `systemId`. When you click an alert:
- It navigates to the system detail page
- Shows information about the affected system
- Allows you to view system metrics and take action

