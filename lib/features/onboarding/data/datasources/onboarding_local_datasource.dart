import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/storage_keys.dart';

// Onboarding local data source abstract class
abstract class OnboardingLocalDataSource {
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted();
}

// Implementation of onboarding local data source
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> isOnboardingCompleted() async {
    return sharedPreferences.getBool(StorageKeys.isOnboardingCompleted) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    await sharedPreferences.setBool(StorageKeys.isOnboardingCompleted, true);
  }
}
