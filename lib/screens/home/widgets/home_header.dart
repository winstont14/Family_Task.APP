import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_provider.dart';

class HomeHeader extends StatelessWidget {
  // Legacy params kept so home_screen.dart compiles unchanged;
  // only onManageFamily and onLogout are used now.
  final String? selectedMemberId;
  final String? effectiveMemberId;
  final bool showFilters;
  final ValueChanged<String?> onMemberSelect;
  final VoidCallback? onManageFamily;
  final VoidCallback onLogout;

  const HomeHeader({
    super.key,
    this.selectedMemberId,
    this.effectiveMemberId,
    this.showFilters = false,
    required this.onMemberSelect,
    required this.onManageFamily,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();
    final user = auth.currentUser;
    final memberColor = user != null
        ? Color(family.colorValueForMember(user.id))
        : AppColors.primary;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── House icon circle ──────────────────────────
                GestureDetector(
                  onTap: onManageFamily,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.22),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      family.familyIcon,
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // ── Family name + manage chevron ───────────────
                Expanded(
                  child: GestureDetector(
                    onTap: onManageFamily,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            family.familyName,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onManageFamily != null) ...[
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // ── Profile avatar ─────────────────────────────
                GestureDetector(
                  onTap: () => _showProfileSheet(context, user, memberColor),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: memberColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: memberColor.withValues(alpha: 0.35),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: user?.emoji != null
                        ? Text(user!.emoji!,
                            style: const TextStyle(fontSize: 18))
                        : Text(
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
          Container(
            height: 1,
            color: AppColors.subtitle.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }

  void _showProfileSheet(BuildContext context, dynamic user, Color memberColor) {
    final role = user?.role ?? '';
    final (roleLabel, roleBg, roleFg) = switch (role) {
      'admin' =>
        ('👑 Admin', const Color(0xFFFFF3CD), const Color(0xFF8B6914)),
      'parent' =>
        ('👔 Parent', const Color(0xFFDCEEFD), const Color(0xFF1A6EA8)),
      _ => ('🌟 Kid', const Color(0xFFD4F1E4), const Color(0xFF1A7A4A)),
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.subtitle.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Large avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: memberColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: memberColor.withValues(alpha: 0.4),
                  width: 3,
                ),
              ),
              alignment: Alignment.center,
              child: user?.emoji != null
                  ? Text(user!.emoji!,
                      style: const TextStyle(fontSize: 34))
                  : Text(
                      user?.name[0].toUpperCase() ?? '?',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: memberColor,
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            // Name
            Text(
              user?.name ?? '',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),

            // Role pill
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: roleBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                roleLabel,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: roleFg,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onLogout();
                },
                icon: const Icon(Icons.logout_rounded,
                    color: AppColors.deleteRed, size: 18),
                label: Text(
                  'Log out',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deleteRed,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                      color: AppColors.deleteRed.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
