import 'dart:convert';
import 'package:one_hundred_push_ups/models/DataExporter.dart';
import 'package:one_hundred_push_ups/models/Mappable.dart';

class JSONDataExporter extends DataExporter {
  @override
  String formatDataForExporting(List<Mappable> listToExport) {
    if (listToExport.isEmpty) {
      return "[]";
    } else {
      List<Map<String, dynamic>> mapList =
          listToExport.map((e) => e.toMap()).toList();
      String stringToExport = jsonEncode(mapList);
      return stringToExport;
    }
  }
}
