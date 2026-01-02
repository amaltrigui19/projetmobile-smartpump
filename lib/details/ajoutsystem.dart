import 'package:flutter/material.dart';

const Color customGreen = Color(0xFF4A5D3F);
const Color lightGreen = Color(0xFFE8F5E9);
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

  final List<String> modelTypes = [
    'Système solaire',
    'Système éolien',
    'Système hybride',
    'Système de stockage',
  ];

  @override
  void dispose() {
    _modelNumberController.dispose();
    _surfaceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveSystem() {
    if (_formKey.currentState!.validate()) {
      final newSystem = {
        'type': selectedModelType,
        'modelNumber': _modelNumberController.text,
        'surface': _surfaceController.text,
        'location': _locationController.text,
      };

      Navigator.pop(context, newSystem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Système ajouté avec succès!'),
            ],
          ),
          backgroundColor: customGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: customGreen, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== TITRE =====
                const Text(
                  "Ajouter un nouveau",
                  style: TextStyle(
                    color: Color(0xFF2D3E28),
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "Système",
                  style: TextStyle(
                    color: customGreen,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Remplissez les informations ci-dessous",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 40),

                /// ===== TYPE DU MODÈLE =====
                _buildLabel("Type du système"),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedModelType,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      hintText: "Sélectionnez un type",
                      hintStyle: TextStyle(color: Color(0xFFB0BDB0)),
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down, color: customGreen),
                    items: modelTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: customGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedModelType = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner un type';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                /// ===== NUMÉRO DU MODÈLE =====
                _buildLabel("Numéro du modèle"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _modelNumberController,
                  hint: "Ex: MOD-2024-001",
                  icon: Icons.tag,
                ),

                const SizedBox(height: 24),

                /// ===== SUPERFICIE =====
                _buildLabel("Superficie du terrain"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _surfaceController,
                  hint: "Superficie en hectares",
                  keyboardType: TextInputType.number,
                  icon: Icons.landscape,
                ),

                const SizedBox(height: 24),

                /// ===== LOCALISATION =====
                _buildLabel("Localisation"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _locationController,
                  hint: "Entrez l'emplacement",
                  icon: Icons.location_on,
                ),

                const SizedBox(height: 40),

                /// ===== BOUTON ENREGISTRER =====
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveSystem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: customGreen.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline, size: 22),
                        SizedBox(width: 10),
                        Text(
                          "Ajouter le système",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== ILLUSTRATION =====
                Center(
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/image 19.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildPlantIcon(Icons.eco, Colors.green.shade400, 40),
                                const SizedBox(width: 15),
                                _buildPlantIcon(Icons.local_florist, Colors.green.shade500, 36),
                                const SizedBox(width: 15),
                                _buildPlantIcon(Icons.grass, Colors.green.shade300, 38),
                                const SizedBox(width: 15),
                                _buildPlantIcon(Icons.spa, Colors.green.shade600, 34),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: customGreen,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: customGreen,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            icon,
            color: customGreen.withOpacity(0.6),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est requis';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPlantIcon(IconData icon, Color color, double size) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}