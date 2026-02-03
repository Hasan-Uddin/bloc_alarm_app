import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlarmsEvent extends AlarmEvent {}

class LoadUserLocationEvent extends AlarmEvent {}

class AddAlarmEvent extends AlarmEvent {
  final TimeOfDay time;

  const AddAlarmEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class DeleteAlarmEvent extends AlarmEvent {
  final int id;

  const DeleteAlarmEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleAlarmEvent extends AlarmEvent {
  final int id;
  final bool isActive;

  const ToggleAlarmEvent(this.id, this.isActive);

  @override
  List<Object?> get props => [id, isActive];
}
