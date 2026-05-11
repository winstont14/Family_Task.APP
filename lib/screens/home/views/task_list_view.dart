import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/todo_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/section_title.dart';
import '../../../widgets/todo_card.dart';

class TaskListView extends StatelessWidget {
  final String? effectiveMemberId;

  const TaskListView({super.key, required this.effectiveMemberId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final active = provider.activeTodosForMember(effectiveMemberId);
        final completed =
            provider.completedTodosForMember(effectiveMemberId);

        if (active.isEmpty && completed.isEmpty) {
          return const EmptyState();
        }

        final suggested = provider.suggestedTodos;

        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            if (suggested.isNotEmpty) ...[
              SectionTitle(
                  title: 'SUGGESTIONS',
                  count: suggested.length,
                  emoji: '💡'),
              ...suggested.map((todo) => TodoCard(todo: todo)),
            ],
            if (active.isNotEmpty) ...[
              SectionTitle(
                  title: 'TODAY', count: active.length, emoji: '📅'),
              ...active.map((todo) => TodoCard(todo: todo)),
            ],
            if (completed.isNotEmpty) ...[
              SectionTitle(
                  title: 'DONE', count: completed.length, emoji: '✅'),
              ...completed.map((todo) => TodoCard(todo: todo)),
            ],
          ],
        );
      },
    );
  }
}
