import 'dart:convert';
import 'package:barscan/Utils/constants.dart';
import 'package:barscan/Utils/store/customer_session.dart';
import 'package:barscan/Utils/API/API.dart';
import 'package:barscan/pages/MainApp/product/product_details.dart';
import 'package:barscan/pages/MainApp/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> recommendedProducts = [];
  List<dynamic> brandBasedProducts = [];
  List<dynamic> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final customerId = await CustomerSession.getCustomerId();
    if (customerId == null) return;

    try {
      final recommendedResponse = await http.get(Uri.parse('$getProductRecommendations/$customerId'));
      final brandBasedResponse = await http.get(Uri.parse('$getProductRecommendationsByBrand/$customerId'));
      final articlesResponse = await http.get(Uri.parse('$getArticles'));

      if (recommendedResponse.statusCode == 200 &&
          brandBasedResponse.statusCode == 200 &&
          articlesResponse.statusCode == 200) {
        setState(() {
          recommendedProducts = jsonDecode(recommendedResponse.body);
          brandBasedProducts = jsonDecode(brandBasedResponse.body);
          articles = jsonDecode(articlesResponse.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading home data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BarScan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchScreen(initialSearchText: value)),
                        );
                      }
                    },
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
                    child: recommendedProducts.isEmpty
                        ? const Center(child: Text("No recommendations found."))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedProducts.length,
                            itemBuilder: (context, index) {
                              final product = recommendedProducts[index];
                              return _buildProductCard(
                                product['name'],
                                '$baseUrl/uploads/${product['image']}',
                                "${product['averageRating']} ⭐",
                                productId: product['id'],
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),

                  // More from Brands
                  const Text("Top rated", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: brandBasedProducts.isEmpty
                        ? const Center(child: Text("No brand-based recommendations found."))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: brandBasedProducts.length,
                            itemBuilder: (context, index) {
                              final product = brandBasedProducts[index];
                              return _buildProductCard(
                                product['name'],
                                '$baseUrl/uploads/${product['image']}',
                                "${product['averageRating']} ⭐",
                                productId: product['id'],
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Skincare Insights
                  const Text("Skincare Insights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  articles.isEmpty
                      ? const Center(child: Text("No articles found."))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return _buildArticleTile(
                              article['title'] ?? '',
                              '$baseUrl/uploads/${article['image_path']}',
                              article['url'] ?? '',
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildProductCard(String title, String image, String rating, {required int productId}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: productId)),
        );
      },
      child: Container(
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
            Image.network(image, height: 60, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(rating, style: const TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleTile(String title, String image, String url) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Image.network(image, width: 80, height: 80, fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        final articleUrl = Uri.parse(url);
        if (await canLaunchUrl(articleUrl)) {
          await launchUrl(articleUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open article link")),
          );
        }
      },
    );
  }
}
