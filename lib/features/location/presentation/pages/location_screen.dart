import 'package:alarm_app/constants/app_colors.dart';
import 'package:alarm_app/constants/app_strings.dart';
import 'package:alarm_app/features/location/presentation/widgets/custom_btn.dart';
import 'package:alarm_app/features/location/presentation/widgets/custom_btn_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/app_routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../helpers/logger.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import '../widgets/location_content.dart';

/// Location Screen - Entry point for location feature
/// Provides BLoC to the widget tree
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocationBloc>()..add(CheckSavedLocationEvent()),
      child: const _LocationScreenContent(),
    );
  }
}

/// Location Screen Content - Main UI implementation
class _LocationScreenContent extends StatelessWidget {
  const _LocationScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B0024), Color(0xFF082257)],
          ),
        ),
        child: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            _handleStateChanges(context, state);
          },
          builder: (context, state) {
            return SafeArea(child: _buildBody(context, state));
          },
        ),
      ),
    );
  }

  /// Handle state changes and navigation
  void _handleStateChanges(BuildContext context, LocationState state) {
    if (state is LocationLoaded) {
      AppLogger.info('Location loaded, navigating to home');
      _navigateToHome(context);
    } else if (state is LocationSkipped) {
      AppLogger.info('Location skipped, navigating to home');
      _navigateToHome(context);
    } else if (state is LocationError) {
      AppLogger.error('Location error: ${state.message}');
      _showErrorSnackBar(context, state.message);
    }
  }

  /// Navigate to home screen
  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.alarmHome);
  }

  /// Show error message
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondaryDark,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Build main body based on state
  Widget _buildBody(BuildContext context, LocationState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),

          // Title and Description
          const LocationContent(),

          const SizedBox(height: 40),

          // Illustration Image
          _buildIllustration(context),

          const SizedBox(height: 40),

          // Action Buttons or Loading
          if (state is LocationLoading)
            _buildLoadingState()
          else
            _buildActionButtons(context, state),

          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
        ],
      ),
    );
  }

  /// Build illustration/image
  Widget _buildIllustration(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          // maxHeight: MediaQuery.of(context).size.width * 0.6,
        ),
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Image.asset(
            AppStrings.locationImage,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
          const SizedBox(height: 16),
          Text(
            'Getting your location...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(BuildContext context, LocationState state) {
    return Column(
      children: [
        // Use Current Location Button
        CustomBtnImg(
          text: 'Use Current Location',
          onPressed: () {
            context.read<LocationBloc>().add(GetCurrentLocationEvent());
          },
          icon: const Icon(Icons.location_on_outlined),
        ),

        const SizedBox(height: 16),

        // Skip Button
        CustomBtn(
          text: 'Home',
          onPressed: () {
            context.read<LocationBloc>().add(SkipLocationEvent());
          },
        ),
      ],
    );
  }
}
