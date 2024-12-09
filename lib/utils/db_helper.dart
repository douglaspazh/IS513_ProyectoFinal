import 'package:flutter/material.dart';
import 'package:money_app/models/account.dart';
import 'package:money_app/models/category.dart';
import 'package:money_app/utils/common_funcs.dart';
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
      iconColor: Colors.teal[300]!.value
    ).toMap());

    // Crear categorías por defecto
    await db.insert('categories', Category(
      name: 'Comida Rápida',
      type: 'expenses',
      iconCode: 'burger',
      iconColor: Colors.red[300]!.value
    ).toMap());
    await db.insert('categories', Category(
      name: 'Transporte',
      type: 'expenses',
      iconCode: 'transport',
      iconColor: Colors.blue[300]!.value
    ).toMap());
    await db.insert('categories', Category(
      name: 'Salario',
      type: 'incomes',
      iconCode: 'salary',
      iconColor: Colors.green[300]!.value
    ).toMap());
    await db.insert('categories', Category(
      name: 'Regalo',
      type: 'incomes',
      iconCode: 'gift',
      iconColor: Colors.purple[300]!.value
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

  Future<TransactionData> getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id]
    );
    return TransactionData.fromMap(maps.first);
  }

  Future<Map<String, dynamic>> getTransactionDetails(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT t.amount, t.date, t.description, t.isIncome, c.name as category, c.iconCode as categoryIcon, c.iconColor as categoryColor, a.name as account, a.currency as currency, a.iconCode as accountIcon, a.iconColor as accountColor
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      JOIN accounts a ON t.accountId = a.id
      WHERE t.id = ?
    ''', [id]);
    return maps.first;
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

  Future<List<TransactionData>> getTransactionsByFilter(String typeFilter, List dateRange) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _transactionsTableName,
      where: 'isIncome = ? AND date BETWEEN ? AND ?',
      whereArgs: [typeFilter == 'incomes' ? 1 : 0, dateRange[0], dateRange[1]]
    );
    return List.generate(maps.length, (i) => TransactionData.fromMap(maps[i]));
  }

  Future<int> updateTransaction(int id, TransactionData transaction) async {
    final Database db = await database;
    final transactionMap = transaction.toMap();
    transactionMap.remove('id');
    return await db.update(
      _transactionsTableName,
      transactionMap,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> deleteTransaction(int id) async {
    final Database db = await database;
    final result = await db.delete(
      _transactionsTableName,
      where: 'id = ?',
      whereArgs: [id]
    );
    return result > 0;
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

  Future<double> getBalanceByFilter(String typeFilter, List dateRange) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE isIncome = ? AND date BETWEEN ? AND ?
      ''', [typeFilter == 'incomes' ? 1 : 0, dateRange[0], dateRange[1]]
    );

    if (result.isEmpty || result.first['total'] == null) {
      return 0;
    }
    return Future<double>.value(result.first['total']);
  }

  Future<Map<String, Map<String, dynamic>>> getTransactionsByCategoryAndMonth(String typeFilter) async {
    final db = await database;
    final currentYear = DateTime.now().year;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT strftime('%m', date) as month, c.name, c.iconColor, SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE strftime('%Y', date) = ?
      GROUP BY month, c.name, c.iconColor
      HAVING t.isIncome = ?
    ''', [currentYear.toString(), typeFilter == 'incomes' ? 1 : 0]);

    Map<String, Map<String, dynamic>> transactionsByCategoryAndMonth = {};

    for (var e in result) {
      String monthKey = getMonthKey(e['month']);
      if (!transactionsByCategoryAndMonth.containsKey(monthKey)) {
        transactionsByCategoryAndMonth[monthKey] = {};
      }
      transactionsByCategoryAndMonth[monthKey]![e['name']] = {
        'date': e['month'],
        'total': e['total'],
        'iconColor': e['iconColor']
      };
    }

    return transactionsByCategoryAndMonth;
  }

  Future<Map<String, Map<String, dynamic>>> getCategoryData(String filterType, List dateRange) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT c.name, c.iconColor, SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE t.date BETWEEN ? AND ?
      GROUP BY c.name, c.iconColor
      HAVING t.isIncome = ?
    ''', [dateRange[0], dateRange[1], filterType == 'incomes' ? 1 : 0]
    );

    return {
      for (var e in result)
        e['name']: {
          'total': e['total'],
          'iconColor': e['iconColor']
        }
    };
  }


  // CRUD para la tabla de cuentas
  Future<Account> getAccountById(int id) async {
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

  Future<double> getTotalBalance() async {
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

  Future<int> updateAccount(int id, Account account) async {
    final db = await database;
    final accountMap = account.toMap();
    accountMap.remove('id');
    return await db.update(
      _accountsTableName,
      accountMap,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> updateAccountBalance(int id, double amount, bool isIncome) async {
    final db = await database;
    final account = await getAccountById(id);
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

  Future<List<Category>> getCategoriesByType(String typeFilter) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _categoriesTableName,
      where: 'type = ?',
      whereArgs: [typeFilter]
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

  Future<int> updateCategory(int id, Category category) async {
    final db = await database;
    final categoryMap = category.toMap();
    categoryMap.remove('id');
    return await db.update(
      _categoriesTableName,
      categoryMap,
      where: 'id = ?',
      whereArgs: [id]
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
