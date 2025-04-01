import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                    Image.asset("images/barcode_logo.png", height: 80), // Update with actual logo
                    const SizedBox(height: 10),
                    const Text(
                      "BarScan",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const Text(
                      "Because we care about you",
                      style: TextStyle(fontSize: 14, color: Colors.redAccent),
                    ),
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
              _buildRiskIndicator("Safe", Colors.green, Icons.check_circle),
              _buildRiskIndicator("Caution Advised", Colors.orange, Icons.warning),
              _buildRiskIndicator("Risky", Colors.red, Icons.cancel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskIndicator(String label, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}
