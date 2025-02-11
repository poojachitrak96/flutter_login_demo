import 'package:flutter_login_demo/data/model/User.dart';
import 'package:flutter_login_demo/data/repository/UserRepository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class UserRepositoryImpl implements IUserRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            userName TEXT PRIMARY KEY,
            password TEXT,
            isLoggedIn INTEGER DEFAULT 0,
            counterValue INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  @override
  Future<User?> isUserLoggedIn() async {
    final db = await database;
    final result =
    await db.query('users', where: 'isLoggedIn = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return User(
        userName: result.first['userName'] as String,
        password: result.first['password'] as String,
        isLoggedIn: (result.first['isLoggedIn'] as int) == 1,
        counterValue: result.first['counterValue'] as int,
      );
    }
    return null;
  }

  @override
  Future<User?> checkUser(String userName) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'userName = ?',
      whereArgs: [userName],
    );

    if (result.isNotEmpty) {
      return User(
        userName: result.first['userName'] as String,
        password: result.first['password'] as String,
        isLoggedIn: (result.first['isLoggedIn'] as int) == 1,
        counterValue: result.first['counterValue'] as int,
      );
    }
    return null;
  }

  @override
  Future<User> createUser(User user) async {
    final db = await database;

    await db.insert(
      'users',
      {
        'userName': user.userName,
        'password': user.password,
        'isLoggedIn': user.isLoggedIn == true ? 1 : 0,
        'counterValue': user.counterValue ?? 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return user;
  }

  @override
  Future<User> login(User user) async {
    final db = await database;

    await db.update(
      'users',
      {'isLoggedIn': 1},
      where: 'userName = ?',
      whereArgs: [user.userName],
    );

    return user.copyWith(isLoggedIn: true);
  }

  @override
  Future<void> logout(User user) async {
    final db = await database;

    await db.update(
      'users',
      {'isLoggedIn': 0},
      where: 'userName = ?',
      whereArgs: [user.userName],
    );
  }

  @override
  Future<User> updateUser(User user) async {
    final db = await database;

    await db.update(
      'users',
      {
        'password': user.password,
        'isLoggedIn': user.isLoggedIn == true ? 1 : 0,
        'counterValue': user.counterValue ?? 0,
      },
      where: 'userName = ?',
      whereArgs: [user.userName],
    );
    print(user.toString());

    return user;
  }
}
