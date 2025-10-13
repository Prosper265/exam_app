import 'package:exam_app/screens/regisster_screen.dart';
import 'package:exam_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Login function
  void login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _regNumberController.text.trim();
    String password = _phoneController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill all fields');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String? error = await AuthService().signIn(email, password);

    setState(() {
      _isLoading = false;
    });

    if (error == null) {
      // Success - Firebase auth state will handle navigation automatically
    } else {
      _showMessage(error);
    }
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 255, 51, 0),
        content: Text(
        message
      )),
    );
  }

  @override
  void dispose() {
    _regNumberController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              
              // Logo/Header
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Color.fromARGB(223, 94, 93, 92),
              ),
              const SizedBox(height: 20),
              const Text(
                'My Recipe Book',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 247, 127, 16),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Registration Number Field
              TextField(
                controller: _regNumberController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromARGB(224, 247, 121, 4),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Password Field
              TextField(
                controller: _phoneController,
                obscureText: !_isPasswordVisible,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color.fromARGB(224, 247, 121, 4),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(224, 247, 121, 4),
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              _isLoading 
                ? const CircularProgressIndicator(strokeWidth: 2)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 247, 127, 16),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ), 
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Navigate to Register
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 247, 127, 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Help Text
              Text(
                'Use your registration number as username\nand phone number as password',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}