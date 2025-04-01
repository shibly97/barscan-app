import 'package:barscan/pages/MainApp/profile/about_screen.dart';
import 'package:barscan/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'profile/personal_info_screen.dart'; // Import the About screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Picture
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("images/mileni.jpg"), // Change this to the user's image
                ),
                const SizedBox(height: 10),

                // Email
                Text(
                  "millenin@gmail.com",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Menu Options
          _buildMenuItem("Personal Info", Icons.person, context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  PersonalInfoScreen()),
            );
          }),
          _buildMenuItem("Account Settings", Icons.settings, context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  PersonalInfoScreen()),
            );
          }),
          _buildMenuItem("About", Icons.info, context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  AboutScreen()),
            );
          }),
          _buildMenuItem("Log Out", Icons.logout, context, () {
            _showLogoutDialog(context);
          }, isLogout: true),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, BuildContext context, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement actual logout functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  LoginPage()),
            );
              },
              child: const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
