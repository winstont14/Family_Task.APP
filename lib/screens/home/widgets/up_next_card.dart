import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/family_provider.dart';

class UpNextCard extends StatelessWidget {
  final Todo todo;
  final FamilyProvider family;
  final DateTime now;

  const UpNextCard({
    super.key,
    required this.todo,
    required this.family,
    required this.now,
  });

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

    final member =
        todo.assignedTo != null ? family.findById(todo.assignedTo!) : null;
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
