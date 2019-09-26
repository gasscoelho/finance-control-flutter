import 'package:finance_control/helpers/transaction_helper.dart';
import 'package:finance_control/util/colors_arsenal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateProducts extends StatefulWidget {
  final Transaction transactionUpdate;
  CreateProducts({this.transactionUpdate});

  @override
  _CreateProductsState createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  final controlDesc = TextEditingController();
  final controlValue = TextEditingController();
  var _type = 'C';
  String _currentGroup;
  List<String> _listGroupCost = ['Courses', 'Food', 'Games', 'Transport'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  Transaction _transactionEdit;
  bool _controlEdit = false;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    _transactionEdit = widget.transactionUpdate;

    if (widget.transactionUpdate != null) {
      //Update product
      _transactionEdit = Transaction.fromMap(widget.transactionUpdate.toMap());
      controlDesc.text = _transactionEdit.description;
      controlValue.text = _transactionEdit.value.toString();
      _type = _transactionEdit.type;
      _currentGroup = _transactionEdit.group;
    } else {
      _transactionEdit = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _controlPop,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(_transactionEdit == null ? "Add Product" : "Update Product"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveProducts,
          child: Icon(
            Icons.check,
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    groupValue: _type,
                    value: 'C',
                    onChanged: _setType,
                  ),
                  Text('Credit'),
                  Radio(
                    groupValue: _type,
                    value: 'D',
                    onChanged: _setType,
                  ),
                  Text('Debit'),
                ],
              ),
              Container(
                width: double.infinity,
                child: DropdownButton(
                  underline: Container(color: Colors.grey, height: 1.0),
                  isExpanded: true,
                  value: _currentGroup,
                  items: _dropDownMenuItems,
                  onChanged: (v) {
                    _controlEdit = true;
                    setState(() {
                      _currentGroup = v;
                    });
                  },
                ),
              ),
              TextField(
                controller: controlDesc,
                onChanged: (input) {
                  _controlEdit = true;
                },
                decoration: InputDecoration(labelText: "Product"),
              ),
              TextField(
                controller: controlValue,
                onChanged: (input) {
                  _controlEdit = true;
                },
                decoration: InputDecoration(labelText: "Value"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setType(type) {
    _controlEdit = true;
    setState(() {
      _type = type;
    });
  }

  Future<bool> _controlPop() {
    if (_controlEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Warning'),
              content: Text(
                  'You haven\'t saved your changes. Are you sure you want to leave?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context); // Leave Alert
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context); // Leave Alert
                    Navigator.pop(context); // Leave Screen
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            );
          });
      debugPrint('Warning: data not saved!');
      return Future.value(false);
    }
    return Future.value(true);
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String i in _listGroupCost) {
      items.add(new DropdownMenuItem(value: i, child: new Text(i)));
    }
    return items;
  }

  void _saveProducts() async {
    Transaction t;
    TransactionHelper transactionHelper = TransactionHelper();
    Map<String, dynamic> item = Map();
    item[descriptionColumn] = controlDesc.text;
    item[typeColumn] = _type;
    item[valueColumn] = double.parse(controlValue.text);
    item[groupColumn] = _currentGroup;
    item[dateColumn] = DateFormat("dd-MM-yyyy").format(DateTime.now());

    if (_transactionEdit == null) {
      t = await transactionHelper.saveTransaction(Transaction.fromMap(item));
      debugPrint(t.toString());
      Fluttertoast.showToast(
          msg: "Item created!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          fontSize: 16.0);
      Navigator.pop(context, t.id != null ? true : false);
    } else {
      item[idColumn] = _transactionEdit.id;
      int i =
          await transactionHelper.updateTransaction(Transaction.fromMap(item));
      debugPrint(i.toString());
      Fluttertoast.showToast(
          msg: "Item updated!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          fontSize: 16.0);
      Navigator.pop(context, i != 0 ? true : false);
    }
  }
}
