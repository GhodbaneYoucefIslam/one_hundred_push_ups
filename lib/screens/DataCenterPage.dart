import "package:flutter/material.dart";
import "package:one_hundred_push_ups/widgets/CustomDropDownMenu.dart";
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
  final myController = TextEditingController();
  final List<String> tableList = [
    'Goals',
    'Sets',
    'Rank',
  ];
  final List<String> formatList = ['JSON', 'CSV'];
  final List<String> dateList = ['All time', 'Custom range'];
  final List<String> sendOptionsList = ['Local storage', 'Send to email'];
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
                                    myController.value = TextEditingValue(text: "$selectedTable.txt");
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
                                    if (selectedDate == "Custom range") {
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
                                  textInputType: TextInputType.number,
                                  hintText: "Enter file name",
                                  hintTextSize: 10,
                                  borderColor: grey,
                                  selectedBorderColor: greenBlue,
                                  controller: myController,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Export data from ${dateRange != null ? toDisplayableDate(dateRange!.start) : 'N/A'} to ${dateRange != null ? toDisplayableDate(dateRange!.end) : 'N/A'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: (selectedDate == "Custom range") && (dateRange != null)
                                ? Colors.black54
                                : Colors
                                    .white10, // the color white 10 makes the text invisible
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
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
    final DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
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
}
