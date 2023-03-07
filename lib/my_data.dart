import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'paginated/paginated_data_table.dart';
import 'data_store.dart';

//outside
// int rowsPerPage = 10;

class MyData extends DataTableSource {
  // Generate some made-up data

  MyData(
    this.data,
    this.context,
    this.controllers,
    this.nodes,
    this.addRow,
    this.callback,
    this.enabledState,
    this.key,
    this.rowsPerPage,
    this.currentPage,
    this.downToAddRow,
  ) {
    row_count = data.length;
    colCount = 6;
  }
  final void Function() callback;
  final void Function() addRow;
  final GlobalKey<CustomPaginatedDataTableState> key;
  late int row_count;
  late int colCount;
  late int rowsPerPage;
  late int currentPage;
  bool enabledState;
  bool downToAddRow;
  final List<Data> data;
  final BuildContext context;
  final List<List<TextEditingController>> controllers;
  final List<List<FocusNode>> nodes;
  // final List<List<FocusNode>> keyboardNodes;

  returnTextFormField(
    int rowIndex,
    int columIndex,
    String txt,
    enabledState,
  ) {
    TextEditingController nextController;
    FocusNode futureNode;
    TextEditingController currentController = controllers[rowIndex][columIndex];
    FocusNode currentNode = nodes[rowIndex][columIndex];
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) async {
        // arrow up
        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          // set the target controller and node
          if (rowIndex > 0) {
            nextController = controllers[rowIndex - 1][columIndex];
            futureNode = nodes[rowIndex - 1][columIndex];
          } else {
            nextController = controllers[rowIndex][columIndex];
            futureNode = nodes[rowIndex][columIndex];
          }

          // handles the most frequent case, move up if not at the start of a row
          if (rowIndex % rowsPerPage != 0) {
            futureNode.requestFocus();
          }
          //move to previous page if at the start of a page and up pressed
          else {
            //if not at the begining of the table then change pages
            if (rowIndex != 0) {
              futureNode = nodes[rowIndex - 1][colCount - 1];
              currentNode.unfocus();
              key.currentState?.pageTo(currentPage - rowsPerPage);
              futureNode.requestFocus();
            }
          }
          // set the selection to the end of the text after a delay
          await Future.delayed(const Duration(milliseconds: 10));
          nextController.selection = TextSelection(
              baseOffset: 0, extentOffset: nextController.text.length);
        }
        // arrow down
        else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          if ((rowIndex + 1) == data.length && downToAddRow == true) {
            //check if the textfields are empty before adding a new row
            if (controllers[rowIndex][0].text.isNotEmpty &&
                controllers[rowIndex][1].text.isNotEmpty &&
                controllers[rowIndex][3].text.isNotEmpty &&
                controllers[rowIndex][4].text.isNotEmpty &&
                controllers[rowIndex][5].text.isNotEmpty) {
              addRow();
            }
          }
          // set the target controller and node for each condition
          if ((rowIndex + 1) < data.length) {
            nextController = controllers[rowIndex + 1][columIndex];
            futureNode = nodes[rowIndex + 1][columIndex];
          } else {
            nextController = controllers[rowIndex][columIndex];
            futureNode = nodes[rowIndex][columIndex];
          }

          //handles the most frequent case, move down if not at the end of a row
          if ((rowIndex + 1) % rowsPerPage != 0) {
            futureNode.requestFocus();
          }
          //move to next page if at the end of a page and down pressed
          else {
            futureNode = nodes[rowIndex + 1][0];
            currentNode.unfocus();
            key.currentState?.pageTo(currentPage + rowsPerPage);
            futureNode.requestFocus();
          }

