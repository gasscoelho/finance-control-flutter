import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String transactionTable = "transactionTable";
final String idColumn = "idColumn";
final String valueColumn = "valueColumn";
final String dateColumn = "dateColumn";
final String descriptionColumn = "descriptionColumn";
final String typeColumn = "typeColumn";
final String groupColumn = "groupColumn";

class TransactionHelper {
  static final TransactionHelper _instance = TransactionHelper.internal();
  factory TransactionHelper() => _instance;
  TransactionHelper.internal();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initializeDatabase();
      return _database;
    }
  }

  Future<Database> initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "financeControl.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database databse, int newerVersion) async {
      await databse.execute(
          "CREATE TABLE $transactionTable($idColumn INTEGER PRIMARY KEY, $valueColumn REAL, $descriptionColumn TEXT,"
          "$typeColumn TEXT, $dateColumn TEXT, $groupColumn TEXT)");
    });
  }

  Future<Transaction> saveTransaction(Transaction transaction) async {
    Database databaseTransaction = await database;
    transaction.id =
        await databaseTransaction.insert(transactionTable, transaction.toMap());

    //TODO: THIS COMMAND LINE WILL BE REMOVE IN THE FUTURE [FIREBASE]
    /*
    item[descriptionColumn] = controlDesc.text;
    item[typeColumn] = _type;
    item[valueColumn] = double.parse(controlValue.text);
    item[groupColumn] = _currentGroup;
    item[dateColumn] = DateFormat("dd-MM-yyyy").format(DateTime.now());
    */
    Firestore.instance.collection('dados').document().setData(
      {
        'descriptionColumn': transaction.description,
        'typeColumn': transaction.type,
        'valueColumn': transaction.value,
        'groupColumn': transaction.group,
        'dateColumn': transaction.date
      },
    );

    return transaction;
  }

  Future<Transaction> getTransaction(int id) async {
    Database databaseTransaction = await database;
    List<Map> maps = await databaseTransaction.query(transactionTable,
        columns: [
          idColumn,
          valueColumn,
          descriptionColumn,
          typeColumn,
          dateColumn,
          groupColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Transaction.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteTransaction(int id) async {
    Database databaseTransaction = await database;
    return await databaseTransaction
        .delete(transactionTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateTransaction(Transaction transacao) async {
    Database dbTransacao = await database;
    return await dbTransacao.update(transactionTable, transacao.toMap(),
        where: "$idColumn = ?", whereArgs: [transacao.id]);
  }

  Future<List> getTransactions() async { 
    Database databaseTransaction = await database;
    List listMap =
        await databaseTransaction.rawQuery("SELECT * FROM $transactionTable");
    List<Transaction> listTransaction = List();
    for (Map m in listMap) {
      listTransaction.add(Transaction.fromMap(m));
    }

    //TO DELETE IN THE FUTURE

    Firestore.instance.collection('dados').getDocuments().then((snapshot){
      snapshot.documents.forEach((result){
        print(result['descriptionColumn']);
        print(result['typeColumn']);
        print(result['valueColumn']);
        print(result['groupColumn']);
        print(result['dateColumn']);
      });
    });
    return listTransaction;
  }

  Future<int> getCount() async {
    Database databaseTransaction = await database;
    return Sqflite.firstIntValue(await databaseTransaction
        .rawQuery("SELECT COUNT(*) FROM $transactionTable"));
  }

  Future close() async {
    Database databaseTransaction = await database;
    databaseTransaction.close();
  }
}

class Transaction {
  int id;
  double value;
  String date;
  String type;
  String description;
  String group;

  Transaction();

  Transaction.fromMap(Map map) {
    id = map[idColumn];
    value = map[valueColumn];
    date = map[dateColumn];
    description = map[descriptionColumn];
    type = map[typeColumn];
    group = map[groupColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      valueColumn: value,
      dateColumn: date,
      descriptionColumn: description,
      typeColumn: type,
      groupColumn: group
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "transaction(id: $id, value: $value, date: $date, description: $description, type: $type)";
  }
}
