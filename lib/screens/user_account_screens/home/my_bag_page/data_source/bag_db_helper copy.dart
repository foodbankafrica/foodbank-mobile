import 'dart:async';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/bag_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BagDatabaseHelper {
  static final BagDatabaseHelper _instance = BagDatabaseHelper.internal();
  factory BagDatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  BagDatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bag.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
         CREATE TABLE Bag(
          id TEXT PRIMARY KEY,
          user_id TEXT,
          bag_category_id TEXT,
          name TEXT,
          slug TEXT,
          price REAL,
          discount_price REAL,
          description REAL,
          status TEXT,
          address TEXT,
          type TEXT,
          quantity INTEGER,
          images REAL,
          deleted_at REAL,
          created_at REAL,
          updated_at REAL
        )
        ''');
      },
    );
  }

  // Add a cart item to the database
  Future<int> addBagItem(Bag product) async {
    '${product.toJson()}'.log();
    var dbClient = await db;
    final alreadyBaggedItems =
        await dbClient!.query('Bag', where: 'id = ?', whereArgs: [product.id]);
    if (alreadyBaggedItems.isEmpty) {
      int res = await dbClient.insert('Bag', product.toJson());
      return res;
    }
    return 0;
  }

  // Get all cart items from the database
  Future<List<Bag>> getBagItems() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient!.query('Bag');
    return List.generate(
      maps.length,
      (i) {
        return Bag(
          id: int.parse(maps[i]['id']),
          slug: maps[i]['slug'] ?? '',
          description: maps[i]['description'],
          status: maps[i]['status'] ?? "",
          // discountPrice: maps[i]['discount_price'],
          name: maps[i]['name'] ?? "",
          bagCategoryId: maps[i]['bag_category_id'],
          userId: maps[i]['user_id'] ?? '',
          address: maps[i]['address'],
          createdAt: maps[i]['created_at'],
          updatedAt: maps[i]['updated_at'],
          images: maps[i]['images'],
          price: maps[i]['price'].toString(),
          type: maps[i]['type'] ?? '',
          quantity: maps[i]['quantity'] ?? 1,
        );
      },
    );
  }

  // Remove a cart item from the database
  Future<int> deleteBagItem(String sId) async {
    var dbClient = await db;
    return await dbClient!.delete('Bag', where: 'id = ?', whereArgs: [sId]);
  }

  // Update qty in the db
  Future<void> updateBagItemQty(String id, int newQty) async {
    final dbClient = await db;
    await dbClient!.update(
      'Bag',
      {'quantity': newQty},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update qty in the db
  Future<void> deleteAllBag() async {
    final dbClient = await db;
    await dbClient!.transaction((txn) async {
      await txn.rawQuery('DELETE FROM Bag');
    });

    // Close the database
    await dbClient.close();
  }
}
