import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/todo_provider.dart';

// ── XP / Level card (child only) ─────────────────────────────────────

class XpLevelCard extends StatelessWidget {
  final int xp;
  const XpLevelCard({super.key, required this.xp});

  static const _levelTitles = [
    ('🌱', 'Sprout'),
    ('⭐', 'Rising Star'),
    ('🌟', 'Star'),
    ('💫', 'Super Star'),
    ('🏆', 'Champion'),
    ('👑', 'Legend'),
  ];

  int get _level => TodoProvider.levelFromXp(xp);
  int get _xpInLevel => TodoProvider.xpInCurrentLevel(xp);

  @override
  Widget build(BuildContext context) {
    final idx = (_level - 1).clamp(0, _levelTitles.length - 1);
    final (emoji, title) = _levelTitles[idx];
    final ratio = _xpInLevel / 100.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9B8FF5), Color(0xFFFF6B9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B8FF5).withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $_level · $title',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$xp XP total',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$_xpInLevel / 100 XP · Level ${_level + 1} in ${100 - _xpInLevel} XP',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pending approvals banner (parent/admin only) ──────────────────────

class PendingApprovalsBanner extends StatelessWidget {
  final int count;
  const PendingApprovalsBanner({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA57).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFFFAA57).withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count task${count > 1 ? 's' : ''} waiting for approval',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFCC7700),
                  ),
                ),
                Text(
                  'Open List tab → approve or reject',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.subtitle),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.subtitle),
        ],
      ),
    );
  }
}

// ── Date strip ────────────────────────────────────────────────────────

class DateStrip extends StatelessWidget {
  final DateTime now;
  const DateStrip({super.key, required this.now});

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
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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

// ── Streak card ───────────────────────────────────────────────────────

class StreakCard extends StatelessWidget {
  final int streak;
  const StreakCard({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final isHot = streak >= 3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isHot
            ? const Color(0xFFFFF3E0)
            : AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHot
              ? const Color(0xFFFFAA57).withValues(alpha: 0.5)
              : AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Text(
            streak > 0 ? '🔥' : '💤',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streak day${streak == 1 ? '' : 's'}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isHot ? const Color(0xFFCC7700) : AppColors.text,
                ),
              ),
              Text(
                'Streak',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.subtitle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Weekly goal card ──────────────────────────────────────────────────

class WeeklyGoalCard extends StatelessWidget {
  final int completed;
  final int goal;
  final bool isAdmin;
  final VoidCallback? onEditGoal;

  const WeeklyGoalCard({
    super.key,
    required this.completed,
    required this.goal,
    required this.isAdmin,
    this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = goal > 0 ? (completed / goal).clamp(0.0, 1.0) : 0.0;
    final met = completed >= goal && goal > 0;

    return GestureDetector(
      onTap: onEditGoal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: met
              ? const Color(0xFFE8F5E9)
              : const Color(0xFFEEF0FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: met
                ? const Color(0xFF52C78B).withValues(alpha: 0.4)
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  met ? '🎯' : '📆',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Weekly Goal',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.subtitle),
                  ),
                ),
                if (isAdmin)
                  const Icon(Icons.edit_outlined,
                      size: 14, color: AppColors.subtitle),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$completed / $goal',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: met ? const Color(0xFF2E7D32) : AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (_, v, __) => LinearProgressIndicator(
                  value: v,
                  minHeight: 5,
                  backgroundColor:
                      AppColors.subtitle.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    met ? const Color(0xFF52C78B) : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Family overview card ──────────────────────────────────────────────

class FamilyOverviewCard extends StatelessWidget {
  final String label;
  final int done;
  final int total;
  final int overdueCount;
  final int dueTodayCount;
  final int unassignedCount;

  const FamilyOverviewCard({
    super.key,
    required this.label,
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
            color:
                (allDone ? const Color(0xFF56C596) : AppColors.primary)
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
                  allDone ? '🎉 All done today!' : label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
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
                backgroundColor:
                    Colors.white.withValues(alpha: 0.25),
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
              fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}

// ── Quick stats row ───────────────────────────────────────────────────

class QuickStatsRow extends StatelessWidget {
  final int total;
  final int done;
  final int overdue;
  final int dueToday;

  const QuickStatsRow({
    super.key,
    required this.total,
    required this.done,
    required this.overdue,
    required this.dueToday,
  });

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

  const _StatTile({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
  });

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

class SectionHeader extends StatelessWidget {
  final String label;
  final String emoji;
  const SectionHeader(
      {super.key, required this.label, required this.emoji});

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

// ── Empty dashboard ───────────────────────────────────────────────────

class EmptyDashboard extends StatelessWidget {
  final VoidCallback onAddTask;
  final AuthProvider auth;

  const EmptyDashboard(
      {super.key, required this.onAddTask, required this.auth});

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
