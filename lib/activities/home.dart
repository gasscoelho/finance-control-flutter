import 'dart:convert';
import 'dart:io';
import 'package:finance_control/activities/create_products.dart';
import 'package:finance_control/helpers/transaction_helper.dart';
import 'package:finance_control/util/colors_arsenal.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging _fbm = FirebaseMessaging();
  @override
  initState() {
    super.initState();
    loadData(); //load data from local database
    setColorsButtons(); //change item color (list items)
    //debugPrint(getResultAPI().toString());
    _registerDevice();
    _fbm.configure(
      onMessage: (Map<String, dynamic> msg) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(msg['notification']['title']),
              subtitle: Text(msg['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        );
      },
      onLaunch: (Map<String, dynamic> msg) async {print(msg);},
      onResume: (Map<String, dynamic> msg) async {print(msg);},
    );
  }

  _registerDevice() async{
    String token = await _fbm.getToken();
    if (Platform.isIOS) {
      _fbm.onIosSettingsRegistered.listen((data) {
        _fbm.subscribeToTopic('ios');
      });
      _fbm.requestNotificationPermissions(IosNotificationSettings());
    } else if (Platform.isAndroid) {
      _fbm.subscribeToTopic('android');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              children: <Widget>[
                FutureBuilder(
                  //this block is not being used (don't reflect on screen)
                  future: getResultAPI(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Text(''); //waiting ...
                        break;
                      default:
                        if (snapshot.hasError) {
                          return Text(''); //error loading data from api
                        } else {
                          return Text('');
                          //return Text(snapshot.data["data"]["last"].toString());
                        }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listExpenses.length,
              itemBuilder: _buildItem,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
            child: _buildFloatActionButton(),
          )
        ],
      ),
    );
  }

  Widget _buildFloatActionButton() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
            visible: _isVisibleFloatButton,
            child: FloatingActionButton(
              onPressed: () async {
                //await _loogIn();
                _updatedUICreateProduct();
              },
              backgroundColor: ColorsArsenal.primaryColor,
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(context, index) {
    final _item = ListTile(
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
        _updatedUICreateProduct(item: _listExpenses[index]);
      },
      onLongPress: () {
        _menu(context, index);
      },
    );

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

        final _snack = SnackBar(
          content:
              Text('${_tempExpenses.description} was sucessfully removed.'),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                //TODO: Change to BLoC
                _listExpenses.insert(_tempIndex, _tempExpenses);
                transactionHelper.saveTransaction(_tempExpenses);
              });
            },
          ),
        );

        transactionHelper.deleteTransaction(_listExpenses[index].id);
        _listExpenses.removeAt(index);

        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(_snack);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: _item,
      ),
    );
  }

  void _menu(context, index) {
    setState(() {
      //TODO: Change to Bloc
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
                            //TODO: change to bloc
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
    });
  }

  void _updatedUICreateProduct({Transaction item}) async {
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
