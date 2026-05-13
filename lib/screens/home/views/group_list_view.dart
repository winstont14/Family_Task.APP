import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class GroupListView extends StatefulWidget {
  final VoidCallback onAddTask;
  const GroupListView({super.key, required this.onAddTask});

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  final Set<String> _collapsed = {};

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>();
    final family = context.watch<FamilyProvider>();

    final all = [...todos.activeTodos, ...todos.completedTodos];

    // Build groups: member id → list of todos
    final Map<String, List<Todo>> groups = {};
    for (final m in family.members) {
      groups[m.id] = all.where((t) => t.assignedTo == m.id).toList();
    }
    final unassigned = all
        .where((t) =>
            t.assignedTo == null || family.findById(t.assignedTo!) == null)
        .toList();

    if (all.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👥', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('No tasks yet',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text)),
            const SizedBox(height: 6),
            Text('Add a task and assign it to a family member',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.subtitle),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: widget.onAddTask,
              icon: const Icon(Icons.add_rounded),
              label: Text('Add Task',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        // One section per member
        for (final m in family.members) ...[
          if (groups[m.id]!.isNotEmpty)
            _GroupSection(
              key: ValueKey(m.id),
              groupKey: m.id,
              headerColor: Color(family.colorValueForMember(m.id)),
              initial: m.name[0].toUpperCase(),
              title: m.name,
              role: m.role,
              todos: groups[m.id]!,
              collapsed: _collapsed.contains(m.id),
              onToggle: () => setState(() {
                if (_collapsed.contains(m.id)) {
                  _collapsed.remove(m.id);
                } else {
                  _collapsed.add(m.id);
                }
              }),
            ),
        ],
        // Unassigned group
        if (unassigned.isNotEmpty)
          _GroupSection(
            key: const ValueKey('unassigned'),
            groupKey: 'unassigned',
            headerColor: const Color(0xFF9E9E9E),
            initial: '?',
            title: 'Unassigned',
            role: null,
            todos: unassigned,
            collapsed: _collapsed.contains('unassigned'),
            onToggle: () => setState(() {
              if (_collapsed.contains('unassigned')) {
                _collapsed.remove('unassigned');
              } else {
                _collapsed.add('unassigned');
              }
            }),
          ),
      ],
    );
  }
}

class _GroupSection extends StatelessWidget {
  final String groupKey;
  final Color headerColor;
  final String initial;
  final String title;
  final String? role;
  final List<Todo> todos;
  final bool collapsed;
  final VoidCallback onToggle;

  const _GroupSection({
    super.key,
    required this.groupKey,
    required this.headerColor,
    required this.initial,
    required this.title,
    required this.role,
    required this.todos,
    required this.collapsed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final active = todos.where((t) => !t.isDone).toList();
    final done = todos.where((t) => t.isDone).toList();
    final roleEmoji = switch (role) {
      'admin' => '👑',
      'parent' => '👔',
      _ => '🌟',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFF4a4a4a).withValues(alpha: 0.1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(14),
                  bottom: collapsed ? const Radius.circular(14) : Radius.zero,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: headerColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: headerColor),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(title,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text)),
                            if (role != null) ...[
                              const SizedBox(width: 5),
                              Text(roleEmoji,
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ],
                        ),
                        Text(
                          '${active.length} active · ${done.length} done',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.subtitle),
                        ),
                      ],
                    ),
                  ),
                  // Count pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: headerColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${todos.length}',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: headerColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: collapsed ? -0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.subtitle, size: 20),
                  ),
                ],
              ),
            ),
          ),
          // Task rows
          if (!collapsed) ...[
            for (final todo in [...active, ...done]) _TaskRow(todo: todo),
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Todo todo;
  const _TaskRow({required this.todo});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TodoProvider>();
    final isDone = todo.isDone;

    return InkWell(
      onTap: () => provider.toggleTodo(todo),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isDone ? AppColors.primary : const Color(0xFFB0B0B0),
                  width: 1.8,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDone ? AppColors.subtitle : AppColors.text,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (todo.dueDate != null)
                    Text(
                      DateFormat('MMM d').format(todo.dueDate!),
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: _dueDateColor(todo.dueDate!)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _dueDateColor(DateTime due) {
    final now = DateTime.now();
    if (due.isBefore(DateTime(now.year, now.month, now.day))) {
      return Colors.redAccent;
    }
    if (due.difference(now).inDays <= 1) return Colors.orange;
    return AppColors.subtitle;
  }
}
