import '../common/constants.dart';
import 'data_service.dart';

class AppDataService {
  final _dataService = DataService();

  AppDataService();

  Future resetData() async {
    await _dataService.appDataBox.clear();
  }

  bool? getFlag(String key) {
    return get<bool?>("flags.$key", null);
  }

  Future putFlag(String key, bool value) async {
    await put("flags.$key", value);
  }

  T getSetting<T>(String key, T defaultValue) {
    return get<T>("settings.$key", defaultValue);
  }

  Future putSetting<T>(String key, T value) async {
    await put("settings.$key", value);
  }

  T get<T>(String key, T defaultValue) {
    final value = _dataService.appDataBox.get(key);
    if (value == null) {
      return defaultValue;
    }
    return value as T;
  }

  Future putIfAbsent<T>(String key, T value) async {
    if (get<T?>(key, null) == null) {
      await put(key, value);
    }
  }

  Future put<T>(String key, T value) async {
    await _dataService.appDataBox.put(key, value);
    await _dataService.appDataBox.flush();
  }
}

extension AppDataServiceExtensions on AppDataService {
  int get rukuIndex => get(KnownSettingsNames.rukuIndex, 1);
  Future setRukuIndex(int value) => put(KnownSettingsNames.rukuIndex, value);
}