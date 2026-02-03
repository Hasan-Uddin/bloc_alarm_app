import '../../../../core/storage/local_storage.dart';
import '../../../../helpers/logger.dart';
import '../models/alarm_model.dart';

abstract class AlarmLocalDataSource {
  Future<List<AlarmModel>> getAlarms();
  Future<void> saveAlarms(List<AlarmModel> alarms);
  Future<void> addAlarm(AlarmModel alarm);
  Future<void> deleteAlarm(int id);
  Future<void> updateAlarm(AlarmModel alarm);
  Future<String?> getUserLocation();
}

class AlarmLocalDataSourceImpl implements AlarmLocalDataSource {
  static const String ALARM_BOX = 'alarm_box';
  static const String ALARMS_KEY = 'alarms';
  static const String LOCATION_BOX = 'location_box';
  static const String USER_LOCATION_KEY = 'user_location';

  @override
  Future<List<AlarmModel>> getAlarms() async {
    try {
      AppLogger.info('Retrieving alarms from Hive...');

      final alarms = await LocalStorage.getAll<AlarmModel>(ALARM_BOX);

      AppLogger.info('Retrieved ${alarms.length} alarms');
      return alarms;
    } catch (e) {
      AppLogger.error('Error getting alarms: $e');
      return [];
    }
  }

  @override
  Future<void> saveAlarms(List<AlarmModel> alarms) async {
    try {
      AppLogger.info('Saving ${alarms.length} alarms to Hive...');

      await LocalStorage.clear(ALARM_BOX);

      for (var alarm in alarms) {
        await LocalStorage.put<AlarmModel>(
          ALARM_BOX,
          alarm.id.toString(),
          alarm,
        );
      }

      AppLogger.info('Alarms saved successfully');
    } catch (e) {
      AppLogger.error('Error saving alarms: $e');
      throw CacheException('Failed to save alarms');
    }
  }

  @override
  Future<void> addAlarm(AlarmModel alarm) async {
    try {
      AppLogger.info('Adding alarm: ${alarm.time}');

      await LocalStorage.put<AlarmModel>(ALARM_BOX, alarm.id.toString(), alarm);

      AppLogger.info('Alarm added successfully');
    } catch (e) {
      AppLogger.error('Error adding alarm: $e');
      throw CacheException('Failed to add alarm');
    }
  }

  @override
  Future<void> deleteAlarm(int id) async {
    try {
      AppLogger.info('Deleting alarm: $id');

      await LocalStorage.delete(ALARM_BOX, id.toString());

      AppLogger.info('Alarm deleted successfully');
    } catch (e) {
      AppLogger.error('Error deleting alarm: $e');
      throw CacheException('Failed to delete alarm');
    }
  }

  @override
  Future<void> updateAlarm(AlarmModel alarm) async {
    try {
      AppLogger.info('Updating alarm: ${alarm.id}');

      await LocalStorage.put<AlarmModel>(ALARM_BOX, alarm.id.toString(), alarm);

      AppLogger.info('Alarm updated successfully');
    } catch (e) {
      AppLogger.error('Error updating alarm: $e');
      throw CacheException('Failed to update alarm');
    }
  }

  @override
  Future<String?> getUserLocation() async {
    try {
      AppLogger.info('Retrieving user location...');

      final location = await LocalStorage.getString(USER_LOCATION_KEY);

      if (location != null) {
        AppLogger.info('User location found: $location');
      } else {
        AppLogger.info('No user location found');
      }

      return location;
    } catch (e) {
      AppLogger.error('Error getting user location: $e');
      return null;
    }
  }
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => message;
}
