import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/todo_provider.dart';

class DashboardProgressCard extends StatelessWidget {
  final int doneToday;
  final int active;
  final int total;
  final int? xp; // non-null for child role

  const DashboardProgressCard({
    super.key,
    required this.doneToday,
    required this.active,
    required this.total,
    this.xp,
  });

  static const _levelTitles = [
    'Sprout',
    'Rising Star',
    'Star',
    'Super Star',
    'Champion',
    'Legend',
  ];

  @override
  Widget build(BuildContext context) {
    final done = total - active;
    final ratio = total > 0 ? done / total : 0.0;
    final allDone = done == total && total > 0;

    int level = 0;
    int xpInLevel = 0;
    String levelTitle = '';
    if (xp != null) {
      level = TodoProvider.levelFromXp(xp!);
      xpInLevel = TodoProvider.xpInCurrentLevel(xp!);
      levelTitle = _levelTitles[(level - 1).clamp(0, _levelTitles.length - 1)];
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Done / remaining stats
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  value: '$doneToday',
                  label: 'done today',
                  valueColor: allDone
                      ? const Color(0xFF52C78B)
                      : AppColors.primary,
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.subtitle.withValues(alpha: 0.15),
              ),
              Expanded(
                child: _StatBlock(
                  value: '$active',
                  label: 'remaining',
                  valueColor: active > 0
                      ? AppColors.text
                      : const Color(0xFF52C78B),
                  align: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: ratio),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 7,
                backgroundColor:
                    AppColors.subtitle.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  allDone
                      ? const Color(0xFF52C78B)
                      : AppColors.primary,
                ),
              ),
            ),
          ),

          // Child: XP level
          if (xp != null) ...[
            const SizedBox(height: 12),
            Container(
                height: 1,
                color: AppColors.subtitle.withValues(alpha: 0.08)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Level $level · $levelTitle',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '$xpInLevel / 100 XP',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.subtitle),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: xpInLevel / 100,
                minHeight: 4,
                backgroundColor:
                    AppColors.primary.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withValues(alpha: 0.6)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final TextAlign align;

  const _StatBlock({
    required this.value,
    required this.label,
    required this.valueColor,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: align == TextAlign.left ? 0 : 20,
        right: align == TextAlign.right ? 0 : 20,
      ),
      child: Column(
        crossAxisAlignment: align == TextAlign.left
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.subtitle),
          ),
        ],
      ),
    );
  }
}
