import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../l10n/app_localizations.dart';

class ChoisirLanguePage extends StatefulWidget {
  const ChoisirLanguePage({super.key});

  @override
  State<ChoisirLanguePage> createState() => _ChoisirLanguePageState();
}

class _ChoisirLanguePageState extends State<ChoisirLanguePage> {
  static const Color darkGreen = Color(0xFF4A5D3F);
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language');
    });
  }

  Future<void> _selectLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
    
    setState(() {
      _selectedLanguage = language;
    });

    // Change the app locale
    final appState = MyApp.of(context);
    if (appState != null) {
      Locale newLocale;
      switch (language.toLowerCase()) {
        case 'english':
          newLocale = const Locale('en', 'US');
          break;
        case 'français':
          newLocale = const Locale('fr', 'FR');
          break;
        case 'arabe':
          newLocale = const Locale('ar', 'AR');
          break;
        default:
          newLocale = const Locale('fr', 'FR');
      }
      appState.setLocale(newLocale);
    }

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.languageChanged}: $language'),
          backgroundColor: darkGreen,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Don't pop - let user see the change immediately
      // The locale change will rebuild the widgets
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Text(
              l10n.chooseLanguageTitle,
              style: const TextStyle(fontSize: 30, color: Color(0xFF1E3606), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _langButton(context, "Français"),
                const SizedBox(width: 40),
                _langButton(context, "Arabe"),
              ],
            ),
            const SizedBox(height: 30),
            _langButton(context, "English"),
            if (_selectedLanguage != null) ...[
              const SizedBox(height: 30),
              Text(
                'Langue actuelle: $_selectedLanguage',
                style: const TextStyle(color: darkGreen, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _langButton(BuildContext context, String label) {
    final isSelected = _selectedLanguage == label;
    return SizedBox(
      width: 130,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green.shade700 : darkGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () => _selectLanguage(label),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}