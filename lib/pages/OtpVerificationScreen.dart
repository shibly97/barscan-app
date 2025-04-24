import 'package:barscan/Utils/API/API.dart';
import 'package:barscan/Utils/store/customer_session.dart';
import 'package:barscan/pages/Main_App.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerificationScreen extends StatefulWidget {
  final int userId;

  const OtpVerificationScreen({super.key, required this.userId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _loading = false;

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse(verifyOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': widget.userId,
          'otp': _otpController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      setState(() => _loading = false);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified!')),
        );

        // Navigator.pushReplacementNamed(context, '/dashboard');
        // Navigator.push(
        // context,
        // MaterialPageRoute(
        //   builder: (context) => OtpVerificationScreen(userId: data['id']),
        // ),
        //  MaterialPageRoute(builder: (context) => const MainApp()),
      // );
      print(data['id'].toString());
      print(data['email']);
 await CustomerSession.saveSession(data['id'].toString(), data['email']);	
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MainApp()),
  );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Invalid OTP')),
        );
      }
    } catch (e) {
      print(e);
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Please enter the OTP sent to your email."),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'OTP is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text("Verify OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
