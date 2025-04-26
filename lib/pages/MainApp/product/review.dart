import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barscan/Utils/API/API.dart';
import 'package:barscan/Utils/store/customer_session.dart';

class ReviewsPage extends StatefulWidget {
  final int productId;

  const ReviewsPage({super.key, required this.productId});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<dynamic> reviews = [];
  TextEditingController reviewController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  int? customerId;
  int expandedReviewIndex = -1;

  @override
  void initState() {
    super.initState();
    loadCustomer();
    fetchReviews();
  }

  Future<void> loadCustomer() async {
    final id = await CustomerSession.getCustomerId();
    customerId = int.tryParse(id ?? '');
  }

  Future<void> fetchReviews() async {
    final response = await http.get(Uri.parse('$getProductReviewReply/${widget.productId}'));
    if (response.statusCode == 200) {
      setState(() {
        reviews = jsonDecode(response.body);
      });
    } else {
      debugPrint('Failed to load reviews');
    }
  }

  Future<void> addReview() async {
    if (reviewController.text.isEmpty || customerId == null) return;

    final response = await http.post(
      Uri.parse('$addProductReviewReply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'product_id': widget.productId,
        'customer_id': customerId,
        'rating': 5,  // You can add a UI to select rating later if needed
        'review': reviewController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      reviewController.clear();
      fetchReviews();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review added!')));
    }
  }

  Future<void> addReply(int reviewId) async {
    if (replyController.text.isEmpty || customerId == null) return;

    final response = await http.post(
      Uri.parse('$getReviewReplies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'review_id': reviewId,
        'customer_id': customerId,
        'reply': replyController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      replyController.clear();
      fetchReviews();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply added!')));
    }
  }

  void openReplyDialog(int reviewId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reply to Review'),
        content: TextField(
          controller: replyController,
          decoration: const InputDecoration(hintText: "Write your reply..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              addReply(reviewId);
            },
            child: const Text('Reply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews"), backgroundColor: Colors.orange),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                review['review'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('By: ${review['firstname'] ?? ''} ${review['lastname'] ?? ''}', style: TextStyle(color: Colors.grey.shade600)),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  expandedReviewIndex = expandedReviewIndex == index ? -1 : index;
                                });
                              },
                              child: Text(
                                expandedReviewIndex == index ? "Hide Replies" : "View Replies",
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        if (expandedReviewIndex == index)
                          Column(
                            children: (review['replies'] as List<dynamic>).map((reply) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    const CircleAvatar(radius: 15, child: Icon(Icons.person, size: 15)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text("${reply['reply']} (by ${reply['firstname'] ?? ''})"),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        TextButton.icon(
                          onPressed: () => openReplyDialog(review['id']),
                          icon: const Icon(Icons.reply, size: 18),
                          label: const Text("Reply"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Add new review
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      hintText: "Write a review...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: addReview,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
