import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';

class DashboardQuickActions extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback? onManageFamily;

  const DashboardQuickActions({
    super.key,
    required this.onAddTask,
    this.onManageFamily,
  });

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
            filled: true,
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
    required this.filled,
    required this.onTap,
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
          boxShadow: [
            BoxShadow(
              color: filled
                  ? color.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: filled ? 10 : 8,
              offset: Offset(0, filled ? 4 : 2),
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
