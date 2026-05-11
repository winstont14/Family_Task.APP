import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';
import '../../add_todo/add_todo_screen.dart';
import '../family_sheet.dart';

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

    final doneToday = allDone
        .where((t) =>
            t.completedAt != null && _isToday(t.completedAt!, now))
        .length;

    final pending = todos.suggestedTodos;

    // Sort active: overdue → due today → due future → no date
    final sortedActive = [...allActive]..sort((a, b) {
        int p(Todo t) {
          if (t.dueDate == null) return 3;
          if (t.dueDate!.isBefore(now)) return 0;
          if (_isToday(t.dueDate!, now)) return 1;
          return 2;
        }
        final cmp = p(a).compareTo(p(b));
        if (cmp != 0) return cmp;
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        }
        return b.createdAt.compareTo(a.createdAt);
      });

    final myXp = isChild ? todos.xpForMember(auth.currentUser?.id) : null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // ── 1. Progress card ──────────────────────────────────────
        _ProgressCard(
          doneToday: doneToday,
          active: allActive.length,
          total: total,
          xp: myXp,
        ),
        const SizedBox(height: 20),

        // ── 2. Needs review (parent/admin only) ───────────────────
        if (!isChild && pending.isNotEmpty) ...[
          _SectionLabel(title: 'Needs Review', count: pending.length),
          const SizedBox(height: 10),
          ...pending.map((t) => _PendingCard(todo: t, family: family)),
          const SizedBox(height: 20),
        ],

        // ── 3. Active tasks ───────────────────────────────────────
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
          ...sortedActive.take(8).map(
                (t) => _SimpleTaskRow(todo: t, now: now, family: family),
              ),
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

        // ── 4. Quick actions (parent/admin only) ──────────────────
        if (auth.canManageTasks) ...[
          const SizedBox(height: 24),
          _QuickActions(
            onAddTask: onAddTask,
            onManageFamily: auth.canManageFamily
                ? () => _showFamilySheet(context)
                : null,
          ),
        ],
      ],
    );
  }

  static bool _isToday(DateTime date, DateTime now) =>
      date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;

  void _showFamilySheet(BuildContext context) {
    final family = context.read<FamilyProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: family,
        child: const FamilySheet(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// 1. Progress card
// ─────────────────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final int doneToday;
  final int active;
  final int total;
  final int? xp;

  const _ProgressCard({
    required this.doneToday,
    required this.active,
    required this.total,
    this.xp,
  });

  static const _levelTitles = [
    ('Sprout', 1),
    ('Rising Star', 2),
    ('Star', 3),
    ('Super Star', 4),
    ('Champion', 5),
    ('Legend', 6),
  ];

  @override
  Widget build(BuildContext context) {
    final done = total - active;
    final ratio = total > 0 ? done / total : 0.0;
    final allDone = done == total && total > 0;

    // XP / level info
    int level = 0;
    int xpInLevel = 0;
    String levelTitle = '';
    if (xp != null) {
      level = TodoProvider.levelFromXp(xp!);
      xpInLevel = TodoProvider.xpInCurrentLevel(xp!);
      final idx = (level - 1).clamp(0, _levelTitles.length - 1);
      levelTitle = _levelTitles[idx].$1;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  value: '$doneToday',
                  label: 'done today',
                  valueColor: allDone
                      ? const Color(0xFF52C78B)
                      : AppColors.primary,
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.subtitle.withValues(alpha: 0.15),
              ),
              Expanded(
                child: _StatBlock(
                  value: '$active',
                  label: 'remaining',
                  valueColor: active > 0
                      ? AppColors.text
                      : const Color(0xFF52C78B),
                  align: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 7,
                backgroundColor:
                    AppColors.subtitle.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  allDone
                      ? const Color(0xFF52C78B)
                      : AppColors.primary,
                ),
              ),
            ),
          ),

          // Child: XP level line
          if (xp != null) ...[
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: AppColors.subtitle.withValues(alpha: 0.08),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Level $level · $levelTitle',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '$xpInLevel / 100 XP',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.subtitle),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: xpInLevel / 100,
                minHeight: 4,
                backgroundColor:
                    AppColors.primary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withValues(alpha: 0.6)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final TextAlign align;

  const _StatBlock({
    required this.value,
    required this.label,
    required this.valueColor,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: align == TextAlign.left ? 0 : 20,
        right: align == TextAlign.right ? 0 : 20,
      ),
      child: Column(
        crossAxisAlignment: align == TextAlign.left
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.subtitle),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────

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
            padding:
                const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
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

// ─────────────────────────────────────────────────────────────────────
// Pending card (parent approval flow)
// ─────────────────────────────────────────────────────────────────────

class _PendingCard extends StatelessWidget {
  final Todo todo;
  final FamilyProvider family;
  const _PendingCard({required this.todo, required this.family});

  @override
  Widget build(BuildContext context) {
    final member = todo.assignedTo != null
        ? family.findById(todo.assignedTo!)
        : null;
    final memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : AppColors.subtitle;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Member avatar
          if (member != null) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: memberColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                member.name[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: memberColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Task info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (member != null)
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.subtitle,
                    ),
                  ),
                Text(
                  todo.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Approve button
          _IconAction(
            icon: Icons.check_rounded,
            color: const Color(0xFF52C78B),
            onTap: () =>
                context.read<TodoProvider>().approveSuggestion(todo),
          ),
          const SizedBox(width: 4),
          // Reject button
          _IconAction(
            icon: Icons.close_rounded,
            color: AppColors.deleteRed,
            onTap: () => context.read<TodoProvider>().deleteTodo(todo),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconAction(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Simple task row (dashboard only — fast, minimal)
// ─────────────────────────────────────────────────────────────────────

class _SimpleTaskRow extends StatelessWidget {
  final Todo todo;
  final DateTime now;
  final FamilyProvider family;
  const _SimpleTaskRow(
      {required this.todo, required this.now, required this.family});

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        todo.dueDate != null && todo.dueDate!.isBefore(now);
    final isToday = todo.dueDate != null &&
        todo.dueDate!.year == now.year &&
        todo.dueDate!.month == now.month &&
        todo.dueDate!.day == now.day;

    Color? dueBadgeColor;
    String? dueLabel;
    if (isOverdue) {
      dueBadgeColor = AppColors.deleteRed;
      dueLabel = 'Overdue';
    } else if (isToday) {
      dueBadgeColor = const Color(0xFFFFAA57);
      dueLabel = 'Today';
    } else if (todo.dueDate != null) {
      dueBadgeColor = AppColors.subtitle;
      dueLabel = DateFormat('MMM d').format(todo.dueDate!);
    }

    return GestureDetector(
      onTap: () => context.read<TodoProvider>().toggleTodo(todo),
      onLongPress: context.read<AuthProvider>().canManageTasks
          ? () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddTodoScreen(existingTodo: todo),
              )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: todo.isDone
              ? AppColors.background
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: todo.isDone
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isDone
                    ? const Color(0xFF52C78B)
                    : Colors.transparent,
                border: Border.all(
                  color: todo.isDone
                      ? const Color(0xFF52C78B)
                      : AppColors.subtitle.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: todo.isDone
                  ? const Icon(Icons.check_rounded,
                      size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            // Title
            Expanded(
              child: Text(
                todo.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: todo.isDone
                      ? AppColors.subtitle
                      : AppColors.text,
                  decoration: todo.isDone
                      ? TextDecoration.lineThrough
                      : null,
                  decorationColor: AppColors.subtitle,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Due date badge
            if (dueLabel != null) ...[
              const SizedBox(width: 8),
              Text(
                dueLabel,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: dueBadgeColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Empty section
// ─────────────────────────────────────────────────────────────────────

class _EmptySection extends StatelessWidget {
  final bool isChild;
  final bool canAdd;
  final VoidCallback? onAddTask;
  const _EmptySection(
      {required this.isChild, required this.canAdd, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.subtitle),
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

// ─────────────────────────────────────────────────────────────────────
// Quick action buttons
// ─────────────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback? onManageFamily;
  const _QuickActions(
      {required this.onAddTask, this.onManageFamily});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _ActionButton(
            label: 'Add Task',
            icon: Icons.add_rounded,
            color: AppColors.primary,
            onTap: onAddTask,
          ),
        ),
        if (onManageFamily != null) ...[
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: _ActionButton(
              label: 'Family',
              icon: Icons.group_rounded,
              color: AppColors.subtitle,
              filled: false,
              onTap: onManageFamily!,
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: filled ? color : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: filled
              ? null
              : Border.all(
                  color: AppColors.subtitle.withValues(alpha: 0.2)),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: filled ? Colors.white : AppColors.subtitle),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: filled ? Colors.white : AppColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
