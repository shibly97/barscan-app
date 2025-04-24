import 'dart:convert';
import 'package:barscan/Utils/store/customer_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barscan/Utils/API/API.dart';
import 'ingredients.dart';
import 'review.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  int selectedRating = 0;
  bool hasUserReviewed = false;
  TextEditingController reviewController = TextEditingController();
  int? customerId;

  Future<void> fetchProductDetails() async {
    final id = await CustomerSession.getCustomerId();
    setState(() => customerId = int.tryParse(id ?? '0'));

    final response = await http.get(Uri.parse("$getProductDetailsById/${widget.productId}/details?customer_id=${customerId}"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        product = data;
        if (data['userReview'] != null) {
          selectedRating = data['userReview']['rating'];
          reviewController.text = data['userReview']['review'];
          hasUserReviewed = true;
        }
      });
    }
  }

  Future<void> submitReview() async {
    if (selectedRating == 0 || reviewController.text.isEmpty || customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a rating and a review.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$addProductReview/${widget.productId}/review"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer_id': customerId,
          'rating': selectedRating,
          'review': reviewController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review submitted successfully.")),
        );
        fetchProductDetails();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to submit review.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Product Details"),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final rating = double.tryParse(product!["averageRating"].toString()) ?? 0.0;
    final hasWarning = product!["hasDangerousIngredient"] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(product!["category_name"] ?? "Category")),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Text(product!["company_name"] ?? "Company"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (hasWarning)
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
            Image.network(product!["image"], width: 150, height: 150),
            const SizedBox(height: 10),
            Text(
              product!["name"],
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              product!["description"] ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 25),
            const Text("Product Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: rating / 5,
                    color: Colors.orange,
                    backgroundColor: Colors.grey.shade300,
                    strokeWidth: 6,
                  ),
                  Center(
                    child: Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("View Reviews", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const IngredientsScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text("View Ingredients", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            const Text("Your Review", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(Icons.star, color: index < selectedRating ? Colors.orange : Colors.grey),
                  onPressed: () => setState(() => selectedRating = index + 1),
                );
              }),
            ),
            TextField(
              controller: reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitReview,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Submit Review", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