          // set the selection to the end of the text after a delay
          await Future.delayed(const Duration(milliseconds: 10));
          nextController.selection = TextSelection(
              baseOffset: 0, extentOffset: nextController.text.length);
        }
        //arrow left
        else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          // set the target controller and node
          if (columIndex > 0) {
            nextController = controllers[rowIndex][columIndex - 1];
            futureNode = nodes[rowIndex][columIndex - 1];
          } else {
            nextController = controllers[rowIndex][columIndex];
            futureNode = nodes[rowIndex][columIndex];
          }
          //handles the most frequent case, move left if not at the start of a column
          if (columIndex != 0) {
            futureNode.requestFocus();
          }
          //if at the begining of the column
          else {
            //move up and to the last column if not at the top of the table
            if (rowIndex != 0) {
              nextController = controllers[rowIndex - 1][colCount - 1];
              futureNode = nodes[rowIndex - 1][colCount - 1];
              futureNode.requestFocus();
            }
            //? change pages if at the begining of a row
          }
          // set the selection to the end of the text after a delay

          await Future.delayed(const Duration(milliseconds: 10));
          nextController.selection = TextSelection(
              baseOffset: 0, extentOffset: nextController.text.length);
        }
        //arrow right
        else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          // set the target controller and node
          if ((columIndex + 1) < colCount) {
            nextController = controllers[rowIndex][columIndex + 1];
            futureNode = nodes[rowIndex][columIndex + 1];
          } else {
            nextController = controllers[rowIndex][columIndex];
            futureNode = nodes[rowIndex][columIndex];
          }
          //handles the most frequent case, move right if not at the end of the columns
          if ((columIndex + 1) < colCount) {
            futureNode.requestFocus();
          }
          //if at the end of the column
          else {
            //move down and to the first row if not at the bottom of the table
            if ((rowIndex + 1) % rowsPerPage != 0) {
              nextController = controllers[rowIndex + 1][0];
              futureNode = nodes[rowIndex + 1][0];
              futureNode.requestFocus();
            }
            //? change pages if at the end of a row
          }
          // set the selection to the end of the text after a delay

          await Future.delayed(const Duration(milliseconds: 10));
          nextController.selection = TextSelection(
              baseOffset: 0, extentOffset: nextController.text.length);
        }
      },
      child: TextFormField(
          maxLength: 20,
          focusNode: currentNode,
          controller: currentController..text = txt.toString(),
          enabled: enabledState,
          //maxLength: 30,
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          decoration: InputDecoration(
            counterText: '',
            border: enabledState == true
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 16.0, color: Colors.lightBlue.shade900),
                  )
                : InputBorder.none,
          ),
          onFieldSubmitted: (value) async {
            //if not at end of the column then go the next column
            if (columIndex + 1 < colCount) {
              nodes[rowIndex][columIndex + 1].requestFocus();
            }
            //if at the last column and this is not the last row in the database
            else if (columIndex + 1 == colCount && rowIndex + 1 < row_count) {
              //if this is the last row in the page
              if ((rowIndex + 1) % rowsPerPage == 0) {
                key.currentState?.pageTo(currentPage + rowsPerPage);
              }
              nodes[rowIndex + 1][0].requestFocus();
            }
            //if there are no more rows in the database
            else {
              //if the current row is at the end of the page go to new page
              if (data.length % rowsPerPage == 0) {
                key.currentState?.pageTo(currentPage + rowsPerPage);
              }
              if (controllers[rowIndex][0].text.isNotEmpty) {
                addRow();
                nodes[rowIndex + 1][0].requestFocus();
              }
            }
          }),
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(returnTextFormField(
        index,
        0,
        data[index].accountName.toString(),
        enabledState,
      )),
      DataCell(returnTextFormField(
        index,
        1,
        data[index].accountCode.toString(),
        enabledState,
      )),
      DataCell(returnTextFormField(
        index,
        2,
        data[index].lineNote.toString(),
        enabledState,
      )),
      DataCell(returnTextFormField(
        index,
        3,
        data[index].lineCredit.toString(),
        enabledState,
      )),
      DataCell(returnTextFormField(
        index,
        4,
        data[index].lineDebit.toString(),
        enabledState,
      )),
      DataCell(returnTextFormField(
        index,
        5,
        data[index].year.toString(),
        enabledState,
      )),
    ]);
  }
}


























//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS
//? USING THE OLD METHOD OF A LIST OF MAPS

//? USING THE OLD METHOD OF A LIST OF MAPS

// class MyData extends DataTableSource {
//   // Generate some made-up data

