import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class DashboardPendingCard extends StatelessWidget {
  final Todo todo;
  final FamilyProvider family;

  const DashboardPendingCard({
    super.key,
    required this.todo,
    required this.family,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (member != null)
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.subtitle),
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
          _IconAction(
            icon: Icons.check_rounded,
            color: const Color(0xFF52C78B),
            onTap: () =>
                context.read<TodoProvider>().approveSuggestion(todo),
          ),
          const SizedBox(width: 4),
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
