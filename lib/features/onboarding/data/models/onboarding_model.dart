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
      title: 'Welcome to Flutter Clean App',
      description:
          'A production-ready template with clean architecture, separation of concerns, and industry best practices.',
      videoPath: 'assets/images/onboarding1.png',
    ),
    const OnboardingModel(
      title: 'Powerful Architecture',
      description:
          'Built with BLoC pattern, dependency injection, Hive for offline storage, and Dio for seamless API integration.',
      videoPath: 'assets/images/onboarding2.png',
    ),
    const OnboardingModel(
      title: 'Ready to Build',
      description:
          'Start building your features with a solid foundation. Example Notes feature included to demonstrate CRUD operations.',
      videoPath: 'assets/images/onboarding3.png',
    ),
  ];
}
