import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/colors.dart';

class ProgressWidget extends StatelessWidget {
  final int completed;
  final int total;

  const ProgressWidget({
    super.key,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? completed / total : 0.0;
    final percent = (ratio * 100).round();
    final allDone = completed == total && total > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: allDone
              ? [const Color(0xFFE8F5E9), const Color(0xFFF1F8E9)]
              : [
                  AppColors.primary.withValues(alpha: 0.07),
                  AppColors.primary.withValues(alpha: 0.03),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allDone
              ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                allDone ? '🎉 All done!' : '⭐ Progress',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: allDone
                      ? const Color(0xFF2E7D32)
                      : AppColors.text,
                ),
              ),
              const Spacer(),
              Text(
                '$completed / $total',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.subtitle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: allDone
                      ? const Color(0xFF4CAF50)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$percent%',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 12,
                backgroundColor:
                    AppColors.subtitle.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                  allDone
                      ? const Color(0xFF4CAF50)
                      : AppColors.primary,
                ),
              ),
            ),
          ),
          if (allDone)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Amazing work! You completed everything 🌟',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF388E3C),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