//   MyData(
//     this.data,
//     this.context,
//     this.controllers,
//     this.nodes,
//     this.addRow,
//     this.callback,
//     this.enabledState,
//     this.key,
//   ) {
//     row_count = data.length;
//     colCount = 6;
//   }
//   final void Function() callback;
//   final void Function() addRow;
//   final GlobalKey<CustomPaginatedDataTableState> key;
//   late int row_count;
//   late int colCount;
//   bool enabledState;
//   final List<Map<String, dynamic>> data;
//   final BuildContext context;
//   final List<List<TextEditingController>> controllers;
//   final List<List<FocusNode>> nodes;
//   // final List<List<FocusNode>> keyboardNodes;

//   returnTextFormField(
//     int rowIndex,
//     int columIndex,
//     String txt,
//     enabledState,
//   ) {
//     TextEditingController nextController;
//     FocusNode futureNode;
//     TextEditingController currentController = controllers[rowIndex][columIndex];
//     FocusNode currentNode = nodes[rowIndex][columIndex];
//     return RawKeyboardListener(
//       focusNode: FocusNode(),
//       onKey: (event) async {
//         // arrow up
//         if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
//           // set the target controller and node
//           if (rowIndex > 0) {
//             nextController = controllers[rowIndex - 1][columIndex];
//             futureNode = nodes[rowIndex - 1][columIndex];
//           } else {
//             nextController = controllers[rowIndex][columIndex];
//             futureNode = nodes[rowIndex][columIndex];
//           }

//           // handles the most frequent case, move up if not at the start of a row
//           if (rowIndex % rowsPerPage != 0) {
//             futureNode.requestFocus();
//           }
//           //move to previous page if at the start of a page and up pressed
//           else {
//             //if not at the begining of the table then change pages
//             if (rowIndex != 0) {
//               futureNode = nodes[rowIndex - 1][colCount - 1];
//               nodes[rowIndex][columIndex].unfocus();
//               key.currentState?.pageTo(currentPage - rowsPerPage);
//               futureNode.requestFocus();
//             }
//           }
//           // // set the selection to the end of the text after a delay
//           await Future.delayed(const Duration(milliseconds: 10));
//           nextController.selection = TextSelection(
//               baseOffset: 0, extentOffset: nextController.text.length);
//         }
//         // arrow down
//         else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
//           // set the target controller and node for each condition
//           if ((rowIndex + 1) < data.length) {
//             nextController = controllers[rowIndex + 1][columIndex];
//             futureNode = nodes[rowIndex + 1][columIndex];
//           } else {
//             nextController = controllers[rowIndex][columIndex];
//             futureNode = nodes[rowIndex][columIndex];
//           }

//           //handles the most frequent case, move down if not at the end of a row
//           if ((rowIndex + 1) % rowsPerPage != 0) {
//             futureNode.requestFocus();
//           }
//           //move to next page if at the end of a page and down pressed
//           else {
//             futureNode = futureNode = nodes[rowIndex + 1][0];
//             nodes[rowIndex][columIndex].unfocus();
//             key.currentState?.pageTo(currentPage + rowsPerPage);
//             futureNode.requestFocus();
//           }

