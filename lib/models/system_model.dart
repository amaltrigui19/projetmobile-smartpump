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
  final double latitude;  // Vérifiez que c'est bien présent
  final double longitude; // Vérifiez que c'est bien présent

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
}