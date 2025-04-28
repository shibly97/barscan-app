import 'dart:convert';
import 'package:barscan/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barscan/Utils/API/API.dart'; // if you have your API urls here

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  List<dynamic> labels = [];

  @override
  void initState() {
    super.initState();
    fetchLabels();
  }

  Future<void> fetchLabels() async {
    try {
      final response = await http.get(Uri.parse('$getAllLabel'));
      if (response.statusCode == 200) {
        setState(() {
          labels = jsonDecode(response.body);
        });
      } else {
        debugPrint("Failed to load labels");
      }
    } catch (e) {
      debugPrint("Error fetching labels: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('images/barscan.png', height: 200),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "The Ingredient Scanner app helps users scan personal care product barcodes to identify toxic ingredients and assess their health impact. Our goal is to promote safe and informed choices for consumers.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                "How It Works",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text("• Step 1: Scan a product barcode or search for a product."),
              const Text("• Step 2: View ingredient details and risk levels."),
              const SizedBox(height: 20),
              const Text(
                "Risk Indications:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // 🔥 Here we dynamically load labels
              ...labels.map((label) => _buildRiskIndicator(label)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskIndicator(Map<String, dynamic> label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
           Image.network(
                     baseUrl +'/uploads/'+ (label!["image_path"] ?? ""),
                    height: 20,
                  ),
          const SizedBox(width: 10),
          Text(
            label['name'] ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
