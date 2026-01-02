import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color customGreen = Color(0xFF4A6B3E);
const Color bgColor = Color(0xFFF7F8F4);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Modifier Profil",
          style: TextStyle(
            color: customGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: customGreen),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.5,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ===== AVATAR =====
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: customGreen,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.image, color: customGreen),
              label: const Text(
                "Changer la photo",
                style: TextStyle(color: customGreen),
              ),
            ),

            const SizedBox(height: 25),

            /// ===== FORM CARD =====
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomTextField(
                    label: "Nom",
                    hint: "Votre nom complet",
                    iconLeft: Icons.person,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "Numéro de téléphone",
                    hint: "Ex : 22553322",
                    iconLeft: Icons.phone,
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "Mot de passe",
                    iconLeft: Icons.lock,
                    isPassword: !_showPassword,
                    iconRight: _showPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onIconRightPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  CustomTextField(
                    label: "Confirmer le mot de passe",
                    iconLeft: Icons.lock,
                    isPassword: !_showConfirmPassword,
                    iconRight: _showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onIconRightPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ===== SAVE BUTTON =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Retourner à la page Mon profile
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Enregistrer",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: customGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// CUSTOM TEXT FIELD
/// =====================
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? iconLeft;
  final IconData? iconRight;
  final bool isPassword;
  final VoidCallback? onIconRightPressed;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.iconLeft,
    this.iconRight,
    this.isPassword = false,
    this.onIconRightPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: customGreen),
        prefixIcon:
            iconLeft != null ? Icon(iconLeft, color: customGreen) : null,
        suffixIcon: iconRight != null
            ? IconButton(
                icon: Icon(iconRight, color: customGreen),
                onPressed: onIconRightPressed,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF7F8F4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: customGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: customGreen, width: 2),
        ),
      ),
    );
  }
}