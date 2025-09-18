import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/recipe.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL,
        category INTEGER NOT NULL,
        ingredients TEXT NOT NULL
      )
    ''');

    // Data semua resep resep
    await db.insert('recipes', {
      'title': 'Nasi Goreng',
      'description': 'Nasi goreng dengan telur dan kecap',
      'image': 'nasigoreng.jpg',
      'category': 0, // makanan
      'ingredients': '1 piring nasi (saya lebih), 2 butir telur, 1/2 sdt kaldu bubuk (sy skip), 1/4 sdt Garam, 1 bh Cabe merah (potong-potong), 1 sdt saus tiram, 1/4 sdt penyedap rasa (sy skip), 1/2 sdt minyak wijen, 1 sdt kecap manis (secukupnya), 3 siung bawang merah (iris), 2 siung bawang putih (iris), 2 batang bawang prei, potong-potong, 1 sdm cabe giling halus (tambahan saya), 3 sdm minyak untuk menumis'
    });

    await db.insert('recipes', {
      'title': 'Es Teh Manis',
      'description': 'Minuman teh dingin dengan gula',
      'image': 'esteh.jpg',
      'category': 1, // minuman
      'ingredients': '1 bag Teh Celup, 2 sdt Gula, 50 ml air panas, 100 ml air dingin, Es batu'
    });
<<<<<<< HEAD:lib/database/database_helper.dart
=======

    await db.insert('recipes', {
      'title': 'brownies keju lumer',
      'description': 'kue manis yang sangat enak',
      'image': 'brownieskeju.jpg',
      'category': 2, // kue
      'ingredients': '360 ml susu cair full cream, 30 gr tepung maizena Rose Brand, 30 gr gula pasir Rose Brand, 50 gr tepung tapioka, Isi :1 box (200 ml) brownies kukus, 2 sdm keju spready, 1 sdm susu kental manis'
    });
>>>>>>> deddeb3 (update app recipe):lib/data/database/database_helper.dart
    
    await db.insert('recipes', {
      'title': 'mie goreng',
      'description': 'mie goreng sat set',
      'image': 'miegoreng.jpg',
      'category': 0, // makanan
      'ingredients': '2 sdm kecap manis, 1 sdm kecap asin, 1 sdm saus tiram, 1 sdt lada bubuk, 2 sdt bawang putih bubuk, 1/2 sdt garam, 3 sdm air, 200 gr mie telur (seduh air panas), 2 btr telur, 4 siung bawang merah, iris, 4 buah bakso, potong bulat, 2 bonggol, sawi hijau, potong2, 5 sdm minyak goreng untuk menumis'
    });
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await instance.database;
    final result = await db.query('recipes', orderBy: 'id DESC');

    return result.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
