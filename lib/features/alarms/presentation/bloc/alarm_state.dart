import 'package:equatable/equatable.dart';
import '../../domain/entities/alarm_entity.dart';

abstract class AlarmState extends Equatable {
  const AlarmState();

  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmLoading extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final List<AlarmEntity> alarms;
  final String? userLocation;

  const AlarmLoaded({required this.alarms, this.userLocation});

  @override
  List<Object?> get props => [alarms, userLocation];

  AlarmLoaded copyWith({List<AlarmEntity>? alarms, String? userLocation}) {
    return AlarmLoaded(
      alarms: alarms ?? this.alarms,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

class AlarmError extends AlarmState {
  final String message;

  const AlarmError(this.message);

  @override
  List<Object?> get props => [message];
}

class AlarmAdded extends AlarmState {}

class AlarmDeleted extends AlarmState {
  final String time;

  const AlarmDeleted(this.time);

  @override
  List<Object?> get props => [time];
}
