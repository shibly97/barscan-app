import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<Map<String, dynamic>> historyItems = const [
    {
      "image": "images/shampoo.png",
      "name": "Alfaparf Milano Moisturizing Shampoo",
      "rating": 4, // Out of 5
      "reviews": "10.1k",
      "highlighted": true, // Highlight first item
    },
    {
      "image": "images/mask.jpg",
      "name": "Alfaparf Moisturizing Hair Mask",
      "rating": 2,
      "reviews": "10.1k",
      "highlighted": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        
      ),
      body: ListView.builder(
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: 
                  [
                      BoxShadow(
                        color: const Color.fromARGB(255, 110, 102, 90).withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  ,
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
          );
        },
      ),
    );
  }
}
