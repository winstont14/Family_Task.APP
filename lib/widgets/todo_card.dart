import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../models/todo_model.dart';
import '../providers/auth_provider.dart';
import '../providers/family_provider.dart';
import '../providers/todo_provider.dart';
import '../screens/add_todo/add_todo_screen.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();
    final canManage = auth.canManageTasks;

    final member = todo.assignedTo != null
        ? family.findById(todo.assignedTo!)
        : null;
    final memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : AppColors.primary;

    // Left accent color: member color or task color or primary
    final accentColor = todo.colorValue != null
        ? Color(todo.colorValue!)
        : memberColor;

    final card = GestureDetector(
      onLongPress: canManage ? () => _openEdit(context) : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: todo.isDone
              ? const Color(0xFFF7FBF7)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF4a4a4a).withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: todo.isDone
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colored left accent bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 5,
                  color: todo.isDone
                      ? const Color(0xFFB8D8BA)
                      : accentColor,
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Round checkbox
                        GestureDetector(
                          onTap: () => context
                              .read<TodoProvider>()
                              .toggleTodo(todo),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: todo.isDone
                                    ? const Color(0xFFB8D8BA)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: todo.isDone
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFB0B0B0),
                                  width: 2,
                                ),
                              ),
                              child: todo.isDone
                                  ? const Icon(Icons.check_rounded,
                                      size: 15,
                                      color: Color(0xFF2E7D32))
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Task text + meta
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      todo.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: todo.isDone
                                            ? AppColors.subtitle
                                            : AppColors.text,
                                        decoration: todo.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                        decorationColor: AppColors.subtitle,
                                      ),
                                    ),
                                  ),
                                  if (todo.isDone)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 4),
                                      child: Text('⭐',
                                          style:
                                              TextStyle(fontSize: 14)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: [
                                  if (todo.isSuggestion == true)
                                    _PendingBadge(),
                                  if (member != null)
                                    _MemberBadge(
                                        member: member,
                                        color: memberColor),
                                  if (!todo.isDone &&
                                      todo.dueDate != null)
                                    _CountdownBadge(
                                        dueDate: todo.dueDate!)
                                  else if (todo.isDone &&
                                      todo.dueDate != null)
                                    _DateBadge(date: todo.dueDate!),
                                  if (todo.starRating != null &&
                                      todo.starRating! > 0)
                                    _StarsBadge(
                                        stars: todo.starRating!),
                                  if (todo.reward != null &&
                                      todo.reward!.isNotEmpty)
                                    _RewardBadge(text: todo.reward!),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Action buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (canManage &&
                                todo.isSuggestion == true) ...[
                              _ActionBtn(
                                icon: Icons.check_circle_outline_rounded,
                                color: const Color(0xFF52C78B),
                                onTap: () => context
                                    .read<TodoProvider>()
                                    .approveSuggestion(todo),
                              ),
                            ] else if (canManage && !todo.isDone)
                              _ActionBtn(
                                icon: Icons.edit_outlined,
                                color: AppColors.subtitle,
                                onTap: () => _openEdit(context),
                              ),
                            if (canManage)
                              _ActionBtn(
                                icon: Icons.delete_outline_rounded,
                                color: AppColors.deleteRed,
                                onTap: () => _confirmDelete(context),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!canManage) return card;

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 28),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.deleteRed,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 28),
      ),
      onDismissed: (_) => context.read<TodoProvider>().deleteTodo(todo),
      child: card,
    );
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Delete task?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('"${todo.title}"',
            style: GoogleFonts.poppins(
                fontSize: 15, color: AppColors.subtitle)),
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

// ── Small action icon button ─────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

// ── Pending approval badge ───────────────────────────────────────────

class _PendingBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA57).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: const Color(0xFFFFAA57).withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💡', style: TextStyle(fontSize: 9)),
          const SizedBox(width: 3),
          Text('Pending',
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFCC7700))),
        ],
      ),
    );
  }
}

// ── Stars badge ───────────────────────────────────────────────────────

class _StarsBadge extends StatelessWidget {
  final int stars;
  const _StarsBadge({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        stars,
        (_) => const Text('⭐', style: TextStyle(fontSize: 11)),
      ),
    );
  }
}

// ── Reward badge ──────────────────────────────────────────────────────

class _RewardBadge extends StatelessWidget {
  final String text;
  const _RewardBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎁', style: TextStyle(fontSize: 9)),
          const SizedBox(width: 3),
          Text(
            text,
            style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8B6914)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Member badge ─────────────────────────────────────────────────────

class _MemberBadge extends StatelessWidget {
  final dynamic member;
  final Color color;
  const _MemberBadge({required this.member, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.25),
            ),
            alignment: Alignment.center,
            child: Text(
              member.name[0].toUpperCase(),
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: color),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            member.name,
            style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color),
          ),
        ],
      ),
    );
  }
}

// ── Date badge (for completed tasks) ────────────────────────────────

class _DateBadge extends StatelessWidget {
  final DateTime date;
  const _DateBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.calendar_today_rounded,
            size: 11, color: AppColors.subtitle),
        const SizedBox(width: 3),
        Text(
          DateFormat('MMM d').format(date),
          style: GoogleFonts.poppins(
              fontSize: 11, color: AppColors.subtitle),
        ),
      ],
    );
  }
}

// ── Countdown badge ──────────────────────────────────────────────────

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
      return _badge(
          Icons.warning_amber_rounded, 'Overdue!', Colors.redAccent);
    }
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    final label = h > 0
        ? '${h}h ${m}m'
        : m > 0
            ? '${m}m ${s}s'
            : '${s}s';
    final isUrgent = _remaining.inMinutes < 30;
    final color =
        isUrgent ? Colors.orange.shade700 : AppColors.primary;
    return _badge(Icons.timer_outlined, label, color);
  }

  Widget _badge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ],
      ),
    );
  }
}
