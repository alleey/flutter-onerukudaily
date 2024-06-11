import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/ruku.dart';

class AssetService {
  Future<Ruku?> loadRuku(int id) async {
    final file = await rootBundle.loadString('assets/data/q-simple/r$id.json');
    return Ruku.fromJson(jsonDecode(file));
  }
}
