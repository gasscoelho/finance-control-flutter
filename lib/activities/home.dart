import 'dart:convert';
import 'dart:io';
import 'package:finance_control/activities/create_products.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listExpenses = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Finance Control"),
          backgroundColor: Color(0xff4285F4),
        ),
        backgroundColor: Color(0xfff2f2f2),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _createProductsActivity();
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xff4285F4),
        ),
        body: ListView.builder(
          itemCount: _listExpenses.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: CheckboxListTile(
                  title: Text(
                      "${_listExpenses[index]['description']} - \$${_listExpenses[index]['value']} "),
                  onChanged: (bool) {},
                  value: false,
                  secondary: CircleAvatar(
                    child: (_listExpenses[index]['type']) == "C"
                        ? Icon(
                            Icons.add,
                            color: Color(0xffffffff),
                          )
                        : Icon(Icons.remove, color: Color(0xffffffff)),
                    backgroundColor: (_listExpenses[index]['type']) == "C"
                        ? Color(0xffF4B400)
                        : Color(0xffDB4437),
                  )),
            );
          },
        ));
  }

  void _createProductsActivity() async {
    final _products = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProducts()));
    if (_products != null) {
      _listExpenses.add(_products);
    }
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveItems() async {
    String data = json.encode(_listExpenses);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _loadItems() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
