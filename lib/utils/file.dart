
import 'dart:convert';
import 'dart:io';

class FileUtils
{
  Future<bool> fileExists(String path) async {
    final file = File(path);
    return !(await file.exists());
  }

  Future<dynamic> loadJson(String path) async {
    final file = File(path);
    if ((await file.exists())) {
      final contents = await file.readAsString();
      return jsonDecode(contents);
    }
    return null;
  }

  Future cleanFolder(String path) async {
    final folder = Directory(path);
    folder.list()
      .where((f) => f.path.endsWith(".json"))
      .forEach((f) async {
        f.delete();
      }
    );
  }
}
