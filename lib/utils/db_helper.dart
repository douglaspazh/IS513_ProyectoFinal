import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_app/models/transaction.dart';

class DBHelper {
  static const String _databaseName = 'transactions.db';
  static const String _tableName = 'transactions';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        isIncome INTEGER NOT NULL
      )
    ''');
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<int> insertTransaction(TransactionData transaction) async {
    Database db = await database;
    return await db.insert(_tableName, transaction.toMap());
  }

  Future<List<TransactionData>> fetchTransactions() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(_tableName);
    return result.map((e) => TransactionData.fromMap(e)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
