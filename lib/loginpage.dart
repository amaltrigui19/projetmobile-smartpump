// login_page.dart

import 'package:flutter/material.dart';
import 'passwordoublie.dart';
import 'inscription.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    const Color primaryGreen = Color(0xFF3E6B3E);
    const Color borderGreen = Color(0xFF9CBF93); 

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content column
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height - MediaQuery.of(context).padding.vertical),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),

                      // Title
                      Center(
                        child: Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: primaryGreen,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Avatar
                      Center(
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Form area
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildRoundedInput(
                              controller: _phoneController,
                              hintText: 'numéro de téléphone',
                              prefix: Icons.phone,
                              borderColor: borderGreen,
                            ),

                            const SizedBox(height: 14),

                            _buildRoundedInput(
                              controller: _passwordController,
                              hintText: 'mot de passe',
                              prefix: Icons.lock,
                              borderColor: borderGreen,
                              isPassword: true,
                              obscure: _obscure,
                              onToggleObscure: () => setState(() => _obscure = !_obscure),
                            ),

                            // Mot de passe oublié align right
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 24),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'mot de passe oublié ?',
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Connect button
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: implement login action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Se connecter',
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Sign up row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Tu n\'as pas un compte ? ', style: TextStyle(color: Colors.black54)),
                                GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                                );
                                  },
                                  child: Text(
                                    'créer un compte',
                                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),

                          
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),


                      SizedBox(height: size.height *0.15),  
                    ],
                  ),
                ),
              ),
            ),

            
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/image 20.png',
                  fit: BoxFit.fitWidth, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the rounded inputs
  Widget _buildRoundedInput({
    required TextEditingController controller,
    required String hintText,
    required IconData prefix,
    required Color borderColor,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword ? obscure : false,
              keyboardType: isPassword ? TextInputType.text : TextInputType.phone,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                hintText: hintText,
                hintStyle: TextStyle(color: Color(0xFF98AB94)),
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: Icon(prefix, color: Color(0xFF7F9B7F)),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
              ),
            ),
          ),

          if (isPassword)
            InkWell(
              onTap: onToggleObscure,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  obscure ? Icons.visibility_off : Icons.remove_red_eye,
                  color: Color(0xFF7F9B7F),
                ),
              ),
            ),
        ],
      ),
    );
  }
}