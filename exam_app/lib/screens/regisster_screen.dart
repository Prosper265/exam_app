import 'package:exam_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmPhoneController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Sign up function
  void signUp() async {
    setState(() {
      _isLoading = true;
    });

    String regNumber = _regNumberController.text.trim();
    String phone = _phoneController.text.trim();
    String confirmPhone = _confirmPhoneController.text.trim();

    if (regNumber.isEmpty || phone.isEmpty || confirmPhone.isEmpty) {
      _showMessage('Please fill all fields');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (phone != confirmPhone) {
      _showMessage('Phone numbers do not match');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String? error = await AuthService().signUp(regNumber, phone);

    setState(() {
      _isLoading = false;
    });

    if (error == null) {
      _showMessage('Account created successfully!');
      Navigator.pop(context); // Navigate back to login screen
    }
    else {
      _showMessage(error);
    }
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Toggle confirm password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 255, 166, 0),
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _regNumberController.dispose();
    _phoneController.dispose();
    _confirmPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo/Header
              const Icon(
                Icons.person_add_outlined,
                size: 80,
                color: Color.fromARGB(223, 94, 93, 92),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Account',
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
                  labelText: 'Registration Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromARGB(224, 247, 121, 4),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Phone Number Field
              TextField(
                controller: _phoneController,
                obscureText: !_isPasswordVisible,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.phone,
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
              
              const SizedBox(height: 20),
              
              // Confirm Phone Number Field
              TextField(
                controller: _confirmPhoneController,
                obscureText: !_isConfirmPasswordVisible,
                keyboardType: TextInputType.phone,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Confirm Phone Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Color.fromARGB(224, 247, 121, 4),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(224, 247, 121, 4),
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              _isLoading 
                ? const CircularProgressIndicator(strokeWidth: 2)
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 247, 127, 16),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ), 
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              
              const Spacer(),
              
              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 247, 127, 16),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Help Text
              Text(
                'Your phone number will be used as your password',
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