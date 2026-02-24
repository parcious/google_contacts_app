import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const String _dbName = 'contacts.db';
  static const int _dbVersion = 1;
  static const String tableContacts = 'contacts';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableContacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL DEFAULT '',
        phoneNumber TEXT NOT NULL,
        email TEXT,
        company TEXT,
        notes TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        photoUrl TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // Create
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert(
      tableContacts,
      contact.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read all contacts
  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableContacts,
      orderBy: 'firstName COLLATE NOCASE ASC, lastName COLLATE NOCASE ASC',
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Read single contact
  Future<Contact?> getContact(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableContacts,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  // Read favorites
  Future<List<Contact>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableContacts,
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'firstName COLLATE NOCASE ASC, lastName COLLATE NOCASE ASC',
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Update
  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      tableContacts,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Delete
  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      tableContacts,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toggle favorite
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      tableContacts,
      {
        'isFavorite': isFavorite ? 1 : 0,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search contacts
  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableContacts,
      where:
          'firstName LIKE ? OR lastName LIKE ? OR phoneNumber LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'firstName COLLATE NOCASE ASC, lastName COLLATE NOCASE ASC',
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Get contact count
  Future<int> getContactCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableContacts');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}
