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

class DashboardTaskRow extends StatelessWidget {
  final Todo todo;
  final DateTime now;
  final FamilyProvider family;

  const DashboardTaskRow({
    super.key,
    required this.todo,
    required this.now,
    required this.family,
  });

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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              todo.isDone ? AppColors.background : Colors.white,
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
