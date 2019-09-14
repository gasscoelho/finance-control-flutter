import 'package:finance_control/activities/create_products.dart';
import 'package:finance_control/helpers/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TransactionHelper transactionHelper = TransactionHelper();
  List<Transaction> _listExpenses = [];
  int _creditColor;
  int _debitColor;

  @override
  initState() {
    super.initState();
    loadData();
    setColorsButtons();
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
            _routeCreateProductsActivity();
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
                  child: (_listExpenses[index].type) == "C"
                      ? Icon(
                          Icons.add,
                          color: Color(0xffffffff),
                        )
                      : Icon(Icons.remove, color: Color(0xffffffff)),
                  backgroundColor: (_listExpenses[index].type) == "C"
                      ? Color(_creditColor)
                      : Color(_debitColor),
                ),
                title: Text(
                    "${_listExpenses[index].description} - \$${_listExpenses[index].value} "),
                onTap: () {
                  _routeCreateProductsActivity(item: _listExpenses[index]);
                },
              ),
            );
          },
        ));
  }

  void _routeCreateProductsActivity({Transaction item}) async {
    final _products = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateProducts(
                  transactionUpdate: item,
                )));
    if (_products) {
      loadData();
    }
  }

  void setColorsButtons() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getInt("creditColor") == null)
      sharedPreferences.setInt("creditColor", 0xffF4B400);

    if (sharedPreferences.getInt("debitColor") == null)
      sharedPreferences.setInt("debitColor", 0xffDB4437);

    _creditColor = sharedPreferences.getInt("creditColor");
    _debitColor = sharedPreferences.getInt("debitColor");
  }

  void loadData() {
    transactionHelper.getTransactions().then((list) {
      setState(() {
        _listExpenses = list;
      });
    });
  }
}
