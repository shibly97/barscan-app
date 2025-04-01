import 'package:flutter/material.dart';

import 'ingredients.dart';
import 'review.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedRating = 0; // Stores the selected rating
  TextEditingController reviewController = TextEditingController(); // Review input controller

  void submitReview() {
    if (selectedRating == 0 || reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and a review")),
      );
      return;
    }

    // Handle submission (e.g., API call or local storage)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Review Submitted: $selectedRating stars - ${reviewController.text}")),
    );

    // Reset the review form
    setState(() {
      selectedRating = 0;
      reviewController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Category & Company Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Chip(label: Text("Shampoo")),
                  TextButton(
                    onPressed: () {
                      // Navigate to company details
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text("Viana Cosmetics"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Warning Message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "⚠️ Warning! Avoidant Ingredient Found",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 15),

              // Product Image
              Image.asset(widget.productData["image"], width: 150, height: 150),

              const SizedBox(height: 10),

              // Product Name
              Text(
                widget.productData["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 10),

              // Product Description
              const Text(
                "Alfaparf Milano offers moisturizing shampoos designed to hydrate and nourish dry hair. One of the key products is the Nutritive Low Shampoo, a gentle cleanser that nourishes the hair fiber while leaving it soft and shiny.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 25),

              // Product Rating Section
              const Text("Product Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              // Circular Rating Indicator
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 8 / 10, // Example rating
                      color: Colors.orange,
                      backgroundColor: Colors.grey.shade300,
                      strokeWidth: 6,
                    ),
                    const Center(
                      child: Text("8", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // View Reviews Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Reviews Page
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewsPage(
                          // productData: item,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Reviews", style: TextStyle(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 10),

              // View Ingredients Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Ingredients Page
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IngredientsScreen(
                          // productData: item,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("View Ingredients", style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 25),

              // Rate Product Section
              const Text("Rate Product", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

              const SizedBox(height: 5),

              // Star Rating Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < selectedRating ? Colors.orange : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),

              const SizedBox(height: 10),

              // Review Input Field
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(height: 10),

              // Submit Review Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Submit Review", style: TextStyle(color: Colors.black)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
