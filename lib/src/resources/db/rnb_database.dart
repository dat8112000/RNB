import 'package:rnb/src/resources/model/article_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RnBDatabase {
  static final RnBDatabase instance = RnBDatabase._init();
  static Database? _database;

  RnBDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDB('article.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idType = 'TEXT PRIMARY KEY';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
CREATE TABLE $tableArticle ( 
  ${ArticleFields.id} $idType, 
  ${ArticleFields.title} $textType,
  ${ArticleFields.content} $textType,
  ${ArticleFields.date} $textType
  )
''');
  }

  Future<Article> create(Article article) async {
    final db = await instance.database;
    final id = await db!.insert(tableArticle, article.toJson());
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    return article.copy(id: id.toString());
  }

  Future<Article> readNote(String id) async {
    final db = await instance.database;

    final maps = await db!.query(
      tableArticle,
      columns: ArticleFields.values,
      where: '${ArticleFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Article.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Article>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${ArticleFields.date} ASC';

    final result =
        await db!.query(tableArticle, orderBy: orderBy, distinct: true);

    return result.map((json) => Article.fromJson(json)).toList();
  }

  Future<int> update(Article note) async {
    final db = await instance.database;

    return db!.update(
      tableArticle,
      note.toJson(),
      where: '${ArticleFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db!.delete(
      tableArticle,
      where: '${ArticleFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
