import 'package:flutter/material.dart';
import 'package:todos/todos_provider/todo_db_helper.dart';
import 'package:todos/todos_provider/todo_model.dart';

/// A provider for managing Todo items using ChangeNotifier.
class TodosProvider with ChangeNotifier {
  // Database helper for CRUD operations.
  final TodoDbHelper dbHelper = TodoDbHelper();

  // List to hold Todo items.
  List<TodoModel> items = [];

  // State flags.
  bool _created = false;

  bool _deleted = false;
  bool _loading = true;
  bool _success = false;
  bool _updated = false;

  // Getters for external access.
  List<TodoModel> get todos => [...items];

  bool get loading => _loading;

  bool get created => _created;

  bool get success => _success;

  bool get updated => _updated;

  bool get deleted => _deleted;

  /// Resets all state flags to their initial values.
  Future<void> resetProvider() async {
    _created = false;
    _deleted = false;
    _loading = false;
    _success = false;
    _updated = false;
    notifyListeners();
  }

  /// Fetches all todos from the database.
  /// Sets [_loading] to true during the fetch, then false upon completion.
  Future<void> getTodos() async {
    _loading = true;

    try {
      final List<TodoModel> _todos = await dbHelper.todos();
      items = _todos;
      _success = true;
    } catch (e) {
      // Handle error if needed.
      _success = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Inserts a new todo into the database.
  /// Updates the [_created] flag upon success.
  Future<void> insertATodo(TodoModel todo) async {
    _loading = true;

    try {
      await dbHelper.insertTodo(todo);
      _created = true;
    } catch (e) {
      // Handle error if needed.
      _created = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Updates an existing todo in the database.
  /// Updates the [_updated] flag upon success.
  Future<void> updateATodo(TodoModel todo) async {
    _loading = true;

    try {
      await dbHelper.updateTodo(todo);
      _updated = true;
    } catch (e) {
      // Handle error if needed.
      _updated = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Deletes a todo from the database by [id].
  /// Updates the [_deleted] flag upon success.
  Future<void> deleteATodo(int id) async {
    _loading = true;

    try {
      await dbHelper.deleteTodo(id);
      _deleted = true;
    } catch (e) {
      // Handle error if needed.
      _deleted = false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
