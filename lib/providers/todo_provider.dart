import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class TodoProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  List<Todo> _todos = [];

  List<Todo> get activeTodos =>
      _todos.where((t) => !t.isDone).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Todo> get completedTodos =>
      _todos.where((t) => t.isDone).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Todo> activeTodosForMember(String? memberId) {
    if (memberId == null) return activeTodos;
    return _todos
        .where((t) => !t.isDone && t.assignedTo == memberId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<Todo> completedTodosForMember(String? memberId) {
    if (memberId == null) return completedTodos;
    return _todos
        .where((t) => t.isDone && t.assignedTo == memberId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void loadTodos() {
    _todos = _storage.getAllTodos();
    notifyListeners();
  }

  Future<void> addTodo(
    String title, {
    DateTime? dueDate,
    int? colorValue,
    String? assignedTo,
  }) async {
    final todo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      colorValue: colorValue,
      assignedTo: assignedTo,
    );
    await _storage.addTodo(todo);
    if (dueDate != null) {
      await NotificationService.scheduleTaskNotification(
        id: todo.id,
        title: title,
        dueDate: dueDate,
      );
    }
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> toggleTodo(Todo todo) async {
    todo.isDone = !todo.isDone;
    if (todo.isDone) {
      await NotificationService.cancelNotification(todo.id);
    } else if (todo.dueDate != null &&
        todo.dueDate!.isAfter(DateTime.now())) {
      await NotificationService.scheduleTaskNotification(
        id: todo.id,
        title: todo.title,
        dueDate: todo.dueDate!,
      );
    }
    await _storage.updateTodo(todo);
    notifyListeners();
  }

  Future<void> editTodo(
    Todo todo,
    String newTitle, {
    DateTime? dueDate,
    int? colorValue,
    String? assignedTo,
  }) async {
    await NotificationService.cancelNotification(todo.id);
    todo.title = newTitle;
    todo.dueDate = dueDate;
    todo.colorValue = colorValue;
    todo.assignedTo = assignedTo;
    await _storage.updateTodo(todo);
    if (dueDate != null && dueDate.isAfter(DateTime.now())) {
      await NotificationService.scheduleTaskNotification(
        id: todo.id,
        title: newTitle,
        dueDate: dueDate,
      );
    }
    notifyListeners();
  }

  Future<void> deleteTodo(Todo todo) async {
    await NotificationService.cancelNotification(todo.id);
    await _storage.deleteTodo(todo.id);
    _todos.remove(todo);
    notifyListeners();
  }
}
