import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; 
import '../models/system_model.dart';

const Color customGreen = Color(0xFF4A5D3F);
const Color bgColor = Color(0xFFF7F8F4);

class AddSystemPage extends StatefulWidget {
  const AddSystemPage({super.key});

  @override
  State<AddSystemPage> createState() => _AddSystemPageState();
}

class _AddSystemPageState extends State<AddSystemPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedModelType;

  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _surfaceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Position par défaut (Tunis)
  double _lat = 36.8065;
  double _lon = 10.1815;

  final List<String> modelTypes = [
    'Système solaire',
    'Système éolien',
    'Système hybride',
    'Système de stockage',
  ];

  void _saveSystem() {
    if (_formKey.currentState!.validate()) {
      final newSystem = System(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: selectedModelType ?? "Inconnu",
        modelNumber: _modelNumberController.text,
        surface: _surfaceController.text,
        locationName: _locationController.text,
        currentPower: "0.0",
        dailyEnergy: "0.0",
        efficiency: "95",
        totalFlow: "0.0",
        latitude: _lat,
        longitude: _lon,
      );

      Navigator.pop(context, newSystem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Nouveau Système",
          style: TextStyle(color: customGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: customGreen),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Informations générales",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customGreen),
              ),
              const SizedBox(height: 15),
              _buildDropdown(),
              const SizedBox(height: 25),
              
              const Text(
                "Position géographique",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: customGreen),
              ),
              const Text(
                "Faites glisser la carte pour viser votre site",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              _buildMapSection(),
              
              const SizedBox(height: 25),
              _buildTextField(_locationController, "Nom du site (ex: Ferme Nord)", Icons.map),
              _buildTextField(_modelNumberController, "Numéro de modèle", Icons.tag),
              _buildTextField(_surfaceController, "Superficie (Hectares)", Icons.landscape, keyboard: TextInputType.number),
              
              const SizedBox(height: 30),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(_lat, _lon),
                initialZoom: 11.0,
                onPositionChanged: (dynamic position, bool hasGesture) {
                  // Met à jour les variables et l'affichage en temps réel
                  setState(() {
                    _lat = position.center.latitude;
                    _lon = position.center.longitude;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.solarapp.app',
                ),
              ],
            ),
            // Le marqueur de visée central
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Icon(Icons.location_on, color: Colors.red, size: 42),
              ),
            ),
            // Affichage des coordonnées GPS en bas de la carte
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: customGreen.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.gps_fixed, size: 14, color: customGreen),
                    const SizedBox(width: 8),
                    Text(
                      "Lat: ${_lat.toStringAsFixed(5)} | Lon: ${_lon.toStringAsFixed(5)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: customGreen,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: customGreen),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedModelType,
      items: modelTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
      onChanged: (v) => setState(() => selectedModelType = v),
      decoration: InputDecoration(
        labelText: "Type de système",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) => value == null ? 'Veuillez choisir un type' : null,
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _saveSystem,
        style: ElevatedButton.styleFrom(
          backgroundColor: customGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
        child: const Text(
          "ENREGISTRER LE SYSTÈME",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
      ),
    );
  }
}