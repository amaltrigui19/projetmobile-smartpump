import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const Color customGreen = Color(0xFF4A5D3F);
  static const Color bgColor = Color(0xFFF7F8F4);

  // --- Configuration de vos informations ---
  static const String myPhoneNumber = "+33123456789";
  static const String myEmail = "contact@votreentreprise.com";

  // --- Fonction générique pour lancer une URL ---
  Future<void> _launchCustomUrl(BuildContext context, Uri uri, String errorMessage) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vérification de la localisation pour éviter les erreurs null
    final l10n = AppLocalizations.of(context)!;

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
            Text(
              l10n.contactUs,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: customGreen,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              l10n.contactDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // --- CARTE TÉLÉPHONE ---
            _buildContactCard(
              icon: Icons.phone_forwarded_rounded,
              title: "Téléphone",
              subtitle: myPhoneNumber,
              onTap: () {
                final uri = Uri(scheme: 'tel', path: myPhoneNumber);
                _launchCustomUrl(context, uri, "Impossible d'ouvrir le téléphone");
              },
            ),

            const SizedBox(height: 15),

            // --- CARTE EMAIL ---
            _buildContactCard(
              icon: Icons.alternate_email_rounded,
              title: "Email",
              subtitle: myEmail,
              onTap: () {
                final uri = Uri.parse('mailto:$myEmail?subject=Contact&body=Bonjour,');
                _launchCustomUrl(context, uri, "Aucune application email installée");
              },
            ),

            const SizedBox(height: 15),

            // --- CARTE SMS ---
            _buildContactCard(
              icon: Icons.textsms_rounded,
              title: "SMS",
              subtitle: "Envoyez-nous un message",
              onTap: () {
                final uri = Uri(scheme: 'sms', path: myPhoneNumber);
                _launchCustomUrl(context, uri, "Impossible d'ouvrir les SMS");
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- Widget de Carte de Contact ---
  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: customGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: customGreen, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: customGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}