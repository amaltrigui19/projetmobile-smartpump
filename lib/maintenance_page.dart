import 'package:flutter/material.dart';

class MaintenancePompePage extends StatelessWidget {
  const MaintenancePompePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkGreen = Color(0xFF4C6B3F);
    const Color coralRed = Color(0xFFE55751);
    const Color lightGreenBg = Color(0xFFD4E9C6);
    const Color iconPink = Color(0xFFF2A7AD);
    const Color borderColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Système 2',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: borderColor)),
              child: const Text(
                'Vérifier la pompe',
                textAlign: TextAlign.center,
                style: TextStyle(color: coralRed, fontSize: 24),
              ),
            ),
            const SizedBox(height: 35),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: darkGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.warning_amber_rounded, color: iconPink, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'INFORMATION/NOTICE',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: lightGreenBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        'La pompe a peut-être surchauffé en raison d’un fonctionnement prolongé.',
                        style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
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
}