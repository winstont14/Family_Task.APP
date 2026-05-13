import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/todo_queries.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';
import '../widgets/dashboard_pending_card.dart';
import '../widgets/dashboard_progress_card.dart';
import '../widgets/dashboard_task_row.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback onAddTask; // kept for EmptySection
  final void Function(String memberId) onViewMember;

  const DashboardView({
    super.key,
    required this.onAddTask,
    required this.onViewMember,
  });

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>();
    final family = context.watch<FamilyProvider>();
    final auth = context.watch<AuthProvider>();
    final isChild = auth.isChild;
    final now = DateTime.now();

    final myId = isChild ? auth.currentUser?.id : null;
    final myIdSet = myId != null ? {myId} : null;
    final allActive =
        isChild ? todos.activeTodosForMember(myIdSet) : todos.activeTodos;
    final allDone =
        isChild ? todos.completedTodosForMember(myIdSet) : todos.completedTodos;
    final total = allActive.length + allDone.length;

    final doneToday = allDone
        .where((t) =>
            t.completedAt != null && TodoQueries.isSameDay(t.completedAt!, now))
        .length;

    final pending = todos.suggestedTodos;

    final sortedActive =
        TodoQueries.sortedByDashboardPriority(allActive, now: now);

    final myXp = isChild ? todos.xpForMember(auth.currentUser?.id) : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // 1. Progress summary
        DashboardProgressCard(
          doneToday: doneToday,
          active: allActive.length,
          total: total,
          xp: myXp,
        ),
        const SizedBox(height: 20),

        // 2. Needs Review (parent/admin, when pending exists)
        if (!isChild && pending.isNotEmpty) ...[
          _SectionLabel(title: 'Needs Review', count: pending.length),
          const SizedBox(height: 10),
          ...pending.map((t) => DashboardPendingCard(todo: t, family: family)),
          const SizedBox(height: 20),
        ],

        // 3. Active tasks
        _SectionLabel(
          title: isChild ? 'My Tasks' : 'Active Tasks',
          count: sortedActive.length,
        ),
        const SizedBox(height: 10),
        if (sortedActive.isEmpty)
          _EmptySection(
            isChild: isChild,
            canAdd: auth.canManageTasks,
            onAddTask: onAddTask,
          )
        else ...[
          ...sortedActive
              .take(8)
              .map((t) => DashboardTaskRow(todo: t, now: now, family: family)),
          if (sortedActive.length > 8)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  '${sortedActive.length - 8} more — see List tab',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.subtitle),
                ),
              ),
            ),
        ],

      ],
    );
  }

}

// ── Section label ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;
  final int? count;
  const _SectionLabel({required this.title, this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.subtitle,
            letterSpacing: 0.8,
          ),
        ),
        if (count != null && count! > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Empty section ─────────────────────────────────────────────────────

class _EmptySection extends StatelessWidget {
  final bool isChild;
  final bool canAdd;
  final VoidCallback? onAddTask;
  const _EmptySection(
      {required this.isChild, required this.canAdd, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Text(
            isChild ? 'No tasks right now' : 'No active tasks',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isChild
                ? 'Check back later or suggest a task'
                : 'Tap Add Task to get started',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.subtitle),
          ),
          if (canAdd && onAddTask != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onAddTask,
              child: Text(
                'Add first task',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
