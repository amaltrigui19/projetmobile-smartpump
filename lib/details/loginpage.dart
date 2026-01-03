import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'inscription.dart'; // Assurez-vous que le chemin est correct

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  static const Color primaryGreen = Color(0xFF3E6B3E);
  static const Color borderGreen = Color(0xFF9CBF93);
  static const Color lightGrey = Color(0xFF98AB94);

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Connexion avec l'email simulé (phone@smartsolar.com) comme défini dans l'inscription
      final userEmail = "$phone@smartsolar.com";
      
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: password,
      );

      // Si réussi, redirection vers le profil ou l'accueil
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/profile');
      }
      
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Erreur de connexion";
      if (e.code == 'user-not-found') errorMessage = "Utilisateur non trouvé";
      if (e.code == 'wrong-password') errorMessage = "Mot de passe incorrect";
      
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar("Erreur: $e");
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
                    const SizedBox(height: 60),
                    Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildInput(
                      controller: _phoneController,
                      hint: 'Numéro de téléphone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildInput(
                      controller: _passwordController,
                      hint: 'Mot de passe',
                      icon: Icons.lock,
                      isPassword: true,
                      obscure: _obscurePassword,
                      onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Se connecter', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Pas de compte ? "),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage())),
                          child: const Text(
                            "Inscrivez-vous",
                            style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderGreen, width: 2),
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Icon(icon, color: const Color(0xFF7F9B7F))),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword ? obscure : false,
              keyboardType: keyboardType,
              decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: const TextStyle(color: lightGrey)),
            ),
          ),
          if (isPassword)
            IconButton(onPressed: onToggle, icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF7F9B7F))),
        ],
      ),
    );
  }
}