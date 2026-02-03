import 'package:hive/hive.dart';
import '../../domain/entities/alarm_entity.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 1)
class AlarmModel extends AlarmEntity {
  @HiveField(0)
  final int idField;

  @HiveField(1)
  final DateTime alarmDateTimeField;

  @HiveField(2)
  final bool isActiveField;

  const AlarmModel({
    required this.idField,
    required this.alarmDateTimeField,
    required this.isActiveField,
  }) : super(
         id: idField,
         alarmDateTime: alarmDateTimeField,
         isActive: isActiveField,
       );

  factory AlarmModel.fromEntity(AlarmEntity entity) {
    return AlarmModel(
      idField: entity.id,
      alarmDateTimeField: entity.alarmDateTime,
      isActiveField: entity.isActive,
    );
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      idField: json['id'] as int,
      alarmDateTimeField: DateTime.parse(json['alarmDateTime'] as String),
      isActiveField: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idField,
      'alarmDateTime': alarmDateTimeField.toIso8601String(),
      'isActive': isActiveField,
    };
  }

  AlarmModel copyWith({int? id, DateTime? alarmDateTime, bool? isActive}) {
    return AlarmModel(
      idField: id ?? idField,
      alarmDateTimeField: alarmDateTime ?? alarmDateTimeField,
      isActiveField: isActive ?? isActiveField,
    );
  }
}
