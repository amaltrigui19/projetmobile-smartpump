import 'package:flutter/material.dart';
import 'details/passwordoublie.dart';
import 'details/inscription.dart';
import 'nav.dart';

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
    const Color primaryGreen = Color(0xFF3E6B3E);
    const Color borderGreen = Color(0xFF9CBF93);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ===== TITRE =====
              Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: primaryGreen,
                ),
              ),

              const SizedBox(height: 18),

              // ===== AVATAR =====
              const CircleAvatar(
                radius: 44,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),

              const SizedBox(height: 26),

              // ===== FORMULAIRE =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
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
                      onToggleObscure: () =>
                          setState(() => _obscure = !_obscure),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'mot de passe oublié ?',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ===== BOUTON =====
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeShell(),
                                  
                              ),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tu n\'as pas un compte ? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            'créer un compte',
                            style: TextStyle(
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ===== IMAGE BAS (NON COUPÉE) =====
              Image.asset(
                'assets/images/image 20.png',
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== INPUT ARRONDI =====
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
              keyboardType:
                  isPassword ? TextInputType.text : TextInputType.phone,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18),
                hintText: hintText,
                border: InputBorder.none,
                prefixIcon:
                    Icon(prefix, color: const Color(0xFF7F9B7F)),
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off
                    : Icons.remove_red_eye,
                color: const Color(0xFF7F9B7F),
              ),
              onPressed: onToggleObscure,
            ),
        ],
      ),
    );
  }
}
