import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String transacaoTable = "transacaoTable";
final String idColumn = "idColumn";
final String valorColumn = "valorColumn";
final String dataColumn = "dataColumn";
final String descricaoColumn = "descricaoColumn";
final String tipoColumn = "tipoColumn";
final String costCategoryColumn = "costCategoryColumn";

class TransactionHelper {

  static final TransactionHelper _instance = TransactionHelper.internal();

  factory TransactionHelper() => _instance;

  TransactionHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "financeControl.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $transacaoTable($idColumn INTEGER PRIMARY KEY, $valorColumn REAL, $descricaoColumn TEXT,"
            "$tipoColumn TEXT, $dataColumn TEXT, $costCategoryColumn TEXT)"
      );
    });
  }

  Future<Transaction> savetransacao(Transaction transacao) async {
    Database dbTransacao = await db;
    transacao.id = await dbTransacao.insert(transacaoTable, transacao.toMap());
    return transacao;
  }

  Future<Transaction> gettransacao(int id) async {
    Database dbTransacao = await db;
    List<Map> maps = await dbTransacao.query(transacaoTable,
      columns: [idColumn, valorColumn, descricaoColumn, tipoColumn, dataColumn, costCategoryColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
    if(maps.length > 0){
      return Transaction.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletetransacao(int id) async {
    Database dbTransacao = await db;
    return await dbTransacao.delete(transacaoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updatetransacao(Transaction transacao) async {
    Database dbTransacao = await db;
    return await dbTransacao.update(transacaoTable,
        transacao.toMap(),
        where: "$idColumn = ?",
        whereArgs: [transacao.id]);
  }

  Future<List> getAlltransacaos() async {
    Database dbTransacao = await db;
    List listMap = await dbTransacao.rawQuery("SELECT * FROM $transacaoTable");
    List<Transaction> listtransacao = List();
    for(Map m in listMap){
      listtransacao.add(Transaction.fromMap(m));
    }
    return listtransacao;
  }

  Future<int> getNumber() async {
    Database dbTransacao = await db;
    return Sqflite.firstIntValue(await dbTransacao.rawQuery("SELECT COUNT(*) FROM $transacaoTable"));
  }

  Future close() async {
    Database dbTransacao = await db;
    dbTransacao.close();
  }

}

class Transaction {
  int id;
  double valor;
  String data;
  String tipo;
  String descricao;
  String costCategory;

  Transaction();

  Transaction.fromMap(Map map){
    id = map[idColumn];
    valor = map[valorColumn];
    data = map[dataColumn];
    descricao = map[descricaoColumn];
    tipo = map[tipoColumn];
    costCategory = map[costCategoryColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      valorColumn: valor,
      dataColumn: data,
      descricaoColumn: descricao,
      tipoColumn: tipo,
      costCategoryColumn: costCategory
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "transacao(id: $id, valor: $valor, data: $data, descricao: $descricao, tipo: $tipo)";
  }

}