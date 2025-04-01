import 'package:flutter/material.dart';

class Review {
  String user;
  String comment;
  int likes;
  List<Reply> replies;

  Review({required this.user, required this.comment, this.likes = 0, this.replies = const []});
}

class Reply {
  String user;
  String comment;

  Reply({required this.user, required this.comment});
}

class ReviewsPage extends StatefulWidget {
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  List<Review> reviews = [
    Review(
      user: "User1",
      comment: "Really helpful product, sorted my hair loss",
      likes: 1,
      replies: [Reply(user: "User2", comment: "Thank you! That was very helpful!")],
    ),
  ];

  Map<int, bool> expandedReplies = {}; // Track expanded replies
  TextEditingController reviewController = TextEditingController();

  void addReview() {
    if (reviewController.text.isEmpty) return;

    setState(() {
      reviews.add(Review(user: "New User", comment: reviewController.text));
      reviewController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Review added!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reviews"), backgroundColor: Colors.orange),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Review Content
                        Row(
                          children: [
                            CircleAvatar(child: Icon(Icons.person)),
                            SizedBox(width: 10),
                            Expanded(child: Text(review.comment)),
                          ],
                        ),

                        SizedBox(height: 5),

                        // Like Button & View Replies
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up, color: Colors.grey),
                                  onPressed: () {},
                                ),
                                Text(review.likes.toString()),
                              ],
                            ),
                            if (review.replies.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    expandedReplies[index] = !(expandedReplies[index] ?? false);
                                  });
                                },
                                child: Text(expandedReplies[index] ?? false ? "Hide Replies" : "View Reply Comments"),
                              ),
                          ],
                        ),

                        // Replies Section
                        if (expandedReplies[index] ?? false)
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Column(
                              children: review.replies.map((reply) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(child: Icon(Icons.person)),
                                      SizedBox(width: 10),
                                      Expanded(child: Text(reply.comment)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Add Review Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      hintText: "Type here...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: const Color.fromARGB(255, 12, 12, 12)),
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
