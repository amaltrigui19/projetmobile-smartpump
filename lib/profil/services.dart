import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const Color customGreen = Color(0xFF4A5D3F);
  static const Color bgColor = Color(0xFFF7F8F4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: customGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Text(
              "Contactez-nous",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: customGreen,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Vous souhaitez prendre contact ? Voici comment vous pouvez nous joindre :",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            
            // --- Contact Options ---
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: "Appeler",
              subtitle: "+111 22333444",
            ),
            const SizedBox(height: 20),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: "@Email",
              subtitle: "example@email.com",
            ),
            const SizedBox(height: 20),
            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: "Message",
              subtitle: "+111 22333444",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // Matches the oval shape in your photo
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: customGreen, size: 30),
          const SizedBox(width: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: customGreen,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }
}