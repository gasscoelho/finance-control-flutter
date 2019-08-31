import 'package:flutter/material.dart';

class CreateProducts extends StatefulWidget {
  @override
  _CreateProductsState createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  final controlType = TextEditingController();
  final controlDesc = TextEditingController();
  final controlValue = TextEditingController();
  var _type = 'C';

  void _setType(type){
    setState(() {
      _type = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
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

  void _saveProducts() {
    Map<String, dynamic> item = Map();
    item['id'] = TimeOfDay.now().toString();
    item['description'] = controlDesc.text;
    item['type'] = _type;
    item['value'] = controlValue.text;
    Navigator.pop(context, item);
  }
}
