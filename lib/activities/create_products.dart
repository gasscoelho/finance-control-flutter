import 'package:finance_control/helpers/transaction_helper.dart';
import 'package:flutter/material.dart';
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
  String _currentCost;
  List<String> _listCost = ['Courses', 'Food', 'Games', 'Transport'];
  List<DropdownMenuItem<String>> _dropDownMenuItems;

  void _setType(type) {
    setState(() {
      _type = type;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String i in _listCost) {
      items.add(new DropdownMenuItem(value: i, child: new Text(i)));
    }
    return items;
  }

  Transaction _transactionEdit;

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCost = _dropDownMenuItems[0].value;

    _transactionEdit = widget.transactionUpdate;

    if (widget.transactionUpdate != null) {
      //Update
      _transactionEdit = Transaction.fromMap(widget.transactionUpdate.toMap());
      controlDesc.text = _transactionEdit.descricao;
      controlValue.text = _transactionEdit.valor.toString();
      _type = _transactionEdit.tipo;
      _currentCost = _transactionEdit.costCategory;
    } else {
      _transactionEdit = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_transactionEdit == null ? "Add Product" : "Update Product"),
        backgroundColor: Color(0xff4285F4),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveProducts,
        child: Icon(Icons.check),
      ),
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Row(
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
                isExpanded: true,
                value: _currentCost,
                items: _dropDownMenuItems,
                onChanged: (v) {
                  setState(() {
                    _currentCost = v;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                controller: controlDesc,
                decoration: InputDecoration(labelText: "Product"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                controller: controlValue,
                decoration: InputDecoration(labelText: "Value"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProducts() async {
    TransactionHelper transactionHelper = TransactionHelper();
    Map<String, dynamic> item = Map();
//    item[idColumn] = TimeOfDay.now().toString();
    item[descricaoColumn] = controlDesc.text;
    item[tipoColumn] = _type;
    item[valorColumn] = double.parse(controlValue.text);
    item[costCategoryColumn] = _currentCost;
    item[dataColumn] = DateFormat("dd-MM-yyyy").format(DateTime.now());

    Transaction t;
    if (_transactionEdit == null) {
      t = await transactionHelper.savetransacao(Transaction.fromMap(item));
      debugPrint(t.toString());
    Navigator.pop(context, t.id != null ? true : false);
    } else {
      item[idColumn] = _transactionEdit.id;
      int i = await transactionHelper.updatetransacao(Transaction.fromMap(item));   
      debugPrint(i.toString());
    Navigator.pop(context, i != 0 ? true : false);
    }
  }
}
