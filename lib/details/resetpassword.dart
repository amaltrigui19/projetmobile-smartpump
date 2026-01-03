// reset_password_page.dart

import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String phoneNumber;
  
  const ResetPasswordPage({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  static const Color primaryGreen = Color(0xFF3E6B3E);
  static const Color borderGreen = Color(0xFF9CBF93);
  static const Color lightGrey = Color(0xFF98AB94);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              child: Container(
                height: size.height,
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      'Nouveau mot de passe',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: primaryGreen,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Créez un nouveau mot de passe sécurisé',
                      style: TextStyle(
                        fontSize: 16,
                        color: lightGrey,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // New Password Input
                    _buildPasswordField(
                      controller: _newPasswordController,
                      hintText: 'Nouveau mot de passe',
                      obscure: _obscureNewPassword,
                      onToggleObscure: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password Input
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirmer le nouveau mot de passe',
                      obscure: _obscureConfirmPassword,
                      onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),


                    const SizedBox(height: 35),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _resetPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Enregistrer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),
                    SizedBox(height: size.height * 0.15),
                  ],
                ),
              ),
            ),

            // Bottom decorative image
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/image 21.png',
                  fit: BoxFit.fitWidth,
                  width: size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Password field widget
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscure,
    required VoidCallback onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderGreen, width: 2),
      ),
      child: Row(
        children: [
          // Lock icon
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 12.0),
            child: Icon(
              Icons.lock,
              color: Color(0xFF7F9B7F),
              size: 20,
            ),
          ),

          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 8,
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: lightGrey, fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),

          // Eye icon to show/hide password
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFF7F9B7F),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword() {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (newPassword.isEmpty) {
      _showSnackBar('Veuillez entrer le nouveau mot de passe');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showSnackBar('Veuillez confirmer le nouveau mot de passe');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('Les mots de passe ne correspondent pas');
      return;
    }

    if (newPassword.length < 6) {
      _showSnackBar('Le mot de passe doit contenir au moins 6 caractères');
      return;
    }

    // TODO: Implement actual API call to reset password
    print('Réinitialisation du mot de passe pour: ${widget.phoneNumber}');
    print('Nouveau mot de passe: $newPassword');
    
    // Show success message
    _showSnackBar('Mot de passe réinitialisé avec succès!');
    
    // Navigate to login page
    _navigateToLogin();
  }

  void _navigateToLogin() {
    // Navigate to login page and remove all previous pages from stack
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/login', // Assurez-vous d'avoir une route nommée pour login
      (route) => false,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}