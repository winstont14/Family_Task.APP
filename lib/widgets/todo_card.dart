import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../models/todo_model.dart';
import '../providers/family_provider.dart';
import '../providers/todo_provider.dart';
import '../screens/add_todo/add_todo_screen.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  const TodoCard({super.key, required this.todo});

  Color get _cardColor {
    if (todo.isDone) return AppColors.done;
    if (todo.colorValue != null) return Color(todo.colorValue!);
    return AppColors.card;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.deleteRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 28),
      ),
      onDismissed: (_) => context.read<TodoProvider>().deleteTodo(todo),
      child: GestureDetector(
        onLongPress: () => _openEdit(context),
        child: Card(
          color: _cardColor,
          elevation: todo.isDone ? 0 : 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) =>
                        context.read<TodoProvider>().toggleTodo(todo),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: todo.isDone
                              ? AppColors.subtitle
                              : AppColors.text,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: AppColors.subtitle,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (todo.assignedTo != null) ...[
                            _MemberBadge(memberId: todo.assignedTo!),
                            const SizedBox(width: 8),
                          ],
                          if (!todo.isDone && todo.dueDate != null)
                            Flexible(
                              child: _CountdownBadge(dueDate: todo.dueDate!),
                            )
                          else
                            Flexible(
                              child: Text(
                                _formatDate(todo.createdAt),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.subtitle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!todo.isDone)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.subtitle),
                    onPressed: () => _openEdit(context),
                    iconSize: 24,
                    padding: const EdgeInsets.all(12),
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.deleteRed),
                  onPressed: () => _confirmDelete(context),
                  iconSize: 24,
                  padding: const EdgeInsets.all(12),
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    if (isToday) return 'Today ${DateFormat('h:mm a').format(date)}';
    return DateFormat('MMM d, h:mm a').format(date);
  }

  void _openEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTodoScreen(existingTodo: todo),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete task?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          '"${todo.title}"',
          style: GoogleFonts.poppins(fontSize: 15, color: AppColors.subtitle),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppColors.subtitle)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TodoProvider>().deleteTodo(todo);
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(
                    color: AppColors.deleteRed,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _MemberBadge extends StatelessWidget {
  final String memberId;

  const _MemberBadge({required this.memberId});

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();
    final member = family.findById(memberId);
    if (member == null) return const SizedBox.shrink();
    final color = Color(family.colorValueForMember(memberId));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 7,
            backgroundColor: color,
            child: Text(
              member.name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            member.name,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBadge extends StatefulWidget {
  final DateTime dueDate;

  const _CountdownBadge({required this.dueDate});

  @override
  State<_CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<_CountdownBadge> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateRemaining();
    });
  }

  void _updateRemaining() {
    setState(() {
      _remaining = widget.dueDate.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining.isNegative) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 14, color: Colors.redAccent),
          const SizedBox(width: 4),
          Text(
            'Overdue!',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);

    final String label;
    if (h > 0) {
      label = '${h}h ${m}m ${s}s';
    } else if (m > 0) {
      label = '${m}m ${s}s';
    } else {
      label = '${s}s';
    }

    final isUrgent = _remaining.inMinutes < 30;
    final color = isUrgent ? Colors.orange.shade700 : AppColors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
