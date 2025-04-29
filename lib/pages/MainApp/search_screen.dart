import 'dart:convert';
import 'package:barscan/Utils/API/API.dart';
import 'package:barscan/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product/product_details.dart';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SearchScreen extends StatefulWidget {
  final String? initialSearchText;
   const SearchScreen({super.key, this.initialSearchText});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Category> categories = [Category(id: 0, name: "All")];
  String selectedCategory = "All";
  TextEditingController searchController = TextEditingController();
  bool isTopRated = false; // Add this inside _SearchScreenState

  List<dynamic> filteredResults = [];

@override
void initState() {
  super.initState();
  fetchCategories();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    performSearch(); // 👈 Call search immediately after page opens
  });
}

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('$getCategoryByStatus/Active'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories.addAll(data.map((e) => Category.fromJson(e)).toList());
      });
    } else {
      debugPrint("Failed to load categories");
    }
  }

Future<void> performSearch() async {
  final query = searchController.text.trim();
  final category = selectedCategory;

  final categoryName = selectedCategory;

  String? categoryId;

  // Map selected category name to id
  if (categoryName != "All") {
    final selected = categories.firstWhere((c) => c.name == categoryName, orElse: () => Category(id: 0, name: "All"));
    categoryId = selected.id != 0 ? selected.id.toString() : null;
  }

  final uri = Uri.parse("$getProductSearch").replace(queryParameters: {
    'topRated': isTopRated.toString(), // 👈 Pass topRated
    if (category != "All") 'category_id': categoryId, 
    if (query.isNotEmpty) 'search': query,
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    setState(() {
      filteredResults = jsonDecode(response.body);
    });
  } else {
    debugPrint("Failed to fetch products");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category.name,
                            child: Text(category.name, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                          performSearch();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        hintText: "Search",
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Icon(Icons.search, color: Colors.black, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Switch(
        value: isTopRated,
        onChanged: (value) {
          setState(() {
            isTopRated = value;
          });
          performSearch(); // Re-search immediately when toggled
        },
      ),
      const Text(
        "Top Rated Products",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ],
  ),
),

const SizedBox(height: 10),
         Expanded(
  child: filteredResults.isEmpty
    ? const Center(
        child: Text(
          "No products found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      )
    : ListView.builder(
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          final item = filteredResults[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    productId: item["id"],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 139, 133, 124).withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.network(
                    baseUrl + '/uploads/' + (item["image"] ?? ""),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, size: 60, color: Colors.grey);
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: List.generate(5, (i) {
                            final rating = double.tryParse(item["averageRating"].toString()) ?? 0.0;
                            return Icon(
                              Icons.star,
                              color: i < rating.round() ? Colors.orange : Colors.grey,
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Rated ${(double.tryParse(item["averageRating"].toString()) ?? 0.0).toStringAsFixed(1)}"),
                            const SizedBox(width: 10),
                            const Icon(Icons.chat_bubble_outline, size: 16),
                            Text(" ${item["reviewCount"] ?? 0}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
)

        ],
      ),
    );
  }
}
