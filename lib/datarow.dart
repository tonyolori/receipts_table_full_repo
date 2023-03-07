// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class DatarowClass extends StatefulWidget {
  const DatarowClass({Key? key}) : super(key: key);

  @override
  State<DatarowClass> createState() => _DatarowclassState();
}

class _DatarowclassState extends State<DatarowClass> {
  List<TextEditingController> controllers = [];

  List<FocusNode> nodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];

  var list = [
    {"id": 1, "age": 19, "name": "Mehmet"},
    {"id": 1, "age": 19, "name": "A"},
    {"id": 1, "age": 19, "name": "B"},
    {"id": 1, "age": 19, "name": "C"}
  ];
  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'AGE',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'ROLE',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: list
            .asMap()
            .map((key, value) => MapEntry(
                key,
                DataRow(cells: [
                  DataCell(TextFormField(
                    focusNode: nodes[key],
                    controller: TextEditingController()
                      ..text = value["id"].toString(),
                    onFieldSubmitted: (value) {
                      print('object');
                      // Key 3 < 4
                      if (key + 1 < list.length) {
                        FocusScope.of(context).requestFocus(nodes[key + 1]);
                      } else {
                        // create new row
                        // nodes.add(FocusNode());
                        // FocusScope.of(context).requestFocus(nodes[key + 1]);
                      }
                    },
                  )),
                  DataCell(TextFormField(
                    controller: TextEditingController()
                      ..text = value["age"].toString(),
                  )),
                  DataCell(TextFormField(
                    controller: TextEditingController()
                      ..text = value["name"].toString(),
                  )),
                ])))
            .values
            .toList());
  }
}
