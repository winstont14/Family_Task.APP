import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';
import '../widgets/dashboard_cards.dart';
import '../widgets/member_grid.dart';
import '../widgets/up_next_card.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback onAddTask;
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
    final allActive =
        isChild ? todos.activeTodosForMember(myId) : todos.activeTodos;
    final allDone =
        isChild ? todos.completedTodosForMember(myId) : todos.completedTodos;
    final total = allActive.length + allDone.length;

    final overdue = allActive
        .where((t) => t.dueDate != null && t.dueDate!.isBefore(now))
        .toList();
    final dueToday = allActive
        .where((t) => t.dueDate != null && _isToday(t.dueDate!, now))
        .toList();
    final unassigned =
        isChild ? 0 : allActive.where((t) => t.assignedTo == null).length;

    final upNext = [...allActive]
      ..removeWhere((t) => t.dueDate == null)
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        DateStrip(now: now),
        const SizedBox(height: 16),

        // ── Streak + Weekly Goal ──────────────────────────────────
        Row(
          children: [
            Expanded(child: StreakCard(streak: todos.streakDays)),
            const SizedBox(width: 10),
            Expanded(
              child: WeeklyGoalCard(
                completed: todos.completedThisWeek,
                goal: family.weeklyGoal,
                isAdmin: auth.canManageFamily,
                onEditGoal: auth.canManageFamily
                    ? () => _showGoalEditor(context, family)
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Overview card ─────────────────────────────────────────
        FamilyOverviewCard(
          label: isChild ? 'My Progress' : 'Family Progress',
          done: allDone.length,
          total: total,
          overdueCount: overdue.length,
          dueTodayCount: dueToday.length,
          unassignedCount: unassigned,
        ),
        const SizedBox(height: 20),

        // ── Quick stats ───────────────────────────────────────────
        QuickStatsRow(
          total: total,
          done: allDone.length,
          overdue: overdue.length,
          dueToday: dueToday.length,
        ),
        const SizedBox(height: 20),

        // ── Member cards (admin/parent only) ──────────────────────
        if (!isChild && family.members.isNotEmpty) ...[
          const SectionHeader(label: 'Family Members', emoji: '👨‍👩‍👧‍👦'),
          const SizedBox(height: 10),
          MemberGrid(
            members: family.members.toList(),
            todos: todos,
            family: family,
            isAdmin: auth.canManageTasks,
            onViewMember: onViewMember,
            now: now,
          ),
          const SizedBox(height: 20),
        ],

        // ── Up next ───────────────────────────────────────────────
        if (upNext.isNotEmpty) ...[
          const SectionHeader(label: 'Up Next', emoji: '⏰'),
          const SizedBox(height: 10),
          ...upNext.take(4).map((t) => UpNextCard(
                todo: t,
                family: family,
                now: now,
              )),
        ],

        // ── Empty state ───────────────────────────────────────────
        if (total == 0)
          EmptyDashboard(onAddTask: onAddTask, auth: auth),
      ],
    );
  }

  static bool _isToday(DateTime date, DateTime now) =>
      date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;

  void _showGoalEditor(BuildContext context, FamilyProvider family) {
    int draft = family.weeklyGoal;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: Text('Weekly Goal',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How many tasks should the family complete this week?',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.subtitle),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    onPressed:
                        draft > 1 ? () => setS(() => draft--) : null,
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$draft',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: () => setS(() => draft++),
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                ],
              ),
              Text('tasks / week',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.subtitle)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: AppColors.subtitle)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<FamilyProvider>().setWeeklyGoal(draft);
                Navigator.pop(ctx);
              },
              child: Text('Save',
                  style:
                      GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
