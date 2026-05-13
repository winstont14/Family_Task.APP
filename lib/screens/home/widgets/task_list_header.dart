import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';

class TaskListHeader extends StatelessWidget {
  final Set<String> selectedMemberIds;
  final Set<String> effectiveMemberIds;
  final int statusFilter; // 0=All  1=Today  2=Pending
  final ValueChanged<int> onStatusFilter;
  final ValueChanged<Set<String>> onMembersChanged;
  final VoidCallback? onManageFamily;

  const TaskListHeader({
    super.key,
    required this.selectedMemberIds,
    required this.effectiveMemberIds,
    required this.statusFilter,
    required this.onStatusFilter,
    required this.onMembersChanged,
    this.onManageFamily,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Status segmented control ───────────────────────────
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SegmentedControl(
              selected: statusFilter,
              onChanged: onStatusFilter,
            ),
          ),

          // ── Member filter (parent/admin only) ──────────────────
          if (auth.canManageTasks && family.members.isNotEmpty) ...[
            const SizedBox(height: 10),
            _MemberRow(
              selectedIds: selectedMemberIds,
              onChanged: onMembersChanged,
              onManage: onManageFamily,
              family: family,
            ),
          ],

          const SizedBox(height: 10),
          Container(
              height: 1,
              color: AppColors.subtitle.withValues(alpha: 0.08)),
        ],
      ),
    );
  }
}

// ── Segmented control ─────────────────────────────────────────────────

class _SegmentedControl extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _SegmentedControl(
      {required this.selected, required this.onChanged});

  static const _labels = ['All', 'Today', 'Pending'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final isSelected = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.subtitle,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Member row (multi-select) ─────────────────────────────────────────

class _MemberRow extends StatelessWidget {
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onChanged;
  final VoidCallback? onManage;
  final FamilyProvider family;

  const _MemberRow({
    required this.selectedIds,
    required this.onChanged,
    required this.onManage,
    required this.family,
  });

  void _toggle(String id) {
    final next = Set<String>.from(selectedIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ...family.members.map((m) {
            final color = Color(family.colorValueForMember(m.id));
            final isSelected = selectedIds.contains(m.id);
            return _MemberChip(
              label: m.name,
              emoji: m.emoji,
              initial: m.name[0].toUpperCase(),
              color: color,
              isSelected: isSelected,
              onTap: () => _toggle(m.id),
            );
          }),
          if (onManage != null)
            _MemberChip(
              label: 'Manage',
              icon: Icons.settings_rounded,
              color: AppColors.subtitle,
              isSelected: false,
              onTap: onManage!,
            ),
        ],
      ),
    );
  }
}

// ── Member chip ───────────────────────────────────────────────────────

class _MemberChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final String? emoji;
  final String? initial;
  final IconData? icon;

  const _MemberChip({
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
    Widget avatar;
    if (emoji != null) {
      avatar = Text(emoji!, style: const TextStyle(fontSize: 11));
    } else if (initial != null) {
      avatar = Text(
        initial!,
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : color,
        ),
      );
    } else {
      avatar =
          Icon(icon!, size: 11, color: isSelected ? Colors.white : color);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: avatar,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : AppColors.text,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle_rounded, size: 13, color: color),
            ],
          ],
        ),
      ),
    );
  }
}
