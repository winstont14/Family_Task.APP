import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';
import '../../../models/family_member.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class MemberGrid extends StatelessWidget {
  final List<FamilyMember> members;
  final TodoProvider todos;
  final FamilyProvider family;
  final bool isAdmin;
  final void Function(String) onViewMember;
  final DateTime now;

  const MemberGrid({
    super.key,
    required this.members,
    required this.todos,
    required this.family,
    required this.isAdmin,
    required this.onViewMember,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: members.length,
        itemBuilder: (_, i) {
          final m = members[i];
          final color = Color(family.colorValueForMember(m.id));
          final active = todos.activeTodosForMember(m.id);
          final done = todos.completedTodosForMember(m.id);
          final memberTotal = active.length + done.length;
          final overdueForMember = active
              .where((t) =>
                  t.dueDate != null && t.dueDate!.isBefore(now))
              .length;

          return GestureDetector(
            onTap: () => onViewMember(m.id),
            child: MemberCard(
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
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String role;
  final Color color;
  final int done;
  final int total;
  final int overdueCount;
  final int rank;

  const MemberCard({
    super.key,
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
      width: 140,
      margin: const EdgeInsets.only(right: 10),
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const Spacer(),
              if (rank == 0 && total > 0 && ratio >= 0.5)
                const Text('🥇', style: TextStyle(fontSize: 14))
              else if (overdueCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7070).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '!$overdueCount',
                    style: GoogleFonts.poppins(
                        fontSize: 9,
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
              fontSize: 13,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 5,
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
