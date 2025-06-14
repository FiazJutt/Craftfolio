import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signuppage.dart';
import '../../core/services/auth_service.dart';
import '../homepage/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  // Form field controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A237E).withOpacity(0.9),
              const Color(0xFF0D47A1),
              const Color(0xFF1565C0).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(top: -50, right: -50, child: _decorativeCircle(150)),
              Positioned(bottom: -80, left: -80, child: _decorativeCircle(200)),
              Positioned(top: 100, left: -30, child: _decorativeCircle(80)),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildLoginForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLogo(),
            const SizedBox(height: 24),
            const Text(
              "Craftfolio",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Welcome back",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 28),
            _CustomTextField(
              controller: _emailController,
              hintText: "Email address",
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _CustomTextField(
              controller: _passwordController,
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    _handleForgotPassword();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter your email address')),
                    );
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleUserSignIn,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF1A237E),
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.black26,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLoading ? "Loading..." : "Sign In",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'app_logo',
      child: Container(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          radius: 62,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage("assets/CF_Logo.png"),
        ),
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
    );
  }


  /// Function to handle user sign-in
  Future<void> _handleUserSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Homepage()),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Function to handle forgot password
  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email address")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.resetPassword(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password reset email sent. Please check your inbox.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  const _CustomTextField({
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(prefixIcon, color: Colors.white70, size: 20),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}
