import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:todos/todos_provider/todo_model.dart';

class TodoDbHelper {
// Singleton pattern
  static final TodoDbHelper _instance = TodoDbHelper._internal();
  factory TodoDbHelper() => _instance;
  TodoDbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // initialize the database
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    if (kIsWeb) {
      // do run `dart run sqflite_common_ffi_web:setup` to get it working
      var factory = databaseFactoryFfiWeb;
      return await factory.openDatabase('my_db.db',
          options: OpenDatabaseOptions(
            onCreate: _onCreate,
            version: 1,
          ));
    } else {
      sqfliteFfiInit();

      var databaseFactory = databaseFactoryFfi;
      final io.Directory appDocumentsDir =
          await getApplicationDocumentsDirectory();

      //Create path for database
      String dbPath = p.join(appDocumentsDir.path, "databases", "todos.db");
      return await databaseFactory.openDatabase(dbPath,
          options: OpenDatabaseOptions(
            onCreate: _onCreate,
            version: 1,
          ));
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE TABLE statement on the database.
    await db.execute('''
      CREATE TABLE todos(
      id INTEGER PRIMARY KEY, 
      title TEXT, 
      description TEXT,
      completed INTEGER)
    ''');
  }

  // insert a todo to the database
  // Define a function that inserts todos into the database
  Future<void> insertTodo(TodoModel todoModel) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'todos',
      todoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the Todos from the dogs table.
  Future<List<TodoModel>> todos() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('todos');

    // Convert the list of each todo's fields into a list of `TodoModel` objects.
    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'description': description as String,
            'completed': completed as int
          } in dogMaps)
        TodoModel(
            id: id,
            title: title,
            description: description,
            completed: completed),
    ];
  }

  Future<void> updateTodo(TodoModel todo) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'todos',
      todo.toMap(),
      // Ensure that the Todo has a matching id.
      where: 'id = ?',
      // Pass the Todo's id as a whereArg to prevent SQL injection.
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'todos',
      // Use a `where` clause to delete a specific Todo.
      where: 'id = ?',
      // Pass the Todo's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
