
import 'package:flutter/material.dart';
import 'booking_utils.dart';
import 'build_review_card.dart';

class RecentReviewSection extends StatelessWidget {
  const RecentReviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader('Recent Reviews', onViewAll: () {
          showReviewsBottomSheet(context);
        }),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: recentReviews.take(2).length,
          itemBuilder: (context, index) {
            final review = recentReviews[index];
            return BuildReviewCard(review:review);
          },
        ),
      ],
    );  }



  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }






}
