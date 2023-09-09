import 'package:miniproject2/Model/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBhelper{
  static final String _dbName = 'notes.db';
  static int _dbVersion = 1;
  static final String _tableCategory = 'notes';


  // Column Nmaes
  static final String _id = 'Uid';
  static final String _title = 'title';
  static final String _desc = 'description';
  static final String _date = 'date';
  static final String _noteid = 'id';
  static Database? _database;


  Future<Database?> getDatabase() async {
    if (_database == null) {
      _database = await createDatabase();
    }
    return _database;
  }
  Future<Database> createDatabase() async {

    var path = join(await getDatabasesPath(), _dbName);
    print('database path : $path');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $_tableCategory ('
            '$_noteid INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$_title TEXT, '
            '$_desc TEXT, '
            '$_date TEXT, '
            '$_id TEXT'
            ')');
      },
    );
  }
  //
  Future<int> insert(note notes) async {
    final db = await getDatabase();
    return await db!.insert(_tableCategory, notes.toMap());
  }
  Future<List<note>> read() async {
    var categoryList = <note>[];
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db!.rawQuery('select * from $_tableCategory');
    categoryList = List.generate(maps.length, (index) => note.fromMap(maps[index]));
    return categoryList;
  }


  Future<int> delete(int? id) async {
    final db = await getDatabase();
    return await db!.delete(_tableCategory,where: 'id = ?',whereArgs: [id]);
  }


  Future<int> update(note notesUpdate) async {
    final db = await getDatabase();
    return await db!.update(_tableCategory, notesUpdate.toMap(),where : 'id = ?',whereArgs : [notesUpdate.id]);
  }
}