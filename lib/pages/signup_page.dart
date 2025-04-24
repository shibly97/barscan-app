import 'package:barscan/Utils/API/API.dart';
import 'package:barscan/pages/OtpVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(signIn),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fistName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "userName": _userNameController.text.trim(),
          "email": _emailController.text.trim(),
          "contact": "0712345678",
          "zip": "10100",
          "password": _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              userId: data['id']
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Signup failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(label: "First Name", controller: _firstNameController),
                const SizedBox(height: 20),
                _buildInputField(label: "Last Name", controller: _lastNameController),
                const SizedBox(height: 20),
                _buildInputField(label: "Username", controller: _userNameController),
                const SizedBox(height: 20),
                _buildInputField(label: "Email", controller: _emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                _buildInputField(label: "Password", controller: _passwordController, obscureText: true),
                const SizedBox(height: 20),
                _buildInputField(label: "Confirm Password", controller: _confirmPasswordController, obscureText: true),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text("Sign Up"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) {
        if (value!.isEmpty) return "Please enter your $label";
        if (label == "Password" && value.length < 6) return "Password must be at least 6 characters";
        if (label == "Confirm Password" && value != _passwordController.text) return "Passwords do not match";
        return null;
      },
    );
  }
}
