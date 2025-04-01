import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IngredientsScreen extends StatelessWidget {
   static const List<Map<String, dynamic>> ingredients = [
    {
      "name": "AQUA (WATER)",
      "description": "Common solvent, safe in all formulations.",
      "status": "safe",
      "source": "https://example.com/aqua"
    },
    {
      "name": "SODIUM C14-16 OLEFIN SULFONATE",
      "description": "A cleansing agent, generally safe.",
      "status": "safe",
      "source": "https://example.com/aqua"
    },
    {
      "name": "DISODIUM LAURETH SULFOSUCCINATE",
      "description": "Mild surfactant, can cause irritation for sensitive skin.",
      "status": "caution",
      "source": "https://example.com/aqua"
    },
    {
      "name": "COCAMIDOPROPYL BETAINE",
      "description": "Foaming agent, may cause allergies in some users.",
      "status": "caution",
      "source": "https://example.com/aqua"
    },
    {
      "name": "PARFUM (FRAGRANCE)",
      "description": "Artificial fragrance, may trigger allergies.",
      "status": "caution",
      "source": "https://example.com/aqua"
    },
    {
      "name": "PEG-7 GLYCERYL COCOATE",
      "description": "Moisturizing agent, potential irritant for sensitive skin.",
      "status": "caution",
      "source": "https://example.com/aqua"
    },
    {
      "name": "PHENOXYETHANOL",
      "description": "Preservative, may cause irritation or toxicity concerns.",
      "status": "avoid",
      "source": "https://example.com/aqua"
    },
    {
      "name": "GLYCOL DISTEARATE",
      "description": "Thickening agent, potential harmful effects.",
      "status": "avoid",
      "source": "https://example.com/aqua"
    }
  ];


  const IngredientsScreen({super.key});

  Widget _buildStatusIcon(String status) {
    switch (status) {
      case "safe":
        return const Icon(Icons.check_circle, color: Colors.green);
      case "caution":
        return const Icon(Icons.warning, color: Colors.orange);
      case "avoid":
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  void _showIngredientDetails(BuildContext context, Map<String, dynamic> ingredient) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ingredient["name"],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                ingredient["description"],
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(ingredient["source"]);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open link")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("View Source", style: TextStyle(color: Colors.white)),
              ),
            ],
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                 // Product Details Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Image.asset("images/shampoo.png", width: 50, height: 50),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(label: Text("Shampoo / Viana Cosmetics")),
                      Text("Alfaparf Milano Moisturizing Shampoo",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text("Ingredient List",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),
            Expanded(
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
                        title: Text(
                          ingredient["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          ingredient["description"],
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        trailing: _buildStatusIcon(ingredient["status"]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
