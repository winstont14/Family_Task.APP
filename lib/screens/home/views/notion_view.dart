import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class NotionView extends StatefulWidget {
  final VoidCallback onAddTask;
  const NotionView({super.key, required this.onAddTask});

  @override
  State<NotionView> createState() => _NotionViewState();
}

class _NotionViewState extends State<NotionView> {
  bool _doneExpanded = false;

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>();
    final active = todos.activeTodos;
    final done = todos.completedTodos;

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
      children: [
        // ── Page header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📋',
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 8),
              Text(
                'Tasks',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              Text(
                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.subtitle),
              ),
            ],
          ),
        ),

        // ── Divider ──────────────────────────────────────────────
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        const SizedBox(height: 4),

        // ── Active blocks ────────────────────────────────────────
        if (active.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.add_rounded,
                    color: Color(0xFFB0B0B0), size: 18),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onAddTask,
                  child: Text(
                    'Add a task...',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFFB0B0B0)),
                  ),
                ),
              ],
            ),
          )
        else
          for (final todo in active)
            _NotionBlock(todo: todo),

        // ── Add block button ─────────────────────────────────────
        InkWell(
          onTap: widget.onAddTask,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.add_rounded,
                      size: 14, color: Color(0xFF9E9E9E)),
                ),
                const SizedBox(width: 10),
                Text(
                  'New block',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: const Color(0xFFB0B0B0)),
                ),
              ],
            ),
          ),
        ),

        // ── Completed section ────────────────────────────────────
        if (done.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          InkWell(
            onTap: () => setState(() => _doneExpanded = !_doneExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _doneExpanded ? 0 : -0.25,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: AppColors.subtitle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${done.length} completed',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subtitle),
                  ),
                ],
              ),
            ),
          ),
          if (_doneExpanded)
            for (final todo in done)
              _NotionBlock(todo: todo),
        ],
      ],
    );
  }
}

// ── Notion Block ─────────────────────────────────────────────────────

class _NotionBlock extends StatelessWidget {
  final Todo todo;
  const _NotionBlock({required this.todo});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TodoProvider>();
    final family = context.read<FamilyProvider>();
    final member = todo.assignedTo != null
        ? family.findById(todo.assignedTo!)
        : null;
    final memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          hoverColor: const Color(0xFFF7F7F7),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 3, right: 4),
                  child: Icon(Icons.drag_indicator_rounded,
                      size: 16,
                      color: const Color(0xFFD0D0D0).withValues(alpha: 0.8)),
                ),

                // Checkbox
                GestureDetector(
                  onTap: () => provider.toggleTodo(todo),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, right: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: todo.isDone
                            ? AppColors.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: todo.isDone
                              ? AppColors.primary
                              : const Color(0xFFB8B8B8),
                          width: 1.6,
                        ),
                      ),
                      child: todo.isDone
                          ? const Icon(Icons.check,
                              size: 11, color: Colors.white)
                          : null,
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: todo.isDone
                              ? AppColors.subtitle
                              : AppColors.text,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppColors.subtitle,
                        ),
                      ),
                      // Property tags row
                      if (member != null || todo.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              if (member != null)
                                _PropTag(
                                  icon: null,
                                  color: memberColor!
                                      .withValues(alpha: 0.15),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: memberColor.withValues(
                                              alpha: 0.25),
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          member.name[0].toUpperCase(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: memberColor),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        member.name,
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: memberColor),
                                      ),
                                    ],
                                  ),
                                ),
                              if (todo.dueDate != null)
                                _PropTag(
                                  icon: null,
                                  color: _dueDateBg(todo.dueDate!),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_today_rounded,
                                          size: 10,
                                          color: _dueDateFg(todo.dueDate!)),
                                      const SizedBox(width: 3),
                                      Text(
                                        DateFormat('MMM d')
                                            .format(todo.dueDate!),
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color:
                                                _dueDateFg(todo.dueDate!)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _dueDateBg(DateTime due) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(due.year, due.month, due.day);
    if (dueDay.isBefore(today)) return Colors.redAccent.withValues(alpha: 0.1);
    if (dueDay.difference(today).inDays <= 1) {
      return Colors.orange.withValues(alpha: 0.1);
    }
    return const Color(0xFFF0F0F0);
  }

  Color _dueDateFg(DateTime due) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(due.year, due.month, due.day);
    if (dueDay.isBefore(today)) return Colors.redAccent;
    if (dueDay.difference(today).inDays <= 1) return Colors.orange;
    return AppColors.subtitle;
  }
}

class _PropTag extends StatelessWidget {
  final IconData? icon;
  final Color color;
  final Widget child;

  const _PropTag({
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
