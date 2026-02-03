import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/onboarding_model.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_content.dart';

// Main onboarding page with PageView
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingBloc>(),
      child: const _OnboardingPageContent(),
    );
  }
}

class _OnboardingPageContent extends StatefulWidget {
  const _OnboardingPageContent();

  @override
  State<_OnboardingPageContent> createState() => _OnboardingPageContentState();
}

class _OnboardingPageContentState extends State<_OnboardingPageContent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < OnboardingModel.onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _pageController.jumpToPage(OnboardingModel.onboardingPages.length - 1);
  }

  void _complete(BuildContext context) {
    context.read<OnboardingBloc>().add(const CompleteOnboardingEvent());
    Navigator.of(context).pushReplacementNamed(AppRoutes.notesList);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage =
        _currentPage == OnboardingModel.onboardingPages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (!isLastPage)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: OnboardingModel.onboardingPages.length,
                itemBuilder: (context, index) {
                  final page = OnboardingModel.onboardingPages[index];
                  return OnboardingContent(
                    title: page.title,
                    description: page.description,
                    imagePath: page.videoPath,
                  );
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: OnboardingModel.onboardingPages.length,
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.divider,
                  spacing: 16,
                ),
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: isLastPage
                  ? CustomButton(
                      text: AppStrings.getStarted,
                      onPressed: () => _complete(context),
                      icon: Icons.arrow_forward_rounded,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppStrings.next,
                            onPressed: _nextPage,
                            icon: Icons.arrow_forward_rounded,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
