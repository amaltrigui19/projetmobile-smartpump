// forgot_password_page.dart

import 'package:flutter/material.dart';
import 'verifcodepage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  static const Color primaryGreen = Color(0xFF3E6B3E);
  static const Color borderGreen = Color(0xFF9CBF93);
  static const Color lightGrey = Color(0xFF98AB94);

  @override
  void dispose() {
    _phoneController.dispose();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    

                    // Title
                    Center(
                      child: Text(
                        'Mot de passe oublié',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: primaryGreen,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Center(
                      child: Text(
                        'Réinitialisez votre mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          color: lightGrey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Avatar - AJOUTÉ ICI
                    Center(
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Phone Input
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: borderGreen, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                                hintText: 'numéro de téléphone',
                                hintStyle: TextStyle(color: lightGrey, fontSize: 16),
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                  child: Icon(Icons.phone, color: Color(0xFF7F9B7F), size: 20),
                                ),
                                prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Send Code Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _sendVerificationCode();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Envoyer le code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

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
                  'assets/images/image 20.png',
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

  void _sendVerificationCode() {
    final phoneNumber = _phoneController.text.trim();
    
    if (phoneNumber.isEmpty) {
      _showSnackBar('Veuillez entrer votre numéro de téléphone');
      return;
    }

    // TODO: Implement actual API call to send verification code
    print('Envoi du code de vérification au: $phoneNumber');
    
   
    
    // Navigate to verification code page
     Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationCodePage(phoneNumber: phoneNumber)));
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