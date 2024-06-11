import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../common/constants.dart';
import '../models/app_meta_data.dart';


class DataService {

  static final DataService _instance = DataService._();

  DataService._();

  factory DataService() {
    return _instance;
  }

  late Box<dynamic> appDataBox;
  late AppMetaData metaData;

  Future initialize() async {
    // on web for example the subdir is ignored, therefore need to put ver in filenames as well
    if (!kIsWeb) {
      await _cleanUpOldVersionFolders();
    }

    await Hive.initFlutter("one_ruku_daily-v${Constants.appDataVersion}");
    // as a fallback.
    // on web for example the subdir is ignored, therefore need to put ver in filenames as well
    // as a fallback.
    appDataBox = await Hive.openBox<dynamic>('appdata-v${Constants.appDataVersion}');

    metaData = await _loadMeta();
  }

  Future<AppMetaData> _loadMeta() async {
    final jsonString = await rootBundle.loadString('assets/metadata.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AppMetaData.fromJson(jsonMap);
  }

  Future<void> _cleanUpOldVersionFolders() async {

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final directories = Directory(appDocPath).listSync();

    const currentHiveFolderName = "one_ruku_daily-v${Constants.appDataVersion}";
    for (final entity in directories) {

      if (entity is Directory) {
        if (entity.path.contains("one_ruku_daily-v") && !entity.path.endsWith(currentHiveFolderName)) {
          try {
            await entity.delete(recursive: true);
          } catch (e) {
            log("Error deleting folder ${entity.path}: $e");
          }
        }
      }
    }
  }
}
