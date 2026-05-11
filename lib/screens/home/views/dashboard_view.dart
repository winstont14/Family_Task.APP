import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

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

    final now = DateTime.now();
    final allActive = todos.activeTodos;
    final allDone = todos.completedTodos;
    final total = allActive.length + allDone.length;

    final overdue = allActive.where((t) =>
        t.dueDate != null && t.dueDate!.isBefore(now)).toList();
    final dueToday = allActive.where((t) =>
        t.dueDate != null && _isToday(t.dueDate!, now)).toList();
    final unassigned = allActive.where((t) => t.assignedTo == null).length;

    // Tasks with due dates, sorted earliest first
    final upNext = [...allActive]
      ..removeWhere((t) => t.dueDate == null)
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // ── Date strip ────────────────────────────────────────────
        _DateStrip(now: now),
        const SizedBox(height: 16),

        // ── Family overview card ──────────────────────────────────
        _FamilyOverviewCard(
          done: allDone.length,
          total: total,
          overdueCount: overdue.length,
          dueTodayCount: dueToday.length,
          unassignedCount: unassigned,
        ),
        const SizedBox(height: 20),

        // ── Quick stats row ───────────────────────────────────────
        _QuickStatsRow(
          total: total,
          done: allDone.length,
          overdue: overdue.length,
          dueToday: dueToday.length,
        ),
        const SizedBox(height: 20),

        // ── Member progress cards ─────────────────────────────────
        if (family.members.isNotEmpty) ...[
          _SectionHeader(label: 'Family Members', emoji: '👨‍👩‍👧‍👦'),
          const SizedBox(height: 10),
          _MemberGrid(
            members: family.members
                .map((m) => m)
                .toList(),
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
          _SectionHeader(label: 'Up Next', emoji: '⏰'),
          const SizedBox(height: 10),
          ...upNext.take(4).map((t) => _UpNextCard(
                todo: t,
                family: family,
                now: now,
              )),
        ],

        // ── Empty state ───────────────────────────────────────────
        if (total == 0)
          _EmptyDashboard(onAddTask: onAddTask, auth: auth),
      ],
    );
  }

  static bool _isToday(DateTime date, DateTime now) =>
      date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

// ── Date strip ────────────────────────────────────────────────────────

class _DateStrip extends StatelessWidget {
  final DateTime now;
  const _DateStrip({required this.now});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          DateFormat('EEEE').format(now),
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            DateFormat('MMM d').format(now),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Family overview card ──────────────────────────────────────────────

class _FamilyOverviewCard extends StatelessWidget {
  final int done;
  final int total;
  final int overdueCount;
  final int dueTodayCount;
  final int unassignedCount;

