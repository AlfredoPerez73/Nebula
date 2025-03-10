import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nebula/src/provider/login.provider.dart';
import 'package:nebula/src/services/local_storage.services.dart';
import 'package:nebula/src/services/push_notification.services.dart';
import 'package:nebula/src/utils/show_snackbar.dart';
import 'package:nebula/src/views/home.dart';
import 'package:provider/provider.dart';
import '../pages/frm_registro_primario.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  static String? token;

  @override
  void initState() {
    super.initState();
    token = PushNotificationServices.token;
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onFormLogin(String usernameOrEmail, String password, context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    final String usernameOrEmailLower = usernameOrEmail.toLowerCase();
    await loginProvider.loginUser(
        usernameOrEmail: usernameOrEmailLower,
        password: password,
        token: token!,
        onSuccess: () async {
          //verificar si el usuario verifico su email
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null && user.emailVerified) {
            //cambiar despues
            dynamic userData = await loginProvider.getUserData(user.email!);
            await LocalStorage().saveUserData(
                _usernameOrEmailController.text, _passwordController.text);
            await LocalStorage().setIsSignedIn(true);
            loginProvider.checkAuthState();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomeScreen(
                userData: userData,
              );
            }));
          } else {}
        },
        onError: (error) {
          showSnackbar(context, error);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF242038),
              Color(0xFF9067C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo y título
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF242038),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Color(0xFFF7ECE1),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "NEBULA",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Apartir de Inteligencia artificial desarollamos tus entrenamientos en base a objetivos personales",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFCAC4CE),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Campos de texto
                      _buildTextField(
                        controller: _usernameOrEmailController,
                        label: "Username o Email",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _passwordController,
                        label: "Password",
                        isPassword: true,
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 25),

                      // Botón de login
                      ElevatedButton(
                        onPressed: () {
                          onFormLogin(_usernameOrEmailController.text,
                              _passwordController.text, context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: const Color(0xFF9067C6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Separador
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFCAC4CE).withOpacity(0.3),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "or",
                              style: TextStyle(
                                color: Color(0xFFCAC4CE),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFCAC4CE).withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botón de registro
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterPrimaryPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: const Color(0xFFF7ECE1),
                        ),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: const TextStyle(color: Color(0xFFF7ECE1)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: const Color(0xFFCAC4CE).withOpacity(0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF8D86C9),
            size: 20,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF8D86C9),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    );
  }
}
