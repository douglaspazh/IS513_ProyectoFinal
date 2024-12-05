import 'package:money_app/models/account.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_app/models/transaction.dart';

class DBHelper {
  static const String _databaseName = 'transactions.db';
  static const int _databaseVersion = 1;
  static const String _transactionsTableName = 'transactions';
  static const String _accountsTableName = 'accounts';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

// Creación de la tabla de cuentas
  Future<void> _createAccountsTable(Database db) async {
    await db.execute('''
      CREATE TABLE accounts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 0
      )
    ''');
  }

  // Creación de la tabla de transacciones
  Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        isIncome INTEGER NOT NULL,
        accountId INTEGER NOT NULL,
        FOREIGN KEY (accountId) REFERENCES accounts (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createAccountsTable(db);
    await _createTransactionsTable(db);

    // Crear cuenta principal como cuenta por defecto
    await db.insert('accounts', Account(name: 'Principal', balance: 0).toMap());
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Account> getDefaulAccount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return Account.fromMap(maps.first);
  }


  // CRUD para la tabla de transacciones
  Future<TransactionData> getTransaction(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
    return TransactionData.fromMap(maps.first);
  }

  Future<int> insertTransaction(TransactionData transaction) async {
    final Database db = await database;
    final defaultAccount = await getDefaulAccount();

    if (defaultAccount.id != null) {
      transaction = TransactionData(
        id: transaction.id,
        amount: transaction.amount,
        category: transaction.category,
        date: transaction.date,
        description: transaction.description,
        isIncome: transaction.isIncome,
        accountId: defaultAccount.id!
      );
    }
    return await db.insert(_transactionsTableName, transaction.toMap());
  }

  Future<List<TransactionData>> getAllTransactions() async {
    final Database db = await database;
    List<Map<String, dynamic>> result = await db.query(_transactionsTableName);
    return result.map((e) => TransactionData.fromMap(e)).toList();
  }

  Future<List<TransactionData>> getTransactionsByAccount(int accountId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTableName,
      where: 'accountId = ?',
      whereArgs: [accountId],
    );
    return List.generate(maps.length, (i) => TransactionData.fromMap(maps[i]));
  }

  Future<int> updateTransaction(TransactionData transaction) async {
    final Database db = await database;
    return await db.update(
      _transactionsTableName,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final Database db = await database;
    return await db.delete(
      _transactionsTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }


  // CRUD para la tabla de cuentas
  Future<Account> getAccount(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _accountsTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
    return Account.fromMap(maps.first);
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_accountsTableName);
    return List.generate(maps.length, (i) => Account.fromMap(maps[i]));
  }

  Future<int> insertAccount(Account account) async {
    final db = await database;
    return await db.insert('accounts', account.toMap());
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;
    return await db.update(
      _accountsTableName,
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id]
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await database;
    return await db.delete(
      _accountsTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}
