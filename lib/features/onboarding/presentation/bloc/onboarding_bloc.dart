import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/base/base_event.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/usecases/check_onboarding_status.dart';
import '../../domain/usecases/complete_onboarding.dart';

// Onboarding Events
abstract class OnboardingEvent extends BaseEvent {
  const OnboardingEvent();
}

class CompleteOnboardingEvent extends OnboardingEvent {
  const CompleteOnboardingEvent();
}

// Onboarding States
abstract class OnboardingState extends BaseState {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress();
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}

// Onboarding BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckOnboardingStatus checkOnboardingStatus;
  final CompleteOnboarding completeOnboarding;

  OnboardingBloc({
    required this.checkOnboardingStatus,
    required this.completeOnboarding,
  }) : super(const OnboardingInProgress()) {
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      await completeOnboarding();
      emit(const OnboardingCompleted());
    } catch (e) {
      // If completion fails, stay in progress state
      emit(const OnboardingInProgress());
    }
  }
}
