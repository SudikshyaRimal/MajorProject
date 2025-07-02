
import 'package:flutter/material.dart';
import 'package:sewamitraapp/feature/booking/build_review_card.dart';

List<Map<String, dynamic>> recentBookings = [
  {
    'service': 'House Cleaning',
    'date': '2024-06-25',
    'status': 'Completed',
    'price': 'Rs. 2,500',
    'rating': 5.0,
  },
  {
    'service': 'Plumbing Repair',
    'date': '2024-06-28',
    'status': 'Confirmed',
    'price': 'Rs. 1,800',
    'rating': null,
  },
  {
    'service': 'Electrical Work',
    'date': '2024-06-30',
    'status': 'Pending',
    'price': 'Rs. 3,200',
    'rating': null,
  },
];


List<Map<String, dynamic>> recentReviews = [
  {
    'service': 'House Cleaning',
    'rating': 5.0,
    'comment': 'Excellent service! Very thorough and professional.',
    'date': '2024-06-25',
  },
  {
    'service': 'Gardening',
    'rating': 4.0,
    'comment': 'Good work, but could be more punctual.',
    'date': '2024-06-20',
  },
  {
    'service': 'AC Repair',
    'rating': 5.0,
    'comment': 'Quick and efficient repair. Highly recommended!',
    'date': '2024-06-18',
  },
];


void showReviewsBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Reviews',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: recentReviews.length,
                  itemBuilder: (context, index) {
                    final review = recentReviews[index];
                    return BuildReviewCard(review : review);
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}


