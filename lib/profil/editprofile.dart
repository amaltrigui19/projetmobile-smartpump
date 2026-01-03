import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color customGreen = Color(0xFF4A6B3E);
const Color bgColor = Color(0xFFF7F8F4);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 1. Controllers to handle data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  // 2. Fetch current user data from Firestore
  Future<void> _loadCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc.data()?['name'] ?? '';
          _phoneController.text = doc.data()?['phone'] ?? '';
        });
      }
    }
  }

  // 3. Save updated data to Firestore
  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      _showSnackBar("Le nom et le téléphone sont requis.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update Firestore Info
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': name,
          'phone': phone,
        });

        // Optional: Update Password if fields are not empty
        if (password.isNotEmpty) {
          if (password == confirmPassword) {
            await user.updatePassword(password);
          } else {
            _showSnackBar("Les mots de passe ne correspondent pas.");
            setState(() => _isLoading = false);
            return;
          }
        }

        if (mounted) {
          _showSnackBar("Profil mis à jour !");
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showSnackBar("Erreur : ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: customGreen),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Modifier Profil",
          style: TextStyle(color: customGreen, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: customGreen),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: customGreen))
        : SingleChildScrollView(
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
                  onPressed: () { /* Future: Image Picker logic */ },
                  icon: const Icon(Icons.image, color: customGreen),
                  label: const Text("Changer la photo", style: TextStyle(color: customGreen)),
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
                        controller: _nameController, // Added controller
                        label: "Nom",
                        hint: "Votre nom complet",
                        iconLeft: Icons.person,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: _phoneController, // Added controller
                        label: "Numéro de téléphone",
                        hint: "Ex : 22553322",
                        iconLeft: Icons.phone,
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: _passwordController, // Added controller
                        label: "Nouveau Mot de passe",
                        iconLeft: Icons.lock,
                        isPassword: !_showPassword,
                        iconRight: _showPassword ? Icons.visibility : Icons.visibility_off,
                        onIconRightPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: _confirmPasswordController, // Added controller
                        label: "Confirmer le mot de passe",
                        iconLeft: Icons.lock,
                        isPassword: !_showConfirmPassword,
                        iconRight: _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        onIconRightPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// ===== SAVE BUTTON =====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleSave, // Linked to save logic
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Enregistrer",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
/// CUSTOM TEXT FIELD (Updated with Controller)
/// =====================
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? iconLeft;
  final IconData? iconRight;
  final bool isPassword;
  final VoidCallback? onIconRightPressed;
  final TextEditingController? controller; // Added parameter

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.iconLeft,
    this.iconRight,
    this.isPassword = false,
    this.onIconRightPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Linked controller
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: customGreen),
        prefixIcon: iconLeft != null ? Icon(iconLeft, color: customGreen) : null,
        suffixIcon: iconRight != null
            ? IconButton(icon: Icon(iconRight, color: customGreen), onPressed: onIconRightPressed)
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