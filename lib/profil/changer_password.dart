import 'package:flutter/material.dart';

class ChangerPasswordPage extends StatelessWidget {
  const ChangerPasswordPage({super.key});

  static const Color darkGreen = Color(0xFF4A5D3F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: darkGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 0.35,
              child: Image.asset('assets/images/image 21.png', fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Text(
                  "Changer le mot de passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkGreen),
                ),
                const SizedBox(height: 40),
                _buildTextField("mot de passe actuel"),
                const SizedBox(height: 15),
                _buildTextField("Nouveau mot de passe"),
                const SizedBox(height: 15),
                _buildTextField("confirmer le nouveau mot de passe"),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildButton("Annuler", const Color(0xFFF1F5EF), darkGreen),
                    _buildButton("Enregistrer", darkGreen, Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: darkGreen.withOpacity(0.5)),
        prefixIcon: const Icon(Icons.lock_outline, color: darkGreen),
        suffixIcon: const Icon(Icons.visibility_off_outlined, color: darkGreen),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: darkGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: darkGreen, width: 2),
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color bg, Color text) {
    return Container(
      width: 140,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        onPressed: () {},
        child: Text(label, style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }
}