  const _FamilyOverviewCard({
    required this.done,
    required this.total,
    required this.overdueCount,
    required this.dueTodayCount,
    required this.unassignedCount,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? done / total : 0.0;
    final allDone = done == total && total > 0;
    final pct = (ratio * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: allDone
              ? [const Color(0xFF56C596), const Color(0xFF3BA87A)]
              : [AppColors.primary, const Color(0xFF9B8FF5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (allDone ? const Color(0xFF56C596) : AppColors.primary)
                .withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                  allDone ? '🎉 All done today!' : 'Family Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$pct%',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            total == 0
                ? 'No tasks yet — add one!'
                : '$done of $total tasks completed',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          if (overdueCount > 0 || unassignedCount > 0) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (overdueCount > 0)
                  _StatBadge(
                      label: '$overdueCount overdue',
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFFFD166)),
                if (dueTodayCount > 0)
                  _StatBadge(
                      label: '$dueTodayCount due today',
                      icon: Icons.today_rounded,
                      color: Colors.white.withValues(alpha: 0.85)),
                if (unassignedCount > 0)
                  _StatBadge(
                      label: '$unassignedCount unassigned',
                      icon: Icons.person_add_alt_1_rounded,
                      color: Colors.white.withValues(alpha: 0.85)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _StatBadge(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color),
        ),
      ],
    );
  }
}

// ── Quick stats row ───────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  final int total;
  final int done;
  final int overdue;
  final int dueToday;
  const _QuickStatsRow(
      {required this.total,
      required this.done,
      required this.overdue,
      required this.dueToday});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
            value: '${total - done}',
            label: 'Active',
            emoji: '📋',
            color: AppColors.primary),
        const SizedBox(width: 10),
        _StatTile(
            value: '$done',
            label: 'Done',
            emoji: '✅',
            color: const Color(0xFF52C78B)),
        const SizedBox(width: 10),
        _StatTile(
            value: '$dueToday',
            label: 'Today',
            emoji: '📅',
            color: const Color(0xFFFFAA57)),
        const SizedBox(width: 10),
        _StatTile(
            value: '$overdue',
            label: 'Overdue',
            emoji: '⚠️',
            color: overdue > 0
                ? const Color(0xFFFF7070)
                : AppColors.subtitle),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  final Color color;
  const _StatTile(
      {required this.value,
      required this.label,
      required this.emoji,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String emoji;
  const _SectionHeader({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

// ── Member grid ───────────────────────────────────────────────────────

class _MemberGrid extends StatelessWidget {
  final List members;
  final TodoProvider todos;
  final FamilyProvider family;
  final bool isAdmin;
  final void Function(String) onViewMember;
  final DateTime now;

  const _MemberGrid({
    required this.members,
    required this.todos,
    required this.family,
    required this.isAdmin,
    required this.onViewMember,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: members.length,
      itemBuilder: (_, i) {
        final m = members[i];
        final color = Color(family.colorValueForMember(m.id));
        final active = todos.activeTodosForMember(m.id);
        final done = todos.completedTodosForMember(m.id);
        final memberTotal = active.length + done.length;
        final overdueForMember = active.where((t) =>
            t.dueDate != null && t.dueDate!.isBefore(now)).length;

        return GestureDetector(
          onTap: () => onViewMember(m.id),
          child: _MemberCard(
            name: m.name,
            role: m.role,
            color: color,
            done: done.length,
            total: memberTotal,
            overdueCount: overdueForMember,
            rank: i,
          ),
        );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final Color color;
  final int done;
  final int total;
  final int overdueCount;
  final int rank;

  const _MemberCard({
    required this.name,
    required this.role,
    required this.color,
    required this.done,
    required this.total,
    required this.overdueCount,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? done / total : 0.0;
    final allDone = done == total && total > 0;
    final (roleLabel, roleEmoji) = switch (role) {
      'admin' => ('Admin', '👑'),
      'parent' => ('Parent', '👔'),
      _ => ('Kid', '🌟'),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const Spacer(),
              // Rank crown or overdue badge
              if (rank == 0 && total > 0 && ratio >= 0.5)
                const Text('🥇', style: TextStyle(fontSize: 16))
              else if (overdueCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7070).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '!$overdueCount',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF7070)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$roleEmoji $roleLabel',
            style: GoogleFonts.poppins(
                fontSize: 10, color: AppColors.subtitle),
          ),
          const Spacer(),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                    allDone ? const Color(0xFF52C78B) : color),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            total == 0
                ? 'No tasks'
                : allDone
                    ? '✅ All done!'
                    : '$done / $total done',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: allDone
                  ? const Color(0xFF52C78B)
                  : AppColors.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Up next strip ─────────────────────────────────────────────────────

class _UpNextCard extends StatelessWidget {
  final Todo todo;
  final FamilyProvider family;
  final DateTime now;

  const _UpNextCard(
      {required this.todo, required this.family, required this.now});

  @override
  Widget build(BuildContext context) {
    final dueDate = todo.dueDate!;
    final isOverdue = dueDate.isBefore(now);
    final isToday = dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
    final isTomorrow = dueDate.difference(now).inDays == 1;

    final dueBg = isOverdue
        ? const Color(0xFFFF7070)
        : isToday
            ? const Color(0xFFFFAA57)
            : AppColors.primary;

    final dueLabel = isOverdue
        ? 'Overdue'
        : isToday
            ? 'Today'
            : isTomorrow
                ? 'Tomorrow'
                : DateFormat('MMM d').format(dueDate);

    final member = todo.assignedTo != null
        ? family.findById(todo.assignedTo!)
        : null;
    final memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : AppColors.subtitle;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
          // Left accent dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dueBg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              todo.title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Member pill
          if (member != null)
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: memberColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                member.name,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: memberColor),
              ),
            ),
          // Due date badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: dueBg.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              dueLabel,
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: dueBg),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty dashboard ───────────────────────────────────────────────────

class _EmptyDashboard extends StatelessWidget {
  final VoidCallback onAddTask;
  final AuthProvider auth;
  const _EmptyDashboard({required this.onAddTask, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const Text('🏠', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            "Everything's quiet!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No tasks yet. Add one to get started.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.subtitle),
            textAlign: TextAlign.center,
          ),
          if (auth.canManageTasks) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddTask,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add first task'),
            ),
          ],
        ],
      ),
    );
  }
}
