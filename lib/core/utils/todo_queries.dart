import '../../models/todo_model.dart';

class TodoQueries {
  const TodoQueries._();

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static int byNewestCreated(Todo a, Todo b) =>
      b.createdAt.compareTo(a.createdAt);

  static int byDueDateAscendingNullsLast(Todo a, Todo b) {
    final aDue = a.dueDate;
    final bDue = b.dueDate;

    if (aDue == null && bDue == null) return byNewestCreated(a, b);
    if (aDue == null) return 1;
    if (bDue == null) return -1;

    final dueComparison = aDue.compareTo(bDue);
    if (dueComparison != 0) return dueComparison;

    return byNewestCreated(a, b);
  }

  static List<Todo> sortedActiveTodos(
    Iterable<Todo> todos, {
    Set<String>? memberIds,
  }) {
    return _sortedWhere(
      todos,
      (todo) =>
          !todo.isDone &&
          todo.isSuggestion != true &&
          _belongsToMembers(todo, memberIds),
    );
  }

  static List<Todo> sortedCompletedTodos(
    Iterable<Todo> todos, {
    Set<String>? memberIds,
  }) {
    return _sortedWhere(
      todos,
      (todo) => todo.isDone && _belongsToMembers(todo, memberIds),
    );
  }

  static List<Todo> sortedSuggestedTodos(Iterable<Todo> todos) {
    return _sortedWhere(
      todos,
      (todo) => todo.isSuggestion == true && !todo.isDone,
    );
  }

  static TodoDateSections bucketActiveByDueDate(
    Iterable<Todo> activeTodos, {
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final today = startOfDay(reference);
    final overdue = <Todo>[];
    final dueToday = <Todo>[];
    final upcoming = <Todo>[];

    for (final todo in activeTodos) {
      final dueDate = todo.dueDate;
      if (dueDate == null) {
        upcoming.add(todo);
        continue;
      }

      final dueDay = startOfDay(dueDate);
      if (dueDay.isBefore(today)) {
        overdue.add(todo);
      } else if (isSameDay(dueDate, reference)) {
        dueToday.add(todo);
      } else {
        upcoming.add(todo);
      }
    }

    overdue.sort(byDueDateAscendingNullsLast);
    dueToday.sort(byDueDateAscendingNullsLast);
    upcoming.sort(byDueDateAscendingNullsLast);

    return TodoDateSections(
      overdue: overdue,
      dueToday: dueToday,
      upcoming: upcoming,
    );
  }

  static List<Todo> sortedByDashboardPriority(
    Iterable<Todo> todos, {
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();

    return [...todos]..sort((a, b) {
        final priorityComparison = _dashboardPriority(a, reference).compareTo(
          _dashboardPriority(b, reference),
        );
        if (priorityComparison != 0) return priorityComparison;

        return byDueDateAscendingNullsLast(a, b);
      });
  }

  static List<Todo> _sortedWhere(
    Iterable<Todo> todos,
    bool Function(Todo todo) test,
  ) {
    return todos.where(test).toList()..sort(byNewestCreated);
  }

  static bool _belongsToMembers(Todo todo, Set<String>? memberIds) =>
      memberIds == null ||
      memberIds.isEmpty ||
      memberIds.contains(todo.assignedTo);

  static int _dashboardPriority(Todo todo, DateTime now) {
    final dueDate = todo.dueDate;
    if (dueDate == null) return 3;
    if (dueDate.isBefore(now)) return 0;
    if (isSameDay(dueDate, now)) return 1;
    return 2;
  }
}

class TodoDateSections {
  final List<Todo> overdue;
  final List<Todo> dueToday;
  final List<Todo> upcoming;

  const TodoDateSections({
    required this.overdue,
    required this.dueToday,
    required this.upcoming,
  });
}
