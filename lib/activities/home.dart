import 'dart:convert';
import 'dart:io';
import 'package:finance_control/activities/create_products.dart';
import 'package:finance_control/helpers/transaction_helper.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TransactionHelper transactionHelper = TransactionHelper();
  List<Transaction> _listExpenses = [];

  @override
  initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    transactionHelper.getAlltransacaos().then((list) {
      setState(() {
        _listExpenses = list;
      });
    });
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
              child: ListTile(
                  leading: CircleAvatar(
                    child: (_listExpenses[index].tipo) == "C"
                        ? Icon(
                            Icons.add,
                            color: Color(0xffffffff),
                          )
                        : Icon(Icons.remove, color: Color(0xffffffff)),
                    backgroundColor: (_listExpenses[index].tipo) == "C"
                        ? Color(0xffF4B400)
                        : Color(0xffDB4437),
                  ),
                  title: Text(
                      "${_listExpenses[index].descricao} - \$${_listExpenses[index].valor} "),
                  onTap: (){
                    _createProductsActivity(item: _listExpenses[index]);
                  },
                  ),
            );
          },
        ));
  }

  void _createProductsActivity({Transaction item}) async {
    final _products = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateProducts(transactionUpdate: item,)));

    if (_products) {
      loadData();
    }
    /*if (_products != null) {
      _listExpenses.add(_products);
    }*/
  }

}
