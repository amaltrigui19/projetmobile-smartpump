import 'package:flutter/material.dart';

class ChoisirLanguePage extends StatelessWidget {
  const ChoisirLanguePage({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "choisissez la language",
              style: TextStyle(fontSize: 30, color: Color(0xFF1E3606), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _langButton("Français"),
                const SizedBox(width: 40),
                _langButton("Arabe"),
              ],
            ),
            const SizedBox(height: 30),
            _langButton("English"),
          ],
        ),
      ),
    );
  }

  Widget _langButton(String label) {
    return SizedBox(
      width: 130,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {},
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}