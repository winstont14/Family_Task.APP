import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/core/utils/todo_queries.dart';
import 'package:todo_app/models/todo_model.dart';

void main() {
  group('TodoQueries', () {
    test('filters active todos by member and newest creation date', () {
      final todos = [
        _todo('old', assignedTo: 'member-1', createdAtDay: 1),
        _todo('done', assignedTo: 'member-1', createdAtDay: 2, isDone: true),
        _todo('suggested',
            assignedTo: 'member-1', createdAtDay: 3, isSuggestion: true),
        _todo('other-member', assignedTo: 'member-2', createdAtDay: 4),
        _todo('new', assignedTo: 'member-1', createdAtDay: 5),
      ];

      final active = TodoQueries.sortedActiveTodos(todos, memberId: 'member-1');

      expect(active.map((todo) => todo.id), ['new', 'old']);
    });

    test('buckets active todos by due day with unscheduled last', () {
      final now = DateTime(2026, 5, 12, 14);
      final todos = [
        _todo('no-date', createdAtDay: 5),
        _todo('future-late',
            dueDate: DateTime(2026, 5, 15, 17), createdAtDay: 4),
        _todo('today-late',
            dueDate: DateTime(2026, 5, 12, 18), createdAtDay: 3),
        _todo('overdue', dueDate: DateTime(2026, 5, 11, 9), createdAtDay: 2),
        _todo('today-early',
            dueDate: DateTime(2026, 5, 12, 9), createdAtDay: 1),
      ];

      final sections = TodoQueries.bucketActiveByDueDate(todos, now: now);

      expect(sections.overdue.map((todo) => todo.id), ['overdue']);
      expect(
        sections.dueToday.map((todo) => todo.id),
        ['today-early', 'today-late'],
      );
      expect(
        sections.upcoming.map((todo) => todo.id),
        ['future-late', 'no-date'],
      );
    });

    test('sorts dashboard tasks by urgency then due date', () {
      final now = DateTime(2026, 5, 12, 14);
      final todos = [
        _todo('no-date', createdAtDay: 5),
        _todo('future', dueDate: DateTime(2026, 5, 13), createdAtDay: 4),
        _todo('today-open',
            dueDate: DateTime(2026, 5, 12, 18), createdAtDay: 3),
        _todo('today-past', dueDate: DateTime(2026, 5, 12, 9), createdAtDay: 2),
        _todo('older-overdue',
            dueDate: DateTime(2026, 5, 11, 9), createdAtDay: 1),
      ];

      final sorted = TodoQueries.sortedByDashboardPriority(todos, now: now);

      expect(
        sorted.map((todo) => todo.id),
        ['older-overdue', 'today-past', 'today-open', 'future', 'no-date'],
      );
    });
  });
}

Todo _todo(
  String id, {
  String? assignedTo,
  DateTime? dueDate,
  int createdAtDay = 1,
  bool isDone = false,
  bool isSuggestion = false,
}) {
  return Todo(
    id: id,
    title: id,
    assignedTo: assignedTo,
    dueDate: dueDate,
    createdAt: DateTime(2026, 5, createdAtDay),
    isDone: isDone,
    isSuggestion: isSuggestion ? true : null,
  );
}
