import 'package:equatable/equatable.dart';

class AlarmEntity extends Equatable {
  final int id;
  final DateTime alarmDateTime;
  final bool isActive;

  const AlarmEntity({
    required this.id,
    required this.alarmDateTime,
    this.isActive = true,
  });

  String get time {
    final hour = alarmDateTime.hour.toString().padLeft(2, '0');
    final minute = alarmDateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get date {
    return '${alarmDateTime.day}/${alarmDateTime.month}/${alarmDateTime.year}';
  }

  @override
  List<Object?> get props => [id, alarmDateTime, isActive];
}
