import 'package:flutter/material.dart';

import 'product/product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = "All";
  TextEditingController searchController = TextEditingController();

  final List<String> categories = ["All", "Shampoo", "Hair Mask", "Conditioner"];

  final List<Map<String, dynamic>> searchResults = [
    {
      "image": "images/shampoo.png",
      "name": "Alfaparf Milano Moisturizing Shampoo",
      "rating": 4,
      "reviews": "10.1k",
    },
    {
      "image": "images/mask.jpg",
      "name": "Alfaparf Moisturizing Hair Mask",
      "rating": 3,
      "reviews": "8.5k",
    },
  ];

  List<Map<String, dynamic>> filteredResults = [];

  void performSearch() {
    setState(() {
      if (selectedCategory == "All" && searchController.text.isEmpty) {
        filteredResults = List.from(searchResults);
      } else {
        filteredResults = searchResults.where((item) {
          bool matchesCategory = selectedCategory == "All" || item["name"].contains(selectedCategory);
          bool matchesText =
              searchController.text.isEmpty || item["name"].toLowerCase().contains(searchController.text.toLowerCase());
          return matchesCategory && matchesText;
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredResults = List.from(searchResults);
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
                    height: 38, // Reduced height
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        items: categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 38, // Reduced height
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
                  height: 38, // Reduced height
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final item = filteredResults[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productData: item,
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
                        Image.asset(item["image"], width: 60, height: 60, fit: BoxFit.cover),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    Icons.star,
                                    color: i < item["rating"] ? Colors.orange : Colors.grey,
                                    size: 20,
                                  );
                                }),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text("Rated ${item["rating"]}"),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.chat_bubble_outline, size: 16),
                                  Text(" ${item["reviews"]}"),
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
          ),
        ],
      ),
    );
  }
}

// class ProductDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> productData;

//   const ProductDetailScreen({super.key, required this.productData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(productData["name"]),
//         backgroundColor: Colors.orange,
//         foregroundColor: Colors.black,
//       ),
//       body: Center(
//         child: Text("Product details for ${productData["name"]}"),
//       ),
//     );
//   }
// }
