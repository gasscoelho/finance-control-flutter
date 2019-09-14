import 'dart:convert';

import 'package:finance_control/activities/create_products.dart';
import 'package:finance_control/helpers/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const url = 'https://api.bitcointrade.com.br/v2/public/BRLBTC/ticker';

Future<Map> getResultAPI() async {
  var response = await http.get(url);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TransactionHelper transactionHelper = TransactionHelper();
  List<Transaction> _listExpenses = [];
  int _creditColor;
  int _debitColor;
  bool _isVisibleFloatButton = true;
  int _tempIndex;
  Transaction _tempExpenses;
  dynamic text;

  @override
  initState() {
    super.initState();
    loadData();
    setColorsButtons();
    debugPrint(getResultAPI().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finance Control"),
        backgroundColor: Color(0xff4285F4),
      ),
      backgroundColor: Color(0xfff2f2f2),
      floatingActionButton: Visibility(
        visible: _isVisibleFloatButton,
        child: FloatingActionButton(
          onPressed: () {
            _routeCreateProductsActivity();
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xff4285F4),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Row(
              children: <Widget>[
                FutureBuilder(
                  future: getResultAPI(),
                  builder: (context,snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Text('Waiting...');
                        break;
                      default:
                        if (snapshot.hasError) {
                          return Text('Error loading data from API');
                        } else {
                          return Text(snapshot.data["data"]["last"].toString());
                        }
                    }
                  },
                ),
                Text('BTC')
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listExpenses.length,
              itemBuilder: _buildItem,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(0.9, 0),
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        _tempExpenses = _listExpenses[index];
        _tempIndex = index;

        transactionHelper.deleteTransaction(_listExpenses[index].id);
        _listExpenses.removeAt(index);

        final _snack = SnackBar(
          content:
              Text('${_tempExpenses.description} was sucessfully removed.'),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _listExpenses.insert(_tempIndex, _tempExpenses);
                transactionHelper.saveTransaction(_tempExpenses);
              });
            },
          ),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(_snack);
      },
      child: Padding(
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
          onLongPress: () {
            _menu(context, index);
          },
        ),
      ),
    );
  }

  void _menu(context, index) {
    setState(() {
      _isVisibleFloatButton = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text('Share'),
                        onPressed: () {
                          Share.share(
                              "${_listExpenses[index].description} - \$${_listExpenses[index].value} ");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        child: Text('Some text'),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isVisibleFloatButton = true;
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        }).then((value) {
      setState(() {
        _isVisibleFloatButton = true;
      });
      debugPrint('CLOSED');
    });

    debugPrint('Closed ' + _isVisibleFloatButton.toString()); // Closed true
    _listExpenses[index].description;
    debugPrint('Closed $_isVisibleFloatButton');
  }

  void _routeCreateProductsActivity({Transaction item}) async {
    final _products = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateProducts(
                  transactionUpdate: item,
                )));
    if (_products != null && _products == true) {
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
