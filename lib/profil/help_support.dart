import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const Text("Aide/support", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: darkGreen)),
                const Text(
                  "Tout ce que vous devez savoir sur Smart Pump Power",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: darkGreen),
                ),
                const SizedBox(height: 20),
                const Text(
                  "\"Bienvenue sur Smart Pump Power ! Cette application a été conçue pour vous aider à surveiller...\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: darkGreen),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(" FAQ:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen)),
                      _buildFAQItem("Comment démarrer ma pompe ?"),
                      _buildFAQItem("Que faire si la pompe surchauffe ?"),
                      _buildFAQItem("Comment lire la consommation d’énergie ?"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String title) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
    );
  }
}