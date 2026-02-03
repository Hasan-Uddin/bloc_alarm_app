import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../constants/app_colors.dart';

// Individual onboarding slide content widget
class OnboardingContent extends StatefulWidget {
  final String title;
  final String description;
  final String videoPath;
  final VideoPlayerController controller;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.videoPath,
    required this.controller,
  });

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final videoHeight = availableHeight * 0.7; // 70% for video
        final textMinHeight = availableHeight * 0.3; // 30% for text

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Video Player Section
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: videoHeight,
                  child: Container(
                    color: Colors.black,
                    child: widget.controller.value.isInitialized
                        ? FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: widget.controller.value.size.width,
                              height: widget.controller.value.size.height,
                              child: VideoPlayer(widget.controller),
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading video...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),

              // Text Content Section
              Container(
                width: constraints.maxWidth,
                constraints: BoxConstraints(minHeight: textMinHeight),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      widget.description,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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