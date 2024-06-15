import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/ruku.dart';

class AssetService {

  Future<Ruku?> loadRuku(int id) async {
    final file = await rootBundle.loadString('assets/data/q-simple/r$id.json');
    return Ruku.fromJson(jsonDecode(file));
  }

  Future<Map<String, Map<String, int>>> loadSuraRukuMap() async {

    final file = await rootBundle.loadString('assets/data/sura_ruku_map.json');
    final Map<String, dynamic> jsonData = jsonDecode(file);

    final Map<String, Map<String, int>> suraMap = jsonData.map((key, value) {
      return MapEntry(key, {
        'first': value['first'],
        'total': value['total']
      });
    });

    return suraMap;
  }
}
