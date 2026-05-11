import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/todo_provider.dart';
import '../../../widgets/todo_card.dart';

class TaskListView extends StatefulWidget {
  final String? effectiveMemberId;

  const TaskListView({super.key, required this.effectiveMemberId});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  bool _completedExpanded = false;

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>();
    final auth = context.watch<AuthProvider>();
    final isChild = auth.isChild;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final active = todos.activeTodosForMember(widget.effectiveMemberId);
    final completed =
        todos.completedTodosForMember(widget.effectiveMemberId);
    // Suggestions shown to parent/admin only, and only in the all-members view
    final suggested =
        auth.canManageTasks && widget.effectiveMemberId == null
            ? todos.suggestedTodos
            : <Todo>[];

    // Bucket and sort active tasks
    final overdue = active
        .where((t) =>
            t.dueDate != null &&
            _dayOf(t.dueDate!).isBefore(today))
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    final todayTasks = active
        .where((t) =>
            t.dueDate != null && _isToday(t.dueDate!, now))
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    final upcoming = active
        .where((t) =>
            t.dueDate == null ||
            _dayOf(t.dueDate!).isAfter(today))
        .toList()
      ..sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });

    final total = active.length + completed.length;
    final hasAnything = total > 0 || suggested.isNotEmpty;

    if (!hasAnything) {
      return _EmptyTaskList(isChild: isChild);
    }

    final allActiveDone =
        overdue.isEmpty && todayTasks.isEmpty && upcoming.isEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        // Progress banner
        if (total > 0) ...[
          _ProgressBanner(
            done: completed.length,
            total: total,
            isChild: isChild,
          ),
          const SizedBox(height: 16),
        ],

        // Needs Review
        if (suggested.isNotEmpty) ...[
          _SectionHeader(
            label: 'Needs Review',
            count: suggested.length,
            color: const Color(0xFFFFAA57),
          ),
          ...suggested.map((t) => TodoCard(todo: t)),
          const SizedBox(height: 4),
        ],

        // Overdue
        if (overdue.isNotEmpty) ...[
          _SectionHeader(
            label: 'Overdue',
            count: overdue.length,
            color: AppColors.deleteRed,
          ),
          ...overdue.map((t) => TodoCard(todo: t)),
          const SizedBox(height: 4),
        ],

        // Today
        if (todayTasks.isNotEmpty) ...[
          _SectionHeader(
            label: 'Today',
            count: todayTasks.length,
            color: const Color(0xFFFFAA57),
          ),
          ...todayTasks.map((t) => TodoCard(todo: t)),
          const SizedBox(height: 4),
        ],

        // Upcoming
        if (upcoming.isNotEmpty) ...[
          _SectionHeader(
            label: 'Upcoming',
            count: upcoming.length,
            color: AppColors.primary,
          ),
          ...upcoming.map((t) => TodoCard(todo: t)),
          const SizedBox(height: 4),
        ],

        // All-done celebration (active tasks cleared but completed exist)
        if (allActiveDone && suggested.isEmpty && completed.isNotEmpty)
          const _AllDoneBanner(),

        // Completed (collapsible)
        if (completed.isNotEmpty) ...[
          _CompletedHeader(
            count: completed.length,
            expanded: _completedExpanded,
            onTap: () =>
                setState(() => _completedExpanded = !_completedExpanded),
          ),
          if (_completedExpanded)
            ...completed.map((t) => TodoCard(todo: t)),
        ],
      ],
    );
  }

  static DateTime _dayOf(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static bool _isToday(DateTime date, DateTime now) =>
      date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

// ── Progress banner ────────────────────────────────────────────────

class _ProgressBanner extends StatelessWidget {
  final int done;
  final int total;
  final bool isChild;

  const _ProgressBanner({
    required this.done,
    required this.total,
    required this.isChild,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? done / total : 0.0;
    final allDone = done == total && total > 0;
    final color =
        allDone ? const Color(0xFF52C78B) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isChild ? 'My Progress' : "Today's Progress",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              Text(
                allDone ? '🎉 All done!' : '$done / $total',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SectionHeader({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Completed section header (collapsible) ─────────────────────────

class _CompletedHeader extends StatelessWidget {
  final int count;
  final bool expanded;
  final VoidCallback onTap;

  const _CompletedHeader({
    required this.count,
    required this.expanded,
    required this.onTap,
  });

  static const _green = Color(0xFF52C78B);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: _green, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              'COMPLETED',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: _green,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _green,
                ),
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: expanded ? 0.0 : -0.25,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 18, color: _green),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty & celebration states ─────────────────────────────────────

class _EmptyTaskList extends StatelessWidget {
  final bool isChild;
  const _EmptyTaskList({required this.isChild});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isChild ? '😊' : '✅',
              style: const TextStyle(fontSize: 52),
            ),
            const SizedBox(height: 16),
            Text(
              isChild ? 'No tasks for you!' : 'No active tasks',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isChild
                  ? 'Check back later — enjoy the break!'
                  : 'All clear! Add a task to get started.',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.subtitle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AllDoneBanner extends StatelessWidget {
  const _AllDoneBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF52C78B).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF52C78B).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All tasks completed!',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF52C78B),
                  ),
                ),
                Text(
                  'Amazing work today',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.subtitle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
