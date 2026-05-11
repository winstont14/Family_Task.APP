import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class TaskListHeader extends StatelessWidget {
  final String? selectedMemberId;
  final String? effectiveMemberId;
  final int statusFilter; // 0=All  1=Today  2=Pending
  final ValueChanged<int> onStatusFilter;
  final ValueChanged<String?> onMemberSelect;
  final VoidCallback? onManageFamily;
  final VoidCallback onAddTask;

  const TaskListHeader({
    super.key,
    required this.selectedMemberId,
    required this.effectiveMemberId,
    required this.statusFilter,
    required this.onStatusFilter,
    required this.onMemberSelect,
    this.onManageFamily,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();
    final todos = context.watch<TodoProvider>();

    final active = todos.activeTodosForMember(effectiveMemberId);
    final done = todos.completedTodosForMember(effectiveMemberId);
    final total = active.length + done.length;
    final allDone = total > 0 && done.length == total;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title + summary + add button ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tasks',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                if (active.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${active.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (total > 0) ...[
                  Text(
                    allDone
                        ? '🎉 All done!'
                        : '${done.length} of $total done',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: allDone
                          ? const Color(0xFF2E7D32)
                          : AppColors.subtitle,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                if (auth.canManageTasks)
                  GestureDetector(
                    onTap: onAddTask,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
              ],
            ),
          ),

          // ── Status filter chips ────────────────────────────────
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _StatusChip(
                  label: 'All',
                  selected: statusFilter == 0,
                  onTap: () => onStatusFilter(0),
                ),
                _StatusChip(
                  label: 'Today',
                  selected: statusFilter == 1,
                  onTap: () => onStatusFilter(1),
                ),
                _StatusChip(
                  label: 'Pending',
                  selected: statusFilter == 2,
                  onTap: () => onStatusFilter(2),
                ),
              ],
            ),
          ),

          // ── Member filter chips (parent/admin only) ────────────
          if (auth.canManageTasks && family.members.isNotEmpty)
            _CompactMemberRow(
              selectedMemberId: selectedMemberId,
              onSelect: onMemberSelect,
              onManage: onManageFamily,
              family: family,
            ),

          const SizedBox(height: 8),
          Container(
            height: 1,
            color: AppColors.subtitle.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}

// ── Status filter chip ────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.subtitle.withValues(alpha: 0.2),
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.subtitle,
          ),
        ),
      ),
    );
  }
}

// ── Compact member row ────────────────────────────────────────────────

class _CompactMemberRow extends StatelessWidget {
  final String? selectedMemberId;
  final ValueChanged<String?> onSelect;
  final VoidCallback? onManage;
  final FamilyProvider family;

  const _CompactMemberRow({
    required this.selectedMemberId,
    required this.onSelect,
    required this.onManage,
    required this.family,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _MemberPill(
              label: 'All',
              isSelected: selectedMemberId == null,
              color: AppColors.primary,
              icon: Icons.people_rounded,
              onTap: () => onSelect(null),
            ),
            ...family.members.map((m) {
              final color =
                  Color(family.colorValueForMember(m.id));
              return _MemberPill(
                label: m.name,
                isSelected: selectedMemberId == m.id,
                color: color,
                emoji: m.emoji,
                initial: m.name[0].toUpperCase(),
                onTap: () => onSelect(m.id),
              );
            }),
            if (onManage != null)
              _MemberPill(
                label: 'Manage',
                isSelected: false,
                color: AppColors.subtitle,
                icon: Icons.settings_rounded,
                onTap: onManage!,
              ),
          ],
        ),
      ),
    );
  }
}

class _MemberPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final String? emoji;
  final String? initial;
  final IconData? icon;

  const _MemberPill({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
    this.emoji,
    this.initial,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;
    if (emoji != null) {
      avatarChild = Text(emoji!, style: const TextStyle(fontSize: 11));
    } else if (initial != null) {
      avatarChild = Text(
        initial!,
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : color,
        ),
      );
    } else {
      avatarChild = Icon(icon!, size: 11,
          color: isSelected ? Colors.white : color);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(right: 6),
        padding:
            const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : AppColors.subtitle.withValues(alpha: 0.2),
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: avatarChild,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.text,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 3),
              const Icon(Icons.check_rounded,
                  size: 11, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
