import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _usernameController = TextEditingController(text: "millenin");
  final TextEditingController _dobController = TextEditingController(text: "12/12/2000");
  final TextEditingController _mobileController = TextEditingController(text: "07485296315");

  List<String> allIngredients = ["Water", "Chloride", "Sulphate", "Paraben", "Alcohol", "Fragrance"];
  List<String> selectedIngredients = ["Water", "Chloride", "Sulphate"];

  void _addIngredient(String ingredient) {
    if (!selectedIngredients.contains(ingredient)) {
      setState(() {
        selectedIngredients.add(ingredient);
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      selectedIngredients.remove(ingredient);
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
      body: SingleChildScrollView( // ✅ Fix overflow issue when keyboard opens
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Username*", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _usernameController, decoration: _inputDecoration()),

            const SizedBox(height: 15),
            const Text("Date of Birth*", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _dobController, decoration: _inputDecoration()),

            const SizedBox(height: 15),
            const Text("Mobile Number", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _mobileController, decoration: _inputDecoration()),

            const SizedBox(height: 25),

             const Text("Avoid Ingredients", style: TextStyle(fontWeight: FontWeight.bold)),

             const SizedBox(height: 15),

            
            // ✅ Smaller dropdown
            DropdownButtonFormField<String>(
              value: allIngredients.isNotEmpty ? allIngredients.first : null,
              items: allIngredients.map((String ingredient) {
                return DropdownMenuItem<String>(
                  value: ingredient,
                  child: Text(ingredient, style: const TextStyle(fontSize: 14)), // Smaller text
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _addIngredient(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Smaller padding
              ),
            ),

            const SizedBox(height: 10),
            // ✅ Selected ingredients list
            ListView.builder(
              shrinkWrap: true, // Prevents infinite height issues
              physics: const NeverScrollableScrollPhysics(), // Disables scrolling inside ListView
              itemCount: selectedIngredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedIngredients[index], style: const TextStyle(fontSize: 14)),
                  trailing: TextButton(
                    onPressed: () => _removeIngredient(selectedIngredients[index]),
                    child: const Text("Remove", style: TextStyle(color: Colors.red)),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile Updated Successfully")),
                );
              },
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // ✅ Smaller padding
    );
  }
}
