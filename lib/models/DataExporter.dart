import 'package:one_hundred_push_ups/models/Mappable.dart';

abstract class DataExporter{
  String formatDataForExporting(List<Mappable> listToExport);
}