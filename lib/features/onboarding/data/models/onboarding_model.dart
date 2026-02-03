import 'package:alarm_app/constants/app_strings.dart';
import 'package:equatable/equatable.dart';

// Onboarding page model
class OnboardingModel extends Equatable {
  final String title;
  final String description;
  final String videoPath;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.videoPath,
  });

  @override
  List<Object?> get props => [title, description, videoPath];

  // Static list of onboarding pages
  static List<OnboardingModel> onboardingPages = [
    const OnboardingModel(
      title: 'Discover the world, one journey at a time.',
      description:
          'From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today.',
      videoPath: AppStrings.onBoardingVid_1,
    ),
    const OnboardingModel(
      title: 'Explore new horizons, one step at a time.',
      description:
          'Every trip holds a story waiting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.',
      videoPath: AppStrings.onBoardingVid_2,
    ),
    const OnboardingModel(
      title: 'See the beauty, one journey at a time.',
      description:
          'Travel made simple and exciting—discover places you’ll love and moments you’ll never forget.',
      videoPath: AppStrings.onBoardingVid_3,
    ),
  ];
}
