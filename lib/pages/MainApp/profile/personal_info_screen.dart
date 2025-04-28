import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barscan/Utils/API/API.dart';
import 'package:http/http.dart' as http;
import 'package:barscan/Utils/store/customer_session.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  List<dynamic> allIngredients = [];
  List<int> selectedIngredientIds = [];
  int? customerId;

  @override
  void initState() {
    super.initState();
    loadCustomerData();
  }

  Future<void> loadCustomerData() async {
    final id = await CustomerSession.getCustomerId();
    customerId = int.tryParse(id ?? '');

    if (customerId != null) {
      final profileResponse = await http.get(Uri.parse('$customerProfile/$customerId'));
      final ingredientsResponse = await http.get(Uri.parse('$getAllIngredient'));

      if (profileResponse.statusCode == 200 && ingredientsResponse.statusCode == 200) {
        final profileData = jsonDecode(profileResponse.body);
        final ingredientsData = jsonDecode(ingredientsResponse.body);

        setState(() {
          _usernameController.text = profileData['customer']['user_name'] ?? '';
          _dobController.text = (profileData['customer']['date_of_birth'] ?? '').toString().split('T')[0];
          _mobileController.text = profileData['customer']['contact'] ?? '';
          selectedIngredientIds = List<int>.from(profileData['avoidedIngredients']);
          allIngredients = ingredientsData;
        });
      }
    }
  }

  Future<void> updateProfile() async {
    if (customerId == null) return;

    try {
      // Update personal info
      await http.put(
        Uri.parse('$customerProfile/$customerId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_name": _usernameController.text.trim(),
          "contact": _mobileController.text.trim(),
          "date_of_birth": _dobController.text.trim(),
        }),
      );

      // Update avoid ingredients
      await http.put(
        Uri.parse('$customerProfile/$customerId/avoid-ingredients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ingredientIds": selectedIngredientIds,
        }),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile.')),
      );
    }
  }

void toggleIngredient(int ingredientId) {
  setState(() {
    if (selectedIngredientIds.contains(ingredientId)) {
      selectedIngredientIds.remove(ingredientId);
    } else {
      selectedIngredientIds.add(ingredientId);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Info", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Username*", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _usernameController, decoration: _inputDecoration()),

            const SizedBox(height: 15),
            const Text("Date of Birth*", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
  controller: _dobController,
  readOnly: true, // user can't type manually
  decoration: _inputDecoration().copyWith(
    hintText: 'Select Date of Birth',
    suffixIcon: const Icon(Icons.calendar_today),
  ),
  onTap: () async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  },
),


            const SizedBox(height: 15),
            const Text("Mobile Number", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _mobileController, decoration: _inputDecoration()),

            const SizedBox(height: 25),
            const Text("Avoid Ingredients", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: allIngredients.map((ingredient) {
                final ingredientId = int.tryParse(ingredient['id'].toString()) ?? 0; // 👈 here
                final isSelected = selectedIngredientIds.contains(ingredient['id']);
                return FilterChip(
                  label: Text(ingredient['name']),
                  selected: isSelected,
                  onSelected: (_) => toggleIngredient(ingredient['id']),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("UPDATE"),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }
}
