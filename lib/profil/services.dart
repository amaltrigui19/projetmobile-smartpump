import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const Color customGreen = Color(0xFF4A5D3F);
  static const Color bgColor = Color(0xFFF7F8F4);

  // --- Appel téléphonique ---
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    try {
      final Uri uri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir l\'application téléphone'),
              backgroundColor: customGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Envoyer un Email ---
  Future<void> _sendEmail(BuildContext context, String email) async {
    try {
      final Uri uri = Uri.parse('mailto:$email?subject=Contact&body=Bonjour,');

      // Try to launch directly - Gmail and other email apps should handle mailto: URIs
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // If that fails, try platform default
        try {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        } catch (e2) {
          // If both fail, show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Impossible d\'ouvrir l\'application email. Vérifiez que vous avez une application email installée (Gmail, Outlook, etc.)'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Envoyer un SMS ---
  Future<void> _sendSMS(BuildContext context, String phoneNumber) async {
    try {
      final Uri uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {
          'body': 'Bonjour,',
        },
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible d\'ouvrir l\'application SMS'),
              backgroundColor: customGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

            // --- Appeler ---
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: l10n.call,
              subtitle: "+111 22333444",
              onTap: () => _makePhoneCall(context, "+11122333444"),
            ),

            const SizedBox(height: 20),

            // --- Email ---
            _buildContactCard(
              icon: Icons.email_outlined,
              title: l10n.email,
              subtitle: "example@email.com",
              onTap: () => _sendEmail(context, "example@email.com"),
            ),

            const SizedBox(height: 20),

            // --- SMS ---
            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: l10n.message,
              subtitle: "+111 22333444",
              onTap: () => _sendSMS(context, "+11122333444"),
            ),
          ],
        ),
      ),
    );
  }

  // --- Contact Card ---
  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
