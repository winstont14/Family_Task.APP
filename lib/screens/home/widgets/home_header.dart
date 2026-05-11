import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class HomeHeader extends StatelessWidget {
  final String? selectedMemberId;
  final String? effectiveMemberId;
  final bool showFilters;
  final ValueChanged<String?> onMemberSelect;
  final VoidCallback? onManageFamily;
  final VoidCallback onLogout;

  const HomeHeader({
    super.key,
    required this.selectedMemberId,
    required this.effectiveMemberId,
    required this.showFilters,
    required this.onMemberSelect,
    required this.onManageFamily,
    required this.onLogout,
  });

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    if (h < 21) return 'Good evening';
    return 'Good night';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();
    final todos = context.watch<TodoProvider>();
    final user = auth.currentUser;

    final memberColor = user != null
        ? Color(family.colorValueForMember(user.id))
        : AppColors.primary;

    final active = todos.activeTodosForMember(effectiveMemberId);
    final done = todos.completedTodosForMember(effectiveMemberId);
    final total = active.length + done.length;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: family name + user avatar ──────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onManageFamily,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(family.familyIcon,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 5),
                        Text(
                          family.familyName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        if (onManageFamily != null) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.expand_more_rounded,
                              size: 14, color: AppColors.primary),
                        ],
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showLogoutMenu(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: memberColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: memberColor.withValues(alpha: 0.4),
                          width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user?.name[0].toUpperCase() ?? '?',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: memberColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Row 2: greeting + name + role pill ────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting()} 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.subtitle,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.name ?? 'there',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (user != null) _RolePill(role: user.role),
              ],
            ),
          ),

          // ── Progress bar (list tab, when tasks exist) ─────────
          if (showFilters && total > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: _SlimProgress(completed: done.length, total: total),
            ),

          // ── Member filter chips ────────────────────────────────
          if (showFilters &&
              auth.canManageTasks &&
              family.members.isNotEmpty)
            _MemberChips(
              selectedMemberId: selectedMemberId,
              onSelect: onMemberSelect,
              onManage: onManageFamily,
            ),

          const SizedBox(height: 10),
          Container(
            height: 1,
            color: AppColors.subtitle.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }

  void _showLogoutMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.subtitle.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout_rounded,
                  color: AppColors.deleteRed),
              title: Text('Log out',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.deleteRed)),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close_rounded,
                  color: AppColors.subtitle),
              title: Text('Cancel',
                  style: GoogleFonts.poppins(color: AppColors.subtitle)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slim inline progress bar ─────────────────────────────────────────

class _SlimProgress extends StatelessWidget {
  final int completed;
  final int total;
  const _SlimProgress({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? completed / total : 0.0;
    final allDone = completed == total && total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              allDone ? '🎉 All done!' : '$completed of $total tasks done',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: allDone
                    ? const Color(0xFF2E7D32)
                    : AppColors.subtitle,
              ),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: allDone
                    ? const Color(0xFF4CAF50)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${(ratio * 100).round()}%',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              minHeight: 8,
              backgroundColor:
                  AppColors.subtitle.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(
                allDone ? const Color(0xFF4CAF50) : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Role pill ────────────────────────────────────────────────────────

class _RolePill extends StatelessWidget {
  final String role;
  const _RolePill({required this.role});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (role) {
      'admin' =>
        ('👑 Admin', const Color(0xFFFFF3CD), const Color(0xFF8B6914)),
      'parent' =>
        ('👔 Parent', const Color(0xFFDCEEFD), const Color(0xFF1A6EA8)),
      _ => ('🌟 Kid', const Color(0xFFD4F1E4), const Color(0xFF1A7A4A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

// ── Member filter chips ──────────────────────────────────────────────

class _MemberChips extends StatelessWidget {
  final String? selectedMemberId;
  final ValueChanged<String?> onSelect;
  final VoidCallback? onManage;

  const _MemberChips({
    required this.selectedMemberId,
    required this.onSelect,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _Chip(
              label: 'All',
              isSelected: selectedMemberId == null,
              color: AppColors.primary,
              onTap: () => onSelect(null),
            ),
            ...family.members.map((m) {
              final color = Color(family.colorValueForMember(m.id));
              return _Chip(
                label: m.name,
                isSelected: selectedMemberId == m.id,
                color: color,
                onTap: () => onSelect(m.id),
              );
            }),
            if (onManage != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onManage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.settings_rounded,
                          size: 13, color: AppColors.subtitle),
                      const SizedBox(width: 4),
                      Text('Manage',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.subtitle)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.subtitle,
          ),
        ),
      ),
    );
  }
}
