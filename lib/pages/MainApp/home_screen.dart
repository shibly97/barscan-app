import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BarScan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search for a product or ingredient...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Recommended Products
            const Text("Recommended Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildProductCard("Hydrating Serum", "images/serum.jpg", "4.5 ⭐"),
                  _buildProductCard("Organic Moisturizer", "images/moisturizer.jpg", "4.8 ⭐"),
                  _buildProductCard("Vitamin C Cream", "images/vitamin_c.jpg", "4.7 ⭐"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Articles Section
            const Text("Skincare Insights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildArticleTile("5 Harmful Ingredients to Avoid", "images/article1.jpg"),
            _buildArticleTile("How to Read Ingredient Labels", "images/article2.png"),
            _buildArticleTile("Best Natural Alternatives", "images/article3.jpg"),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String title, String image, String rating) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 60),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text(rating, style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildArticleTile(String title, String image) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Navigate to article detail page
      },
    );
  }
}
