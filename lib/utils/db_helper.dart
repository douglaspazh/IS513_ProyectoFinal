import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/models/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:money_app/models/transaction.dart';

class DBHelper {
  static const String _databaseName = 'money_app.db';
  static const int _databaseVersion = 1;
  static const String _transactionsTableName = 'transactions';
  static const String _accountsTableName = 'accounts';
  static const String _categoriesTableName = 'categories';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

// Creación de la tabla de cuentas
  Future<void> _createAccountsTable(Database db) async {
    await db.execute('''
      CREATE TABLE accounts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        balance REAL NOT NULL DEFAULT 0,
        currency TEXT NOT NULL,
        iconCode TEXT NOT NULL,
        iconColor INTEGER NOT NULL,
        description TEXT
      )
    ''');
  }

  // Creación de la tabla de categorías
  Future<void> _createCategoriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        iconCode TEXT NOT NULL,
        iconColor INTEGER NOT NULL,
        description TEXT
      )
    ''');
  }

  // Creación de la tabla de transacciones
  Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        categoryId INTEGER NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        isIncome BOOLEAN NOT NULL,
        accountId INTEGER NOT NULL,
        FOREIGN KEY (accountId) REFERENCES accounts (id) ON DELETE CASCADE,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _createDefaultData(Database db) async {
    // Crear cuentas por defecto
    await db.insert('accounts', Account(
      name: 'Ahorros',
      balance: 0,
      currency: 'HNL',
      iconCode: 'money_bag',
      iconColor: Colors.green[300]!.value
    ).toMap());
    await db.insert('accounts', Account(
      name: 'Tarjeta',
      balance: 0,
      currency: 'HNL',
      iconCode: 'credit_card',
      iconColor: Colors.blueGrey[300]!.value
    ).toMap());

    // Crear categorías por defecto
    await db.insert('categories', Category(
      name: 'Comida Rápida',
      type: 'expenses',
      iconCode: 'burger',
      iconColor: Colors.green[300]!.value
    ).toMap());
    await db.insert('categories', Category(
      name: 'Salario',
      type: 'incomes',
      iconCode: 'salary',
      iconColor: Colors.green[300]!.value
    ).toMap());
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crear tablas
    await _createAccountsTable(db);
    await _createCategoriesTable(db);
    await _createTransactionsTable(db);

    // Crear datos por defecto
    await _createDefaultData(db);
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
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
        categoryId: transaction.categoryId,
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

  Future<List<TransactionData>> getTransactionsByFilter(String typeFilter, String dateFilter) async {
    final db = await database;

    final DateTime now = DateTime.now();
    final DateTime startDate0;

    switch (dateFilter) {
      case 'day':
        startDate0 = now;
      case 'week':
        int currentWeekday = now.weekday;
        startDate0 = now.subtract(Duration(days: currentWeekday));
      case 'month':
        startDate0 = DateTime(now.year, now.month, 1);
      case 'year':
        startDate0 = DateTime(now.year, 1, 1);
      default:
        startDate0 = DateTime(now.year, now.month, 1);
    }

    final startDate = DateFormat('yyyy-MM-dd').format(startDate0);
    final endDate = DateFormat('yyyy-MM-dd').format(now);

    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTableName,
      where: 'isIncome = ? AND date BETWEEN ? AND ?',
      whereArgs: [typeFilter == 'incomes' ? 1 : 0, startDate, endDate],
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

  Future<double> getTotalExpense() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE isIncome = 0'
    );
    if (result.isEmpty || result.first['total'] == null) {
      return 0;
    }
    return Future<double>.value(result.first['total']);
  }

  Future<double> getTotalIncome() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE isIncome = 1'
    );
    if (result.isEmpty || result.first['total'] == null) {
      return 0;
    }
    return Future<double>.value(result.first['total']);
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

  Future<double> getAllBalance() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(balance) as total FROM accounts'
    );

    if (result.isEmpty || result.first['total'] == null) {
      return 0;
    }
    return Future<double>.value(result.first['total']);
  }

  Future<int> insertAccount(Account account) async {
    final db = await database;
    return await db.insert(
      _accountsTableName,
      account.toMap()
    );
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

  Future<int> updateAccountBalance(int id, double amount, bool isIncome) async {
    final db = await database;
    final account = await getAccount(id);
    final newBalance = isIncome ? account.balance! + amount : account.balance! - amount;
    return await db.update(
      _accountsTableName,
      {'balance': newBalance},
      where: 'id = ?',
      whereArgs: [id]
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


  // CRUD para la tabla de categorías
  Future<Category> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
    return Category.fromMap(maps.first);
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_categoriesTableName);
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<List<Category>> getCategoriesByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTableName,
      where: 'type = ?',
      whereArgs: [type]
    );
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(
      _categoriesTableName,
      category.toMap()
    );
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      _categoriesTableName,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id]
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      _categoriesTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}
