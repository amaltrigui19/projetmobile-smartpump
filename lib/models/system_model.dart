class System {
  final String id;
  final String name;
  final String currentPower; // "2.5"
  final String dailyEnergy;  // "12.8"
  final String efficiency;   // "95"
  final String totalFlow;    // "450"

  System({
    required this.id,
    required this.name,
    this.currentPower = "0.0",
    this.dailyEnergy = "0.0",
    this.efficiency = "0",
    this.totalFlow = "0",
  });
}