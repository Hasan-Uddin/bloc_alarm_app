import 'package:flutter/material.dart';

/// Widget displaying the title and description for location screen
///
/// This is a reusable widget that shows the welcome message
/// and explains why location permission is needed
class LocationContent extends StatelessWidget {
  const LocationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome! Your Smart Travel Alarm",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Stay on schedule and enjoy every moment of your journey.",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
        ),
      ],
    );
  }
}
