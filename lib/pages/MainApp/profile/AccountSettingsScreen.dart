import 'package:barscan/Utils/store/customer_session.dart';
import 'package:barscan/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barscan/Utils/API/API.dart';
import 'dart:convert';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  int? customerId;

  @override
  void initState() {
    super.initState();
    loadCustomerId();
  }

  Future<void> loadCustomerId() async {
    final id = await CustomerSession.getCustomerId();
    setState(() {
      customerId = int.tryParse(id ?? '');
    });
  }

  Future<void> inactivateAccount() async {
    if (customerId == null) return;

    try {
      final response = await http.put(
        Uri.parse('$inactivateAccountPost/$customerId/inactivate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        await CustomerSession.clear(); // Clear session
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account inactivated.')),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to inactivate account')),
        );
      }
    } catch (e) {
      debugPrint('Error inactivating account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong.')),
      );
    }
  }

  void _confirmInactivate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Inactivate Account"),
          content: const Text("Are you sure you want to inactivate your account?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                inactivateAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Yes, Inactivate"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.red),
            title: const Text(
              "Inactivate Account",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: _confirmInactivate,
          ),
          const Divider(),
          // In future you can add more settings options here like:
          // ListTile(
          //   leading: Icon(Icons.lock),
          //   title: Text("Change Password"),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}
