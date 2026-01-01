
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
const customGreen = Color(0xFF4A6B3E);
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Modifier Profile", style: TextStyle(color: customGreen)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: customGreen),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: customGreen,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.image, color: customGreen),
              label: const Text("Changer Photo", style: TextStyle(color: customGreen)),
            ),
            const SizedBox(height: 20),
            // Nom et téléphone à gauche
            CustomTextField(
              label: "Nom",
              iconLeft: Icons.person,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Numéro téléphone",
              iconLeft: Icons.phone,
            ),
            const SizedBox(height: 15),
            // Mot de passe
            CustomTextField(
              label: "Mot de passe",
              iconLeft: Icons.lock,
              isPassword: !_showPassword,
              iconRight: _showPassword ? Icons.visibility : Icons.visibility_off,
              onIconRightPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Confirmer mot de passe",
              iconLeft: Icons.lock,
              isPassword: !_showConfirmPassword,
              iconRight: _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
              onIconRightPressed: () {
                setState(() {
                  _showConfirmPassword = !_showConfirmPassword;
                });
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text("Enregistrer",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: customGreen,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Champ texte avec icône gauche et droite pour mot de passe
class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? iconLeft;
  final IconData? iconRight;
  final bool isPassword;
  final VoidCallback? onIconRightPressed;

  const CustomTextField({
    super.key,
    required this.label,
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
        labelStyle: const TextStyle(color: customGreen),
        prefixIcon: iconLeft != null ? Icon(iconLeft, color: customGreen) : null,
        suffixIcon: iconRight != null
            ? IconButton(
                icon: Icon(iconRight, color: customGreen),
                onPressed: onIconRightPressed,
              )
            : null,
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