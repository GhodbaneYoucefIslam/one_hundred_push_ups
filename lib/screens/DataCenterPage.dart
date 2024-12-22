import "dart:convert";
import "dart:io";
import "package:csv/csv.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/models/CSVDataExporter.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:one_hundred_push_ups/widgets/CustomDropDownMenu.dart";
import "package:provider/provider.dart";
import "package:toastification/toastification.dart";
import "../database/LocalDB.dart";
import "../models/Achievement.dart";
import "../models/DataExporter.dart";
import "../models/Goal.dart";
import "../models/GoalProvider.dart";
import "../models/JSONDataExporter.dart";
import '../models/Set.dart';
import "../models/Mappable.dart";
import "../models/StorageHelper.dart";
import "../models/UserProvider.dart";
import "../utils/constants.dart";
import "../widgets/LoadingIndicatorDialog.dart";
import "../widgets/RoundedTextField.dart";
import "../utils/methods.dart";

class DataCenterPage extends StatefulWidget {
  const DataCenterPage({super.key});

  @override
  State<DataCenterPage> createState() => _DataCenterPageState();
}

class _DataCenterPageState extends State<DataCenterPage> {
  int currentPage = 0; // export 0 and import 1
  final myPageController = PageController();
  final myExportTextController = TextEditingController();
  final myImportTextControllers = [TextEditingController(),TextEditingController()];
  final List<String> tableList = [
    goalsTableOption.tr,
    setsTableOption.tr,
    rankTableOption.tr,
  ];
  //todo: translate options
  final List<String> formatList = [jsonFormatOption, csvFormatOption];
  final List<String> dateList = [allTimeDateOption, customRangeDateOption];
  final List<String> sendOptionsList = [
    localStorageSaveOption,
    emailSaveOption
  ];
  DateTimeRange? dateRange;
  String? selectedTable, selectedFormat, selectedSendOption, selectedDate;
  String fileName = enterFileName.tr;

  String? goalsFilePath, setsFilePath;

