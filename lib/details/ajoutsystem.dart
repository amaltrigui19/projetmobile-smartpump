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

  final TextEditingController _modelNumberController =
      TextEditingController();
  final TextEditingController _surfaceController =
      TextEditingController();
  final TextEditingController _locationController =
      TextEditingController();

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
      Navigator.pop(context);

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

      /// ===== APPBAR SOBRE =====
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: customGreen,
            size: 20,
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

                /// ===== CARTE TITRE (AMÉLIORATION DU HAUT) =====
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ajouter un nouveau",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Système",
                        style: TextStyle(
                          color: customGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Remplissez les informations ci-dessous",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// ===== TYPE DU SYSTÈME =====
                _buildLabel("Type du système"),
                const SizedBox(height: 8),
                _buildDropdown(),

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

                /// ===== BOUTON =====
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
                          ),
                        ),
                      ],
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

  /// ================= WIDGETS =================

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

  Widget _buildDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: selectedModelType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          hintText: "Sélectionnez un type",
        ),
        items: modelTypes
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: const TextStyle(color: customGreen),
                ),
              ),
            )
            .toList(),
        onChanged: (value) =>
            setState(() => selectedModelType = value),
        validator: (value) =>
            value == null ? "Veuillez sélectionner un type" : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: customGreen.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Ce champ est requis' : null,
      ),
    );
  }
}
