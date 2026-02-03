import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';

// Individual onboarding slide content widget
class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            flex: 3,
            child: Center(
              child: Icon(
                _getIconForIndex(),
                size: 200,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  IconData _getIconForIndex() {
    if (title.contains('Welcome')) {
      return Icons.rocket_launch_rounded;
    } else if (title.contains('Powerful')) {
      return Icons.auto_awesome_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }
}



/**
 * 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Expanded(
            flex: 3,
            child: Center(
              child: Icon(
                _getIconForIndex(),
                size: 200,
                color: AppColors.primary,
              ),
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  IconData _getIconForIndex() {
    if (title.contains('Welcome')) {
      return Icons.rocket_launch_rounded;
    } else if (title.contains('Powerful')) {
      return Icons.auto_awesome_rounded;
    } else {
      return Icons.check_circle_outline_rounded;
    }
  }
}

 */