/// Storage key constants for Hive and SharedPreferences
/// Centralized storage keys prevent typos and maintain consistency
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();

  // Hive Box Names
  static const String notesBox = 'notes_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String alarmsBox = 'alarms_box';

  // SharedPreferences Keys
  static const String isOnboardingCompleted = 'is_onboarding_completed';
  static const String isDarkMode = 'is_dark_mode';
  static const String language = 'language';
  static const String userId = 'user_id';
  static const String userToken = 'user_token';
  static const String lastSyncTime = 'last_sync_time';

  // Hive Type IDs (for TypeAdapter registration)
  static const int noteTypeId = 0;
  static const int userTypeId = 1;
  static const int alarmTypeId = 2;
}
