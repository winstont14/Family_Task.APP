import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class TodoProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  List<Todo> _todos = [];

  List<Todo> get activeTodos =>
      _todos.where((t) => !t.isDone && t.isSuggestion != true).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Todo> get completedTodos =>
      _todos.where((t) => t.isDone).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Todo> get suggestedTodos =>
      _todos.where((t) => t.isSuggestion == true && !t.isDone).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Todo> activeTodosForMember(String? memberId) {
    if (memberId == null) return activeTodos;
    return _todos
        .where((t) => !t.isDone && t.isSuggestion != true && t.assignedTo == memberId)
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

  // ── Streak ────────────────────────────────────────────────────────
  int get streakDays {
    final dates = _todos
        .where((t) => t.isDone && t.completedAt != null)
        .map((t) => DateUtils.dateOnly(t.completedAt!))
        .toSet()
        .toList()
      ..sort();

    if (dates.isEmpty) return 0;

    final today = DateUtils.dateOnly(DateTime.now());
    int streak = 0;
    DateTime check = today;

    while (dates.contains(check)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }

    // streak ending yesterday still counts
    if (streak == 0) {
      check = today.subtract(const Duration(days: 1));
      while (dates.contains(check)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }

  // ── XP & Level system ────────────────────────────────────────────
  int xpForMember(String? memberId) {
    final done = memberId == null
        ? _todos.where((t) => t.isDone)
        : _todos.where((t) => t.isDone && t.assignedTo == memberId);
    return done.fold(0, (sum, t) {
      final stars = t.starRating ?? 0;
      return sum + (stars > 0 ? stars * 10 : 5);
    });
  }

  static int levelFromXp(int xp) => (xp ~/ 100) + 1;
  static int xpInCurrentLevel(int xp) => xp % 100;
  static int xpForTask(int? starRating) =>
      (starRating != null && starRating > 0) ? starRating * 10 : 5;

  // ── Weekly completed ──────────────────────────────────────────────
  int get completedThisWeek {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return _todos
        .where((t) =>
            t.isDone &&
            t.completedAt != null &&
            !t.completedAt!.isBefore(weekStart))
        .length;
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
    String? reward,
    int? starRating,
    bool isSuggestion = false,
  }) async {
    final todo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      colorValue: colorValue,
      assignedTo: assignedTo,
      reward: reward,
      starRating: starRating,
      isSuggestion: isSuggestion ? true : null,
    );
    await _storage.addTodo(todo);
    if (dueDate != null && !isSuggestion) {
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
    todo.completedAt = todo.isDone ? DateTime.now() : null;
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

  Future<void> approveSuggestion(Todo todo) async {
    todo.isSuggestion = null;
    await _storage.updateTodo(todo);
    notifyListeners();
  }

  Future<void> editTodo(
    Todo todo,
    String newTitle, {
    DateTime? dueDate,
    int? colorValue,
    String? assignedTo,
    String? reward,
    int? starRating,
  }) async {
    await NotificationService.cancelNotification(todo.id);
    todo.title = newTitle;
    todo.dueDate = dueDate;
    todo.colorValue = colorValue;
    todo.assignedTo = assignedTo;
    todo.reward = reward;
    todo.starRating = starRating;
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
