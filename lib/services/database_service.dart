import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:safechemicals/models/chemical_product.dart';
import 'package:safechemicals/utils/constants.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = AppConstants.databaseName;
  static const int _databaseVersion = AppConstants.databaseVersion;

  Future<Database> initDatabase() async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), _databaseName);
    
    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

    // Cargar datos de ejemplo si la tabla está vacía
    await _loadSampleData();

    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.productsTableName} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        commonNames TEXT NOT NULL,
        manufacturer TEXT,
        chemicalFormula TEXT,
        hazardLevel TEXT NOT NULL,
        hazards TEXT NOT NULL,
        safetyMeasures TEXT NOT NULL,
        firstAidMeasures TEXT NOT NULL,
        storageRequirements TEXT,
        spillRemediation TEXT,
        physicalState TEXT,
        color TEXT,
        odor TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _loadSampleData() async {
    final db = _database!;
    
    // Verificar si hay datos
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.productsTableName}'),
    );

    if (count == 0) {
      try {
        final String jsonString = await rootBundle.loadString('assets/data/sample_products.json');
        final List<dynamic> jsonData = json.decode(jsonString);

        for (var item in jsonData) {
          final product = ChemicalProduct.fromJson(item);
          await db.insert(
            AppConstants.productsTableName,
            product.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } catch (e) {
        print('Error loading sample data: $e');
      }
    }
  }

  Future<List<ChemicalProduct>> getAllProducts() async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.productsTableName,
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return ChemicalProduct.fromMap(maps[i]);
    });
  }

  Future<ChemicalProduct?> getProductById(String id) async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.productsTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ChemicalProduct.fromMap(maps.first);
  }

  Future<List<ChemicalProduct>> getProductsByHazardLevel(String hazardLevel) async {
    final db = _database!;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.productsTableName,
      where: 'hazardLevel = ?',
      whereArgs: [hazardLevel],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return ChemicalProduct.fromMap(maps[i]);
    });
  }

  Future<List<ChemicalProduct>> searchProducts(String query) async {
    final db = _database!;
    final String searchPattern = '%${query.toLowerCase()}%';

    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.productsTableName,
      where: 'LOWER(name) LIKE ? OR LOWER(commonNames) LIKE ? OR LOWER(manufacturer) LIKE ?',
      whereArgs: [searchPattern, searchPattern, searchPattern],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return ChemicalProduct.fromMap(maps[i]);
    });
  }

  Future<void> addProduct(ChemicalProduct product) async {
    final db = _database!;
    await db.insert(
      AppConstants.productsTableName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(ChemicalProduct product) async {
    final db = _database!;
    await db.update(
      AppConstants.productsTableName,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = _database!;
    await db.delete(
      AppConstants.productsTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
