import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const Color primaryGreen = Color(0xFF3E6B3E);
  static const Color borderGreen = Color(0xFF9CBF93);
  static const Color lightGrey = Color(0xFF98AB94);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Les mots de passe ne correspondent pas');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create User in Auth (Using phone + dummy domain as email for Firebase Auth)
      // Alternatively, you could add an Email field to your UI.
      final userEmail = "$phone@smartsolar.com"; 
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: password,
      );

      // 2. Save Profile in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSnackBar('Compte créé avec succès!');
      if (mounted) Navigator.pop(context); // Go back to login

    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? 'Erreur d\'authentification');
    } catch (e) {
      _showSnackBar('Erreur: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: primaryGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text('Inscription', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: primaryGreen)),
                    const SizedBox(height: 40),
                    _buildInputFieldWithIcon(controller: _nameController, hintText: 'Nom', icon: Icons.person),
                    const SizedBox(height: 16),
                    _buildInputFieldWithIcon(controller: _phoneController, hintText: 'Numéro de téléphone', icon: Icons.phone, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildInputFieldWithIcon(
                      controller: _passwordController, 
                      hintText: 'Mot de passe', 
                      icon: Icons.lock, 
                      isPassword: true, 
                      obscure: _obscurePassword,
                      onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 16),
                    _buildInputFieldWithIcon(
                      controller: _confirmPasswordController, 
                      hintText: 'Confirmer mot de passe', 
                      icon: Icons.lock, 
                      isPassword: true, 
                      obscure: _obscureConfirmPassword,
                      onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Créer un compte', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tu as déjà un compte ? ', style: TextStyle(color: Colors.black54)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Connectez vous', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.1),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: IgnorePointer(child: Image.asset('assets/images/image 19.png', width: size.width, fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFieldWithIcon({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderGreen, width: 2),
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Icon(icon, color: const Color(0xFF7F9B7F), size: 20)),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword ? obscure : false,
              keyboardType: keyboardType,
              decoration: InputDecoration(hintText: hintText, border: InputBorder.none, hintStyle: const TextStyle(color: lightGrey)),
            ),
          ),
          if (isPassword)
            IconButton(onPressed: onToggleObscure, icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF7F9B7F))),
        ],
      ),
    );
  }
}