import 'package:alarm_app/core/error/exceptions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../helpers/logger.dart';
import '../models/alarm_model.dart';

abstract class AlarmLocalDataSource {
  Future<List<AlarmModel>> getAlarms();
  Future<void> addAlarm(AlarmModel alarm);
  Future<void> deleteAlarm(int id);
  Future<void> updateAlarm(AlarmModel alarm);
}

class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  static const String ALARM_BOX = 'alarm_box';

  @override
  Future<List<AlarmModel>> getAlarms() async {
    try {
      AppLogger.info('DataSource: Getting alarms from Hive');

      final box = await _openAlarmBox();
      final alarms = box.values.toList();

      AppLogger.info('DataSource: Found ${alarms.length} alarms');

      for (var i = 0; i < alarms.length; i++) {
        AppLogger.debug(
          '  ${i + 1}. ID: ${alarms[i].id}, Time: ${alarms[i].time}, Active: ${alarms[i].isActive}',
        );
      }

      return alarms;
    } catch (e, stackTrace) {
      AppLogger.error('DataSource: Error getting alarms - $e');
      AppLogger.error('StackTrace: $stackTrace');
      return []; // Return empty list instead of throwing
    }
  }

  @override
  @override
  Future<void> addAlarm(AlarmModel alarm) async {
    try {
      AppLogger.info('DataSource: Adding alarm');
      AppLogger.info('  - Original ID: ${alarm.id}');
      AppLogger.info('  - Time: ${alarm.time}');
      AppLogger.info('  - Date: ${alarm.alarmDateTime}');

      final box = await _openAlarmBox();

      // Generate a valid Hive ID (auto-increment)
      int newId;
      if (box.isEmpty) {
        newId = 1;
      } else {
        // Get the highest key and add 1
        final keys = box.keys.cast<int>().toList();
        newId = keys.reduce((a, b) => a > b ? a : b) + 1;
      }

      AppLogger.info('  - Generated Hive ID: $newId');

      // Create new alarm with valid ID
      final alarmToSave = alarm.copyWith(id: newId);

      await box.put(newId, alarmToSave);

      final saved = box.get(newId);
      if (saved != null) {
        AppLogger.info('DataSource: Alarm saved successfully');
        AppLogger.info('  - Saved with ID: $newId');
        AppLogger.info('  - Total alarms in box: ${box.length}');
      } else {
        AppLogger.error('DataSource: Alarm verification failed');
        throw AlarmDataSourceException.saveFailed();
      }
    } catch (e, stackTrace) {
      AppLogger.error('DataSource: Error adding alarm - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (e is AlarmDataSourceException) {
        rethrow;
      }

      throw AlarmDataSourceException('Failed to add alarm: $e');
    }
  }

  @override
  Future<void> deleteAlarm(int id) async {
    try {
      AppLogger.info('DataSource: DELETE REQUEST for alarm $id');

      final box = await _openAlarmBox();

      // Log ALL alarms in detail
      AppLogger.info('DataSource: BOX CONTENTS BEFORE DELETE:');
      AppLogger.info('  - Total alarms: ${box.length}');
      AppLogger.info('  - All keys: ${box.keys.toList()}');

      // Check each alarm
      for (var key in box.keys) {
        final alarm = box.get(key);
        AppLogger.info(
          '  - Key: $key, Alarm ID: ${alarm?.id}, Time: ${alarm?.time}',
        );
      }

      // Check if key exists with exact comparison
      final containsKey = box.containsKey(id);
      AppLogger.info('DataSource: Does box contain key $id? $containsKey');

      if (!containsKey) {
        AppLogger.warning('DataSource: Alarm $id NOT FOUND in box');
        AppLogger.warning('DataSource: Key type: ${id.runtimeType}');
        AppLogger.warning(
          'DataSource: Available key types: ${box.keys.map((k) => k.runtimeType).toList()}',
        );
        return;
      }

      // Try to delete
      AppLogger.info('DataSource: Attempting to delete key $id');
      await box.delete(id);

      // Verify deletion
      final stillExists = box.containsKey(id);
      AppLogger.info(
        'DataSource: After delete, key still exists? $stillExists',
      );

      if (stillExists) {
        AppLogger.error('DataSource: DELETE FAILED - Alarm still exists!');
        throw AlarmDataSourceException.deleteFailed();
      }

      // Log final state
      AppLogger.info('DataSource: BOX CONTENTS AFTER DELETE:');
      AppLogger.info('  - Remaining alarms: ${box.length}');
      AppLogger.info('  - Remaining keys: ${box.keys.toList()}');
    } catch (e, stackTrace) {
      AppLogger.error('DataSource: DELETE ERROR - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (e is AlarmDataSourceException) {
        rethrow;
      }

      throw AlarmDataSourceException('Failed to delete alarm: $e');
    }
  }

  @override
  Future<void> updateAlarm(AlarmModel alarm) async {
    try {
      AppLogger.info('DataSource: Updating alarm ${alarm.id}');

      final box = await _openAlarmBox();

      // Check if alarm exists
      if (!box.containsKey(alarm.id)) {
        AppLogger.error('DataSource: Alarm ${alarm.id} not found for update');
        throw AlarmDataSourceException('Alarm not found');
      }

      await box.put(alarm.id, alarm);

      AppLogger.info('DataSource: Alarm updated');
    } catch (e, stackTrace) {
      AppLogger.error('DataSource: Error updating alarm - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (e is AlarmDataSourceException) {
        rethrow;
      }

      throw AlarmDataSourceException('Failed to update alarm: $e');
    }
  }

  Future<Box<AlarmModel>> _openAlarmBox() async {
    try {
      if (Hive.isBoxOpen(ALARM_BOX)) {
        return Hive.box<AlarmModel>(ALARM_BOX);
      }
      return await Hive.openBox<AlarmModel>(ALARM_BOX);
    } catch (e) {
      AppLogger.error('DataSource: Failed to open alarm box - $e');
      throw AlarmDataSourceException('Failed to open alarm storage: $e');
    }
  }
}
