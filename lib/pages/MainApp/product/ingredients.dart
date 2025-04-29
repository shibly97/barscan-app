import 'dart:convert';
import 'package:barscan/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:barscan/Utils/API/API.dart';

class IngredientsScreen extends StatefulWidget {
  final int productId;

  const IngredientsScreen({super.key, required this.productId});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  List<dynamic> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    try {
      final response = await http.get(Uri.parse("$getProductIngredient/product/${widget.productId}/ingredients"));
      if (response.statusCode == 200) {
        setState(() {
          ingredients = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load ingredients");
      }
    } catch (e) {
      debugPrint("Error fetching ingredients: $e");
      setState(() => isLoading = false);
    }
  }

void _showIngredientDetails(BuildContext context, Map<String, dynamic> ingredient) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ingredient["ingredient_name"] ?? "Ingredient Name",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                ingredient["ingredient_description"] ?? "No description available.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 15),
              if (ingredient["label_name"] != null) ...[
                Text(
                  "${ingredient["label_name"]} : ${ingredient["label_description"]}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (ingredient["label_image_path"] != null)
                  Image.network(
                    baseUrl + '/uploads/' + (ingredient["label_image_path"] ?? ""),
                    height: 60,
                  ),
              ],
              const SizedBox(height: 20),
              if (ingredient["ingredient_source"] != null && ingredient["ingredient_source"].toString().isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Source",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ingredient["ingredient_source"] ?? "",
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredient List"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ingredients.isEmpty
              ? const Center(child: Text("No Ingredients Found."))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = ingredients[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: InkWell(
                          onTap: () => _showIngredientDetails(context, ingredient),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: ingredient["label_image_path"] != null
                                ? Image.network(
                                    // "/uploads/${ingredient["label_image_path"]}",
                                     baseUrl +'/uploads/'+ (ingredient!["label_image_path"] ?? ""),
                                    width: 40,
                                    height: 40,
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(
                              ingredient["ingredient_name"] ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              ingredient["ingredient_description"] ?? "",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
