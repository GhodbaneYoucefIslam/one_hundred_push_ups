import "package:flutter/material.dart";
import "package:one_hundred_push_ups/models/CSVDataExporter.dart";
import "package:one_hundred_push_ups/widgets/CustomDropDownMenu.dart";
import "package:toastification/toastification.dart";
import "../database/LocalDB.dart";
import "../models/DataExporter.dart";
import "../models/Goal.dart";
import "../models/JSONDataExporter.dart";
import '../models/Set.dart';
import "../models/Mappable.dart";
import "../models/StorageHelper.dart";
import "../utils/constants.dart";
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
  final myTextController = TextEditingController();
  final List<String> tableList = [
    goalsTableOption,
    setsTableOption,
    rankTableOption,
  ];
  final List<String> formatList = [jsonFormatOption, csvFormatOption];
  final List<String> dateList = [allTimeDateOption, customRangeDateOption];
  final List<String> sendOptionsList = [
    localStorageSaveOption,
    emailSaveOption
  ];
  DateTimeRange? dateRange;
  String? selectedTable, selectedFormat, selectedSendOption, selectedDate;
  String fileName = "Enter the name you would like";

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
              Text("Data Center",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text(
                "Import and export your In-App data",
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Table :     ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: "Select",
                                menuEntries: tableList,
                                value: selectedTable,
                                borderColor: darkBlue,
                                horizontalOffset: 10,
                                verticalOffset: -10,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTable = value;
                                    myTextController.value = TextEditingValue(
                                        text: "$selectedTable.txt");
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Format :    ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: "Select",
                                menuEntries: formatList,
                                value: selectedFormat,
                                borderColor: darkBlue,
                                horizontalOffset: 10,
                                verticalOffset: -10,
                                onChanged: (value) {
                                  setState(() {
                                    selectedFormat = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Date range :",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: "Select",
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Save to :   ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              CustomDropDownMenu(
                                hintText: "Select",
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
                                "File name",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RoundedTextField(
                                  hintText: "Enter file name",
                                  hintTextSize: 10,
                                  borderColor: grey,
                                  selectedBorderColor: greenBlue,
                                  controller: myTextController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Export data from ${dateRange != null ? toDisplayableDate(dateRange!.start) : 'N/A'} to ${dateRange != null ? toDisplayableDate(dateRange!.end) : 'N/A'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: (selectedDate == customRangeDateOption) &&
                                    (dateRange != null)
                                ? Colors.black54
                                : Colors
                                    .white10, // the color white 10 makes the text invisible
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              //LocalDB().deleteAllSets();
                              fileName = myTextController.text;
                              if (selectedTable == null ||
                                  selectedSendOption == null ||
                                  selectedFormat == null ||
                                  selectedDate == null ||
                                  fileName.isEmpty ||
                                  (selectedDate == customRangeDateOption &&
                                      dateRange == null)) {
                                toastification.show(
                                    context: context,
                                    title: const Text(
                                        "Please verify all of your export options"),
                                    autoCloseDuration:
                                        const Duration(seconds: 2),
                                    style: ToastificationStyle.simple,
                                    alignment: const Alignment(0, 0.75));
                              } else {
                                exportData(selectedTable!, selectedDate!,
                                    dateRange, selectedFormat!, fileName);
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
                            child: Text("Confirm",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white))),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Table",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
                        child: Text("Export",
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
                        child: Text("Import",
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
                          rangeEnd /*todo: fix comparison to include whole day*/) <=
                      0) {
                dataList.add(set);
              }
            }
            return dataList;
          }
        }
      case rankTableOption:
        {
          //todo: connect with backend
          return [];
        }
    }
    return [];
  }

  void exportData(String table, String dateOption, DateTimeRange? dateRange,
      String format, String fileName) async {
    List<Mappable> dataList = await getTableData(table, dateOption, dateRange);
    DataExporter dataExporter;
    switch (format) {
      case csvFormatOption:
        {
          dataExporter = CSVDataExporter();
          String fileContents = dataExporter.formatDataForExporting(dataList);
          StorageHelper.writeStringToFile(fileName, fileContents, context)
              .then((value) {
            print("File created");
            print(value);
          });
          break;
        }
      case jsonFormatOption:
        {
          dataExporter = JSONDataExporter();
          String fileContents = dataExporter.formatDataForExporting(dataList);
          StorageHelper.writeStringToFile(fileName, fileContents, context)
              .then((value) {
            print("File created");
            print(value);
          });
          break;
        }
    }
  }
}
