import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:notekeeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper databaseHelper;
  Database _database;
  DatabaseHelper.createInstance();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.createInstance();
    }

    return databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    //get directory path to both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();

    //below line produce error in iOS
    // String path = directory.path + 'notes.db';
    String path = join(directory.path, 'notes.db');

    //open/create db at give path
    var noteDatabase = await openDatabase(path, version: 1, onCreate: createDb);
    return noteDatabase;
  }

  void createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT,$colDescription Text, $colPriority INTEGER, $colDate TEXT)');
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();

    return _database;
  }

  //Fetch operation. Get all note object from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    //get refrence to database
    Database db = await this.database;

    // var result = db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //alternative of above query is
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  //Insert Operation
  Future<int> insertNote(Note note) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

    //Update Operation
  Future<int> updateNote(Note note) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

      //Delete Operation
  Future<int> deleteNote(int id) async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    var result = await db.delete(noteTable, where: '$colId = $id');
    return result;
  }

      //Delete Operation
  Future<int> getCount() async {
    //get refrence to database
    Database db = await this.database;

    //first convert note object into map
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    var result = Sqflite.firstIntValue(x);
    return result;
  }
  
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    for (int i=0; i<count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
