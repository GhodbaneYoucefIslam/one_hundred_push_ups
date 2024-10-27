import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StorageHelper {
  static Future<String> get _localPath async {
    final directories = await getExternalStorageDirectories();
    return directories![0].path;
  }

  static Future<File> _getLocalFile(String fileName) async {
    final localPath = await _localPath;
    print("path is : ${localPath}/$fileName");
    return File("$localPath/$fileName");
  }

  static Future<File> writeStringToFile(String fileName, String content, BuildContext context) async {
    final file = await _getLocalFile(fileName);
    return file.writeAsString(content, mode: FileMode.write); // Explicitly specifying FileMode.write
  }

  static Future<String> readStringFromFile(String filePath) async {
    try {
      final file = File(filePath);
      return file.readAsString();
    } catch (e) {
      print("Error reading file: $e");
      return '';
    }
  }
}
