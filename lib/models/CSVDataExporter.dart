import 'package:one_hundred_push_ups/models/DataExporter.dart';
import 'package:one_hundred_push_ups/models/Mappable.dart';

class CSVDataExporter extends DataExporter {
  @override
  String formatDataForExporting(List<Mappable> listToExport) {
    if (listToExport.isEmpty) {
      return "";
    } else {
      List<Map<String, dynamic>> mapList =
          listToExport.map((e) => e.toMap()).toList();
      String csvContents = "";
      //convert the list of maps to a csv format
      //first we get the keys of the map to be used as column names in our csv
      List<String> mapKeys = mapList[0].keys.toList();
      int numberOfColumns = mapKeys.length;
      for (int i = 0; i <= numberOfColumns - 2; i++) {
        csvContents = "${csvContents + mapKeys[i]},";
      }
      //writing last key with an end of line
      csvContents = "${csvContents + mapKeys.last}\n";
      //now we write the actual values
      for (Map<String, dynamic> map in mapList) {
        for (int i = 0; i <= numberOfColumns - 2; i++) {
          csvContents = "${csvContents + map[mapKeys[i]].toString()},";
        }
        //writing last value with an end of line
        csvContents = "${csvContents + map[mapKeys.last].toString()}\n";
      }
      String stringToExport = csvContents;
      return stringToExport;
    }
  }
}
