import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:pokedex_mobile/dtos/category_model.dart';
import 'package:sqflite/sqflite.dart';

//Patron singleton
class CategoryDatabase {
  static final CategoryDatabase instance = CategoryDatabase._init();

  static Database? _database;

  CategoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pokedex.db');
    return _database!;
  }

  Future<Database> _initDB(String file) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, file);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //INTEGER
    //TEXT
    //BOOLEAN
    //BLOB
    await db.execute('''
      CREATE TABLE $tableCategory (
        ${CategoryField.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${CategoryField.name} TEXT NOT NULL,
        ${CategoryField.image} TEXT NOT NULL
      )
    ''');
  }

  Future<void> create(CategoryModel category) async {
    final db = await instance.database;
    //1er pamaetro - > nombre de la tabla
    //2 parametro -> Map donde el key -> columna, value = valor
    //CategoryModel(1, nombre1, image1)
    //[id] = 1, [name] = nombre1, [image] = image1
    await db.insert(tableCategory, category.toJson());
  }

  Future<List<CategoryModel>> readAllCategories() async {
    final db = await instance.database;
    final results = await db.query(tableCategory);
    //results = List ->
    //      Map([id: 1, name: Nobre, image: Image 1])
    //      Map([id: 2, name: Nobre2, image: Image 2])
    //List(objeto1) -> List(objeto2)
    //List(integers) -> List(string)
    return results
        .map((mapCategories) => CategoryModel.fromJson(mapCategories))
        .toList();
  }

  Future<void> delete(int id) async {
    final db = await instance.database;
    await db.delete(tableCategory,
        where: '${CategoryField.id} = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
