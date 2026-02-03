import 'package:alarm_app/helpers/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Local storage service using Hive
// Provides generic CRUD operations for local data persistence
class LocalStorage {
  static late SharedPreferences _prefs;

  // Initialize Hive and SharedPreferences
  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    AppLogger.info('Hive initialized');

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('SharedPreferences initialized');
  }

  // ============== Hive Operations ==============

  // Open a Hive box
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  // Get box (must be already opened)
  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  // Save data to box
  static Future<void> put<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
    AppLogger.debug('Saved to Hive: $boxName/$key');
  }

  // Get data from box
  static Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    final value = box.get(key);
    AppLogger.debug('Read from Hive: $boxName/$key');
    return value;
  }

  // Delete data from box
  static Future<void> delete(String boxName, String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
    AppLogger.debug('Deleted from Hive: $boxName/$key');
  }

  // Clear all data in box
  static Future<void> clear(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
    AppLogger.debug('Cleared Hive box: $boxName');
  }

  // Get all values from box
  static Future<List<T>> getAll<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.values.toList();
  }

  // Get all keys from box
  static Future<List<dynamic>> getAllKeys(String boxName) async {
    final box = await openBox(boxName);
    return box.keys.toList();
  }

  // Check if key exists in box
  static Future<bool> containsKey(String boxName, String key) async {
    final box = await openBox(boxName);
    return box.containsKey(key);
  }

  // Close a box
  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  // Close all boxes
  static Future<void> closeAll() async {
    await Hive.close();
  }

  // Delete a box permanently
  static Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).deleteFromDisk();
    } else {
      await Hive.deleteBoxFromDisk(boxName);
    }
    AppLogger.debug('Deleted Hive box permanently: $boxName');
  }

  // ---------------< SharedPreferences Operations >--------------

  // Save string to SharedPreferences
  static Future<bool> setString(String key, String value) async {
    AppLogger.debug('Saved to SharedPreferences: $key');
    return await _prefs.setString(key, value);
  }

  // Get string from SharedPreferences
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save int to SharedPreferences
  static Future<bool> setInt(String key, int value) async {
    AppLogger.debug('Saved to SharedPreferences: $key');
    return await _prefs.setInt(key, value);
  }

  // Get int from SharedPreferences
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save bool to SharedPreferences
  static Future<bool> setBool(String key, bool value) async {
    AppLogger.debug('Saved to SharedPreferences: $key');
    return await _prefs.setBool(key, value);
  }

  // Get bool from SharedPreferences
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Save double to SharedPreferences
  static Future<bool> setDouble(String key, double value) async {
    AppLogger.debug('Saved to SharedPreferences: $key');
    return await _prefs.setDouble(key, value);
  }

  // Get double from SharedPreferences
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // Save string list to SharedPreferences
  static Future<bool> setStringList(String key, List<String> value) async {
    AppLogger.debug('Saved to SharedPreferences: $key');
    return await _prefs.setStringList(key, value);
  }

  // Get string list from SharedPreferences
  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove key from SharedPreferences
  static Future<bool> remove(String key) async {
    AppLogger.debug('Removed from SharedPreferences: $key');
    return await _prefs.remove(key);
  }

  // Clear all SharedPreferences
  static Future<bool> clearPreferences() async {
    AppLogger.debug('Cleared all SharedPreferences');
    return await _prefs.clear();
  }

  // Check if key exists in SharedPreferences
  static bool containsKeyInPrefs(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys from SharedPreferences
  static Set<String> getAllPrefsKeys() {
    return _prefs.getKeys();
  }
}
