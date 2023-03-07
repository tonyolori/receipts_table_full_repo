// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'paginated/paginated_data_table.dart';
import 'theme.dart';
import 'my_data.dart';
import 'data_store.dart';

void main() {
  runApp(const Myapp());
}

//outside
int rowsPerPage = 10;
int currentPage = 0;
final key = GlobalKey<CustomPaginatedDataTableState>();

List<Data> emptyData = [
  Data(
      accountCode: '',
      lineNote: '',
      accountName: '',
      lineCredit: '',
      lineDebit: '',
      year: ''),
];

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  late FocusNode myFocusNode;

  //generate the focus nodes for each entrybox
  final _focusNodes = List.generate(6, (_) => FocusNode());
  //generate the text controllers for each entrybox
  final _textControllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    rowCount = _data.length;
    colCount = 6;
    columnNodes = List.generate(
        rowCount, (_) => List.generate(colCount, (_) => FocusNode()),
        growable: true);
    controllers = List.generate(rowCount,
        (_) => List.generate(colCount, (_) => TextEditingController()),
        growable: true);
  }

//variables
  List<Data> _data = dataStore;

  late int colCount;
  late int rowCount;
  bool editState = true;
  bool downToAddRow = true;

  List<List<TextEditingController>> controllers = [];

  List<List<FocusNode>> columnNodes = [];

  // final ScrollController controller = ScrollController();
  // final ScrollController controller2 = ScrollController();
  // final ScrollController controller3 = ScrollController();

  void addRow() {
    setState(() {
      Data blankRow = Data(
          accountCode: '',
          lineNote: '',
          accountName: '',
          lineCredit: '',
          lineDebit: '',
          year: '');

      _data.add(blankRow);
      List<FocusNode> newNodes = List.generate(colCount, (_) => FocusNode());
      columnNodes.add(newNodes);
      List<TextEditingController> newControllers =
          List.generate(colCount, (_) => TextEditingController());
      controllers.add(newControllers);
      rowCount++;
    });
  }

  //final List mapKeys = ["account_name","account_code","line_note","line_credit","line_debit","year"];
  void search(String searchTerm) {
    // List<Map<String, dynamic>> newData = [];

    //bool match = false;
    _data = dataStore
        .where((e) =>
            e.accountCode.contains(searchTerm) ||
            e.accountName.contains(searchTerm) ||
            e.lineNote.contains(searchTerm) ||
            e.lineCredit.contains(searchTerm) ||
            e.lineDebit.contains(searchTerm) ||
            e.year.contains(searchTerm))
        .toList();

    // for (int i = 0; i < _data.length; i++) {

    //   // _data[i].forEach((key, value) {
    //   //   if (value == searchTerms[key]) {
    //   //     match = true;
    //   //   }
    //   //   // print('searchTerms[$key] = ${searchTerms[key]}');
    //   //   // print('value = $value');
    //   // });
    //   if (match == true) {
    //     newData.add(_data[i]);
    //   }
    //   match = false;
    // }
    setState(() {
      //print(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   // Define the default brightness and colors.
      //   brightness: Brightness.dark,
      //   primaryColor: Colors.lightBlue[800],
      //   secondaryHeaderColor: Colors.black,

      //   // Define the default font family.
      //   fontFamily: 'Georgia',

      //   // Define the default `TextTheme`. Use this to specify the default
      //   // text styling for headlines, titles, bodies of text, and more.
      //   // textTheme: const TextTheme(
      //   //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      //   //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //   //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      //   // ),
      // ),
      home: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.lightBlue[800],
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    returnText('Account'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    returnText('Accounting Notebooks'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    returnText('Tools'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    returnText('lorem'),
                  ],
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          title: Text(
            'Receipts table',
            style: textTheme.titleLarge,
          ),
          actions: [
            // ignore: avoid_unnecessary_containers
            Container(
              child: IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'user icon',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This is a snackbar')));
                },
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Profile",
                style: textTheme.titleMedium,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.more_vert,
                size: 26.0,
              ),
            ),
          ],
          actionsIconTheme: const IconThemeData(
            size: 30.0,
            color: Colors.white,
            opacity: 10.0,
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: Wrap(
                        //     alignment: WrapAlignment.start,
                        //     children: [
                        //       returnField('Account Name', //Journal number
                        //           (String data) {
                        //         print(data);
                        //         FocusScope.of(context)
                        //             .requestFocus(_focusNodes[1]);
                        //       }, _focusNodes[0], _textControllers[0]),
                        //       returnSpaceBetweenForms(),
                        //       returnField(
                        //         'Account Code', //Voucher explanation
                        //         (String data) {
                        //           print(data);
                        //           FocusScope.of(context)
                        //               .requestFocus(_focusNodes[2]);
                        //         },
                        //         _focusNodes[1], _textControllers[1],
                        //       ),
                        //       returnSpaceBetweenForms(),
                        //       returnField('Line Note', //Document Number
                        //           (String data) {
                        //         //change the data class
                        //         // setstate
                        //         //
                        //         print(data);
                        //         FocusScope.of(context)
                        //             .requestFocus(_focusNodes[3]);
                        //       }, _focusNodes[2], _textControllers[2]),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Tooltip(
                                  message:
                                      "This button is used to add a blank row",
                                  child: MaterialButton(
                                    //newbutton
                                    onPressed: () {
                                      key.currentState?.pageTo(rowCount);
                                      addRow();
                                    },
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(16),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.add,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      "Change the state of table from editable to disabled",
                                  child: MaterialButton(
                                    //editbutton
                                    onPressed: () {
                                      setState(() {
                                        editState = !editState;
                                      });
                                    },
                                    color: editState == true
                                        ? Colors.blue
                                        : Colors.blueGrey,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(16),
                                    shape: const CircleBorder(),
                                    child: editState == true
                                        ? const Icon(
                                            Icons.lock_open,
                                            size: 22,
                                          )
                                        : const Icon(
                                            Icons.lock,
                                            size: 22,
                                          ),
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      "reload the table to its original data",
                                  child: MaterialButton(
                                    //editbutton
                                    onPressed: () {
                                      setState(() {
                                        _data = dataStore;
                                      });
                                    },
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(16),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.replay_rounded,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      "Toggle down arrow to add a row at the end of the table",
                                  child: MaterialButton(
                                    //editbutton
                                    onPressed: () {
                                      setState(() {
                                        downToAddRow = !downToAddRow;
                                      });
                                      print(downToAddRow);
                                    },
                                    color: downToAddRow == true
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(16),
                                    shape: const CircleBorder(),
                                    child: const Icon(
                                      Icons.arrow_downward_outlined,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            returnField(
                                'search',
                                (String data) {
                                  search(data);
                                },
                                _focusNodes[0],
                                _textControllers[0],
                                (String data) {
                                  if (data.isEmpty) {
                                    setState(() {
                                      _data = dataStore;
                                    });
                                  }
                                }),
                            Tooltip(
                              message: "Keyword search",
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(90, 4),
                                ),
                                onPressed: () {
                                  String query = _textControllers[0].text;
                                  search(query);
                                },
                                child: const Text('submit'),
                              ),
                            ),
                          ],
                        ),

                        // Container(
                        //   height: 5,
                        //   width: 3,
                        //   color: Colors.red,
                        // ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                    //border: Border.all(width: 1),
                                    //ssscolor: null,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          offset: const Offset(0, 8),
                                          blurRadius: 7,
                                          spreadRadius: 3),
                                      // BoxShadow(
                                      //   offset: Offset(3, 0),
                                      //   color: Colors.red,
                                      // )
                                    ]),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomPaginatedDataTable(
                                          key: key,
                                          rowsPerPage: rowsPerPage,
                                          // header: SizedBox(
                                          //   height: 1,
                                          //   width: 9,
                                          // ),
                                          // actions: [
                                          //   SizedBox(
                                          //     width: 9,
                                          //     height: 9,
                                          //   )
                                          // ],
                                          availableRowsPerPage: const [
                                            5,
                                            10,
                                            50,
                                            100
                                          ],
                                          initialFirstRowIndex: 0,
                                          onPageChanged: (value) {
                                            setState(() {
                                              currentPage = value;
                                            });
                                          },
                                          onRowsPerPageChanged: (value) {
                                            setState(() {
                                              rowsPerPage = value!;
                                            });
                                          },
                                          columns: <DataColumn>[
                                            returnDatacolumn("Account name"),
                                            returnDatacolumn("Account code"),
                                            returnDatacolumn("Line note"),
                                            returnDatacolumn("Credit"),
                                            returnDatacolumn("Debit"),
                                            returnDatacolumn("Year"),
                                          ],
                                          source: MyData(
                                            _data,
                                            context,
                                            controllers,
                                            columnNodes,
                                            addRow,
                                            callback,
                                            editState,
                                            key,
                                            rowsPerPage,
                                            currentPage,
                                            downToAddRow,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row returnField(String title, Function(String)? onSubmitted, focusNode,
      textController, void Function(String)? onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        //   child: Text(
        //     title,
        //     style: textTheme.bodyMedium,
        //   ),
        // ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 80,
            maxWidth: 150,
            maxHeight: 30,
          ),
          child: TextField(
            controller: textController,
            onSubmitted: onSubmitted,
            obscureText: false,
            focusNode: focusNode,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 16,
              ),
              //   floatingLabelBehavior: FloatingLabelBehavior.never,
              //border: OutlineInputBorder(),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 30.0,
                  style: BorderStyle.none,
                ),
              ),
              hintText: title,
            ),
            style: textTheme.labelSmall,
          ),
        ),
      ],
    );
  }

  SizedBox returnSpaceBetweenForms() {
    return const SizedBox(
      width: 30,
    );
  }
}

DataColumn returnDatacolumn(String title) {
  return DataColumn(
    label: Text(
      title,
      style: textTheme.displayMedium?.copyWith(
        color: Colors.black,
      ),
    ),
  );
}

returnText(String name) {
  return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: MaterialButton(
        onPressed: () {},
        child: Text(
          name,
          style: textTheme.displayMedium,
        ),
      ),
    ),
  );
}
