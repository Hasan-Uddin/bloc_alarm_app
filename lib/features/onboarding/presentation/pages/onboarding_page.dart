import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
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

  // Video controllers list
  final List<VideoPlayerController> _videoControllers = [];
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideos();
  }

  Future<void> _initializeVideos() async {
    try {
      // Initialize all video controllers
      for (var page in OnboardingModel.onboardingPages) {
        VideoPlayerController controller;

        // Check if it's a network or asset video
        if (page.videoPath.startsWith('http')) {
          controller = VideoPlayerController.networkUrl(
            Uri.parse(page.videoPath),
          );
        } else {
          controller = VideoPlayerController.asset(page.videoPath);
        }

        // Initialize with error handling
        try {
          await controller.initialize();
          controller.setLooping(true);
          controller.setVolume(1.0); // Enable sound
          _videoControllers.add(controller);
        } catch (e) {
          print('Error initializing video ${page.videoPath}: $e');
          // Add a dummy controller to maintain index consistency
          _videoControllers.add(controller);
        }
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Auto-play first video after a small delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_videoControllers.isNotEmpty &&
              _videoControllers[0].value.isInitialized) {
            _videoControllers[0].play();
          }
        });
      }
    } catch (e) {
      print('Error in video initialization: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all video controllers
    for (var controller in _videoControllers) {
      controller.pause();
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      // Pause current video
      if (_currentPage < _videoControllers.length &&
          _videoControllers[_currentPage].value.isInitialized) {
        _videoControllers[_currentPage].pause();
        _videoControllers[_currentPage].seekTo(Duration.zero);
      }

      _currentPage = page;

      // Play new video
      if (_currentPage < _videoControllers.length &&
          _videoControllers[_currentPage].value.isInitialized) {
        _videoControllers[_currentPage].play();
      }
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
    // Pause current video before skipping
    if (_currentPage < _videoControllers.length &&
        _videoControllers[_currentPage].value.isInitialized) {
      _videoControllers[_currentPage].pause();
    }

    _pageController.jumpToPage(OnboardingModel.onboardingPages.length - 1);
  }

  void _complete(BuildContext context) {
    // Pause video before completing
    if (_currentPage < _videoControllers.length &&
        _videoControllers[_currentPage].value.isInitialized) {
      _videoControllers[_currentPage].pause();
    }

    context.read<OnboardingBloc>().add(const CompleteOnboardingEvent());
    Navigator.of(context).pushReplacementNamed(AppRoutes.locationScreen);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage =
        _currentPage == OnboardingModel.onboardingPages.length - 1;

    // Show error if initialization failed
    if (_hasError) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B0024), Color(0xFF082257)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 64),
                const SizedBox(height: 16),
                Text(
                  'Error loading videos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0B0024),
                  ),
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _isInitialized = false;
                    });
                    _initializeVideos();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show loading indicator while videos initialize
    if (!_isInitialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B0024), Color(0xFF082257)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'Loading videos...',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0024), Color(0xFF082257)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Page view
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: OnboardingModel.onboardingPages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final page = OnboardingModel.onboardingPages[index];
                        return OnboardingContent(
                          title: page.title,
                          description: page.description,
                          videoPath: page.videoPath,
                          controller: _videoControllers[index],
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
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: AppColors.primaryDark,
                        dotColor: AppColors.primaryLight,
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
                            borderRadius: 57,
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: AppStrings.next,
                                  onPressed: _nextPage,
                                  borderRadius: 57,
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                ],
              ),

              // Floating Skip button
              if (!isLastPage)
                Positioned(
                  top: 20,
                  right: 16,
                  child: Material(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: _skip,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          AppStrings.skip,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