  bool validateFileName(){
    if (fileName.endsWith(".${selectedFormat!.toLowerCase()}")) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(dataCenter.tr,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text(
                importAndExport.tr,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: PageView(
                  controller: myPageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${table.tr} :     ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: select.tr,
                                hintTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                valueTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                menuBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.black,
                                menuEntries: tableList,
                                value: selectedTable,
                                borderColor: darkBlue,
                                horizontalOffset: 10,
                                verticalOffset: -10,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTable = value;
                                    if (selectedTable != null && selectedFormat != null){
                                      myExportTextController.text = "${selectedTable!}.${selectedFormat!.toLowerCase()}";
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${format.tr} :    ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: select.tr,
                                hintTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                valueTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                menuBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.black,
                                menuEntries: formatList,
                                value: selectedFormat,
                                borderColor: darkBlue,
                                horizontalOffset: 10,
                                verticalOffset: -10,
                                onChanged: (value) {
                                  setState(() {
                                    selectedFormat = value;
                                    if (selectedTable != null && selectedFormat != null){
                                      myExportTextController.text = "${selectedTable!}.${selectedFormat!.toLowerCase()}";
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${dateRangeKey.tr} :",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: select.tr,
                                hintTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                valueTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                menuBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.black,
                                menuEntries: dateList,
                                value: selectedDate,
                                borderColor: darkBlue,
                                horizontalOffset: 10,
                                verticalOffset: -10,
                                onChanged: (value) async {
                                  setState(() {
                                    selectedDate = value;
                                    if (selectedDate == customRangeDateOption) {
                                      showCustomDateRangePicker();
                                    } else {
                                      dateRange = null;
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${saveTo.tr} :",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: select.tr,
                                hintTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                valueTextColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
                                menuBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.black,
                                menuEntries: sendOptionsList,
                                value: selectedSendOption,
                                borderColor: darkBlue,
                                horizontalOffset: 10,
                                verticalOffset: -10,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSendOption = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                fileNameKey.tr,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RoundedTextField(
                                  hintText: enterFileName.tr,
                                  hintTextSize: 10,
                                  borderColor: grey,
                                  selectedBorderColor: greenBlue,
                                  controller: myExportTextController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${exportDataFrom.tr} ${dateRange != null ? toDisplayableDate(dateRange!.start) : 'N/A'} ${to.tr} ${dateRange != null ? toDisplayableDate(dateRange!.end) : 'N/A'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: (selectedDate == customRangeDateOption) &&
                                    (dateRange != null)
                                ? (Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.background : Colors.black54)
                                : Colors.transparent,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              fileName = myExportTextController.text;
                              if (selectedTable == null ||
                                  selectedSendOption == null ||
                                  selectedFormat == null ||
                                  selectedDate == null ||
                                  fileName.isEmpty ||
                                  (selectedDate == customRangeDateOption &&
                                      dateRange == null)) {
                                toastification.show(
                                    context: context,
                                    title: Text(
                                        pleaseVerifyExportOptions.tr),
                                    autoCloseDuration:
                                        const Duration(seconds: 2),
                                    style: ToastificationStyle.simple,
                                    alignment: const Alignment(0, 0.75));
                              } else {
                                if (validateFileName()){
                                  exportData(selectedTable!, selectedDate!,
                                      dateRange, selectedFormat!, fileName);
                                }else{
                                  toastification.show(
                                      context: context,
                                      title: Text(
                                      extensionAndFormatDontMatchErrorMessage.tr),
                                      autoCloseDuration:
                                      const Duration(seconds: 2),
                                      style: ToastificationStyle.simple,
                                      alignment: const Alignment(0, 0.75));
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  turquoiseBlue.withOpacity(0.7)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            child: Text(confirm.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          pleaseSelectTwoFiles.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                goalFile.tr,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RoundedTextField(
                                  hintText: chooseFile.tr,
                                  hintTextSize: 10,
                                  borderColor: grey,
                                  selectedBorderColor: greenBlue,
                                  controller: myImportTextControllers.first,
                                  readOnly: true,
                                  onTap: () async {
                                    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom, allowedExtensions: ["csv", "json"]);
                                    if (result == null) return;
                                    final file = result.files.first;
                                    myImportTextControllers.first.text = file.name;
                                    goalsFilePath = file.path;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${setsFile.tr} ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RoundedTextField(
                                  hintText: chooseFile.tr,
                                  hintTextSize: 10,
                                  borderColor: grey,
                                  selectedBorderColor: greenBlue,
                                  controller: myImportTextControllers.last,
                                  readOnly: true,
                                  onTap: () async {
                                    final result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom, allowedExtensions: ["csv", "json"]);
                                    if (result == null) return;
                                    final file = result.files.first;
                                    myImportTextControllers.last.text = file.name;
                                    setsFilePath = file.path;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (goalsFilePath !=null && setsFilePath != null){
                                var ok = await openDialog();
                                if (ok == true){
                                  try{
                                    List<Goal> goals = await importGoals(goalsFilePath!);
                                    List<Set> sets = await importSets(setsFilePath!);
                                    final db = LocalDB();
                                    db.deleteAllSets();
                                    db.deleteAllGoals();
                                    db.importGoalsList(goals: goals);
                                    db.importSetsList(sets: sets);
                                    Provider.of<GoalProvider>(context, listen: false).nullifyGoal();
                                    final snackBar = SnackBar(
                                      content: Text(
                                        dataImportedSuccessfully.tr,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    myImportTextControllers.first.text = "";
                                    myImportTextControllers.last.text = "";
                                    goalsFilePath = null;
                                    setsFilePath = null;
                                  }catch(e){
                                    //todo: content validation? FK dependencies
                                    final snackBar = SnackBar(
                                      content: Text(
                                      importFailedMessage.tr,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                }
                              }else{
                                toastification.show(
                                    context: context,
                                    title: Text(
                                        pleaseSelectTwoFiles.tr),
                                    autoCloseDuration:
                                    const Duration(seconds: 2),
                                    style: ToastificationStyle.simple,
                                    alignment: const Alignment(0, 0.75));
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  turquoiseBlue.withOpacity(0.7)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            child: Text(confirm.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage = 0;
                          });
                          myPageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              currentPage == 0 ? greenBlue : grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(export.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: currentPage == 0
                                    ? Colors.black
                                    : Colors.white))),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage = 1;
                          });
                          myPageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              currentPage == 1 ? greenBlue : grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(import.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: currentPage == 1
                                    ? Colors.black
                                    : Colors.white))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showCustomDateRangePicker() async {
    final db = LocalDB();
    final dates = await db.fetchAvailableDates();
    DateTime firstDate =
        dates != null ? dates.first : DateTime(DateTime.now().year);
    DateTime lastDate =
        dates != null ? dates.last : DateTime(DateTime.now().year);
    final DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (dateTimeRange != null) {
      setState(() {
        dateRange = dateTimeRange;
      });
    } else {
      setState(() {
        selectedDate = null;
        dateRange = null;
      });
    }
  }

  Future<List<Mappable>> getTableData(
      String table, String dateOption, DateTimeRange? dateRange) async {
    switch (table) {
      case goalsTableOption:
        {
          final db = LocalDB();
          List<Goal> dbContentsList = await db.fetchAllGoals();
          if (dateOption == allTimeDateOption) {
            return dbContentsList;
          } else {
            List<Mappable> dataList = [];
            DateTime rangeStart = dateRange!.start;
            DateTime rangeEnd = dateRange.end;
            //keeping only the relevant elements
            for (Goal goal in dbContentsList) {
              if (goal.date.compareTo(rangeStart) >= 0 &&
                  goal.date.compareTo(rangeEnd) <= 0) {
                dataList.add(goal);
              }
            }
            return dataList;
          }
        }
      case setsTableOption:
        {
          final db = LocalDB();
          List<Set> dbContentsList = await db.fetchAllSets();
          if (dateOption == allTimeDateOption) {
            return dbContentsList;
          } else {
            List<Mappable> dataList = [];
            DateTime rangeStart = dateRange!.start;
            DateTime rangeEnd = dateRange.end;
            //keeping only the relevant elements
            for (Set set in dbContentsList) {
              if (set.time.compareTo(rangeStart) >= 0 &&
                  set.time.compareTo(
                          rangeEnd.add(const Duration(days: 1))) <
                      0) {
                dataList.add(set);
              }
            }
            return dataList;
          }
        }
      case rankTableOption:
        {
          if (Provider.of<UserProvider>(context, listen: false).currentUser == null){
            final snackBar = SnackBar(
              content: Text(
                loginToAccessRankErrorMessage.tr,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }else{
            try{
              LoadingIndicatorDialog().show(context, text: retrievingData.tr);
              List<Map<String,dynamic>>? intermediateList = await getUserAchievements(Provider.of<UserProvider>(context, listen: false).currentUser!.id!);
              LoadingIndicatorDialog().dismiss();
              List<Mappable> dataList = intermediateList!.map((e) => Achievement.fromMap(e)).toList();
              return dataList;
            }catch(e){
              print(e.toString());
              WidgetsBinding.instance.addPostFrameCallback((_) {
                toastification.show(
                    context: context,
                    title: Text(
                        serverConnectionError.tr),
                    autoCloseDuration:
                    const Duration(seconds: 2),
                    style: ToastificationStyle.simple,
                    alignment: const Alignment(0, 0.75));
              });
            }
          }
          return [];
        }
    }
    return [];
  }

  void exportData(String table, String dateOption, DateTimeRange? dateRange,
      String format, String fileName) async {
    List<Mappable> dataList = await getTableData(table, dateOption, dateRange);
    DataExporter dataExporter;
    File savedFile;
    switch (format) {
      case csvFormatOption:
        {
          dataExporter = CSVDataExporter();
          String fileContents = dataExporter.formatDataForExporting(dataList);
          savedFile = await StorageHelper.writeStringToFile(fileName, fileContents, context);
          final snackBar = SnackBar(
            content: Text(
              '${dataExportedTo.tr} ${savedFile.parent}',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        }
      case jsonFormatOption:
        {
          dataExporter = JSONDataExporter();
          String fileContents = dataExporter.formatDataForExporting(dataList);
          savedFile = await StorageHelper.writeStringToFile(fileName, fileContents, context);
          final snackBar = SnackBar(
            content: Text(
              '${dataExportedTo.tr} ${savedFile.parent}',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        }
    }
  }

  Future<bool?> openDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                dataDeletionWarning.tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(greenBlue),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(no.tr,
                          style: TextStyle(
                              fontSize: 16, color: Colors.white))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(turquoiseBlue),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(yes.tr,
                          style: TextStyle(
                              fontSize: 16, color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
      ));

  Future<List<Goal>> importGoals(String path) async {
    List<Goal> goals = [];
    String extension = path.split(".").last;
    switch (extension){
      case "json": {
        String value = await StorageHelper.readStringFromFile(path);
        print("goals file contents : $value");
        List<dynamic> jsonValue = jsonDecode(value);
        goals = jsonValue.map((map) => Goal.fromMap(Map<String, dynamic>.from(map))).toList();
        return goals;
      }
      case "csv": {
        List<Map<String,dynamic>> maps = [];
        final source = File(path).openRead();
        final lines = await source.transform(utf8.decoder).transform(CsvToListConverter(eol: '\n')).toList();
        //first we extract they keys
        final keys = lines.first;
        lines.remove(lines.first);
        //we create a map for each line
        for (List<dynamic> line in lines){
          Map<String, dynamic> map = {};
          for (int i =0; i<keys.length; i++){
            map[keys[i].toString()] = line[i];
          }
          maps.add(map);
        }
        //we convert the map to a list of goals
        goals = maps.map((map) => Goal.fromMap(map)).toList();
        return goals;
      }
    }
    return [];
  }
  Future<List<Set>> importSets(String path) async {
    List<Set> sets = [];
    String extension = path.split(".").last;
    switch (extension){
      case "json": {
        String value = await StorageHelper.readStringFromFile(path);
        print("sets file contents : $value");
        List<dynamic> jsonValue = jsonDecode(value);
        sets = jsonValue.map((map) => Set.fromMap(Map<String, dynamic>.from(map))).toList();
        return sets;
      }
      case "csv": {
        List<Map<String,dynamic>> maps = [];
        final source = File(path).openRead();
        final lines = await source.transform(utf8.decoder).transform(CsvToListConverter(eol: '\n')).toList();
        //first we extract they keys
        final keys = lines.first;
        lines.remove(lines.first);
        //we create a map for each line
        for (List<dynamic> line in lines){
          Map<String, dynamic> map = {};
          for (int i =0; i<keys.length; i++){
            map[keys[i].toString()] = line[i];
          }
          maps.add(map);
        }
        //we convert the map to a list of goals
        sets = maps.map((map) => Set.fromMap(map)).toList();
        return sets;
      }
    }
    return [];
  }
}
