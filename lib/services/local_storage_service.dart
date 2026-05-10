import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo_model.dart';
import '../core/utils/constants.dart';

class LocalStorageService {
  Box<Todo> get _box => Hive.box<Todo>(AppConstants.todosBox);

  List<Todo> getAllTodos() => _box.values.toList();

  Future<void> addTodo(Todo todo) async {
    await _box.put(todo.id, todo);
  }

  Future<void> updateTodo(Todo todo) async {
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }
}
