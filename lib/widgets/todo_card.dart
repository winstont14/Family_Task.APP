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

class TodoCard extends StatefulWidget {
  final Todo todo;
  const TodoCard({super.key, required this.todo});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _bounceAnim = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.06)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.06, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
    ]).animate(_bounceCtrl);
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleToggle(BuildContext context) async {
    final wasIncomplete = !widget.todo.isDone;
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final provider = context.read<TodoProvider>();

    if (wasIncomplete) _bounceCtrl.forward(from: 0);

    await provider.toggleTodo(widget.todo);

    if (!mounted) return;
    if (wasIncomplete && auth.isChild) {
      final xp = TodoProvider.xpForTask(widget.todo.starRating);
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('🎉', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                '+$xp XP earned! Great job!',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF52C78B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();
    final canManage = auth.canManageTasks;

    final member = widget.todo.assignedTo != null
        ? family.findById(widget.todo.assignedTo!)
        : null;
    final memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : AppColors.primary;

    final accentColor = widget.todo.colorValue != null
        ? Color(widget.todo.colorValue!)
        : memberColor;

    final card = ScaleTransition(
      scale: _bounceAnim,
      child: GestureDetector(
        onLongPress: canManage ? () => _openEdit(context) : null,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: widget.todo.isDone
                ? const Color(0xFFEEFBF0)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.todo.isDone
                  ? const Color(0xFF52C78B).withValues(alpha: 0.3)
                  : const Color(0xFF4a4a4a).withValues(alpha: 0.07),
              width: 1,
            ),
            boxShadow: widget.todo.isDone
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.045),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Colored left accent bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 5,
                    color: widget.todo.isDone
                        ? const Color(0xFF52C78B).withValues(alpha: 0.6)
                        : accentColor,
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox
                          GestureDetector(
                            onTap: () => _handleToggle(context),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.todo.isDone
                                      ? const Color(0xFF52C78B)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: widget.todo.isDone
                                        ? const Color(0xFF52C78B)
                                        : AppColors.subtitle
                                            .withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                ),
                                child: widget.todo.isDone
                                    ? const Icon(Icons.check_rounded,
                                        size: 16, color: Colors.white)
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
                                Text(
                                  widget.todo.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: widget.todo.isDone
                                        ? AppColors.subtitle
                                        : AppColors.text,
                                    decoration: widget.todo.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: AppColors.subtitle,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Reward (prominent, full row if present)
                                if (widget.todo.reward != null &&
                                    widget.todo.reward!.isNotEmpty) ...[
                                  _RewardBadge(text: widget.todo.reward!),
                                  const SizedBox(height: 5),
                                ],
                                // Other badges
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    if (widget.todo.isSuggestion == true)
                                      const _PendingBadge(),
                                    if (member != null)
                                      _MemberBadge(
                                          member: member,
                                          color: memberColor),
                                    if (!widget.todo.isDone &&
                                        widget.todo.dueDate != null)
                                      _CountdownBadge(
                                          dueDate: widget.todo.dueDate!)
                                    else if (widget.todo.isDone &&
                                        widget.todo.dueDate != null)
                                      _DateBadge(
                                          date: widget.todo.dueDate!),
                                    if (widget.todo.starRating != null &&
                                        widget.todo.starRating! > 0)
                                      _StarsBadge(
                                          stars: widget.todo.starRating!),
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
                                  widget.todo.isSuggestion == true) ...[
                                _ActionBtn(
                                  icon: Icons.check_circle_outline_rounded,
                                  color: const Color(0xFF52C78B),
                                  onTap: () => context
                                      .read<TodoProvider>()
                                      .approveSuggestion(widget.todo),
                                ),
                              ] else if (canManage && !widget.todo.isDone)
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
      ),
    );

    if (!canManage) return card;

    return Dismissible(
      key: Key(widget.todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 28),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.deleteRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 28),
      ),
      onDismissed: (_) =>
          context.read<TodoProvider>().deleteTodo(widget.todo),
      child: card,
    );
  }

  void _openEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTodoScreen(existingTodo: widget.todo),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete task?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('"${widget.todo.title}"',
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
              context.read<TodoProvider>().deleteTodo(widget.todo);
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

// ── Action icon button ────────────────────────────────────────────────

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
        padding: const EdgeInsets.all(7),
        child: Icon(icon, size: 21, color: color),
      ),
    );
  }
}

// ── Pending approval badge ────────────────────────────────────────────

class _PendingBadge extends StatelessWidget {
  const _PendingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA57).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: const Color(0xFFFFAA57).withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💡', style: TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
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
        (_) => const Text('⭐', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}

// ── Reward badge (prominent) ──────────────────────────────────────────

class _RewardBadge extends StatelessWidget {
  final String text;
  const _RewardBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎁', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8B6914)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Member badge ──────────────────────────────────────────────────────

class _MemberBadge extends StatelessWidget {
  final dynamic member;
  final Color color;
  const _MemberBadge({required this.member, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15,
            height: 15,
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
          const SizedBox(width: 5),
          Text(
            member.name,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}

// ── Date badge (completed tasks) ──────────────────────────────────────

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
        const SizedBox(width: 4),
        Text(
          DateFormat('MMM d').format(date),
          style: GoogleFonts.poppins(
              fontSize: 11, color: AppColors.subtitle),
        ),
      ],
    );
  }
}

// ── Countdown badge (live timer) ──────────────────────────────────────

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
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