//           // set the selection to the end of the text after a delay
//           await Future.delayed(const Duration(milliseconds: 10));
//           nextController.selection = TextSelection(
//               baseOffset: 0, extentOffset: nextController.text.length);
//         }
//         //arrow left
//         else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
//           // set the target controller and node
//           if (columIndex > 0) {
//             nextController = controllers[rowIndex][columIndex - 1];
//             futureNode = nodes[rowIndex][columIndex - 1];
//           } else {
//             nextController = controllers[rowIndex][columIndex];
//             futureNode = nodes[rowIndex][columIndex];
//           }
//           //handles the most frequent case, move left if not at the start of a column
//           if (columIndex != 0) {
//             futureNode.requestFocus();
//           }
//           //if at the begining of the column
//           else {
//             //move up and to the last column if not at the top of the table
//             if (rowIndex != 0) {
//               nextController = controllers[rowIndex - 1][colCount - 1];
//               futureNode = nodes[rowIndex - 1][colCount - 1];
//               futureNode.requestFocus();
//             }
//             //? change pages if at the begining of a row
//           }
//           // set the selection to the end of the text after a delay
//           // if not at the begininng of a page
//           if ((rowIndex + 1) % rowsPerPage != 0) {
//             await Future.delayed(const Duration(milliseconds: 10));
//             nextController.selection = TextSelection(
//                 baseOffset: 0, extentOffset: nextController.text.length);
//           } //else {
//           //   await Future.delayed(Duration(milliseconds: 10));
//           //   nextController.selection =
//           //       TextSelection(baseOffset: 0, extentOffset: 0);
//           // }
//         }
//         //arrow right
//         else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
//           // set the target controller and node
//           if ((columIndex + 1) < colCount) {
//             nextController = controllers[rowIndex][columIndex + 1];
//             futureNode = nodes[rowIndex][columIndex + 1];
//           } else {
//             nextController = controllers[rowIndex][columIndex];
//             futureNode = nodes[rowIndex][columIndex];
//           }
//           //handles the most frequent case, move right if not at the end of the columns
//           if ((columIndex + 1) < colCount) {
//             futureNode.requestFocus();
//           }
//           //if at the end of the column
//           else {
//             //move down and to the first row if not at the bottom of the table
//             if ((rowIndex + 1) % rowsPerPage != 0) {
//               nextController = controllers[rowIndex + 1][0];
//               futureNode = nodes[rowIndex + 1][0];
//               futureNode.requestFocus();
//             }
//             //? change pages if at the end of a row
//           }
//           // set the selection to the end of the text after a delay
//           // if not at the end of a page
//           if ((rowIndex + 1) % rowsPerPage != 0) {
//             await Future.delayed(const Duration(milliseconds: 10));
//             nextController.selection = TextSelection(
//                 baseOffset: 0, extentOffset: nextController.text.length);
//           } //else {
//           //   await Future.delayed(Duration(milliseconds: 10));
//           //   nextController.selection = TextSelection(
//           //       baseOffset: nextController.text.length,
//           //       extentOffset: nextController.text.length);
//           // }
//         }
//       },
//       child: TextFormField(
//           maxLength: 20,
//           focusNode: currentNode,
//           controller: currentController..text = txt.toString(),
//           enabled: enabledState,
//           //maxLength: 30,
//           maxLengthEnforcement:
//               MaxLengthEnforcement.truncateAfterCompositionEnds,
//           decoration: InputDecoration(
//             counterText: '',
//             border: enabledState == true
//                 ? UnderlineInputBorder(
//                     borderSide: BorderSide(
//                         width: 16.0, color: Colors.lightBlue.shade900),
//                   )
//                 : InputBorder.none,
//           ),
//           onFieldSubmitted: (value) async {
//             //if not at end of the column then go the next column
//             if (columIndex + 1 < colCount) {
//               nodes[rowIndex][columIndex + 1].requestFocus();
//             }
//             //if at the last column and this is not the last row in the database
//             else if (columIndex + 1 == colCount && rowIndex + 1 < row_count) {
//               //if this is the last row in the page
//               if ((rowIndex + 1) % rowsPerPage == 0) {
//                 key.currentState?.pageTo(currentPage + rowsPerPage);
//               }
//               nodes[rowIndex + 1][0].requestFocus();
//             }
//             //if there are no more rows in the database
//             else {
//               //if the current row is at the end of the page go to new page
//               if (data.length % rowsPerPage == 0) {
//                 key.currentState?.pageTo(currentPage + rowsPerPage);
//               }

//               addRow();
//               nodes[rowIndex + 1][0].requestFocus();
//             }
//           }),
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;
//   @override
//   int get rowCount => data.length;
//   @override
//   int get selectedRowCount => 0;
//   @override
//   DataRow getRow(int index) {
//     return DataRow(cells: [
//       DataCell(returnTextFormField(
//         index,
//         0,
//         data[index]["account_name"].toString(),
//         enabledState,
//       )),
//       DataCell(returnTextFormField(
//         index,
//         1,
//         data[index]["account_code"].toString(),
//         enabledState,
//       )),
//       DataCell(returnTextFormField(
//         index,
//         2,
//         data[index]["line_note"].toString(),
//         enabledState,
//       )),
//       DataCell(returnTextFormField(
//         index,
//         3,
//         data[index]["line_credit"].toString(),
//         enabledState,
//       )),
//       DataCell(returnTextFormField(
//         index,
//         4,
//         data[index]["line_debit"].toString(),
//         enabledState,
//       )),
//       DataCell(returnTextFormField(
//         index,
//         5,
//         data[index]["year"].toString(),
//         enabledState,
//       )),
//     ]);
//   }
// }
