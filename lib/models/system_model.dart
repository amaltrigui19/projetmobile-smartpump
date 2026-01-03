class System {
  final String id;
  final String name;
  final String modelNumber;
  final String surface;
  final String locationName;
  final String currentPower;
  final String dailyEnergy;
  final String efficiency;
  final String totalFlow;
  final double latitude;
  final double longitude;

  System({
    required this.id,
    required this.name,
    required this.modelNumber,
    required this.surface,
    required this.locationName,
    required this.currentPower,
    required this.dailyEnergy,
    required this.efficiency,
    required this.totalFlow,
    required this.latitude,
    required this.longitude,
  });

  // Create a System object from Firestore document
  factory System.fromMap(Map<String, dynamic> data, String documentId) {
    return System(
      id: documentId,
      name: data['name'] ?? '',
      modelNumber: data['modelNumber'] ?? '',
      surface: data['surface'] ?? '',
      locationName: data['locationName'] ?? '',
      currentPower: data['currentPower'] ?? '',
      dailyEnergy: data['dailyEnergy'] ?? '',
      efficiency: data['efficiency'] ?? '',
      totalFlow: data['totalFlow'] ?? '',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
    );
  }

  // Convert System object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'modelNumber': modelNumber,
      'surface': surface,
      'locationName': locationName,
      'currentPower': currentPower,
      'dailyEnergy': dailyEnergy,
      'efficiency': efficiency,
      'totalFlow': totalFlow,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}