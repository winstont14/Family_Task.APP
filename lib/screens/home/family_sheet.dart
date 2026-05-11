import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../providers/family_provider.dart';
import 'add_member_sheet.dart';

class FamilySheet extends StatefulWidget {
  const FamilySheet({super.key});

  @override
  State<FamilySheet> createState() => _FamilySheetState();
}

class _FamilySheetState extends State<FamilySheet> {
  late final TextEditingController _familyNameCtrl;

  @override
  void initState() {
    super.initState();
    _familyNameCtrl = TextEditingController(
      text: context.read<FamilyProvider>().familyName,
    );
  }

  @override
  void dispose() {
    _familyNameCtrl.dispose();
    super.dispose();
  }

  void _saveFamilyName() {
    context.read<FamilyProvider>().setFamilyName(_familyNameCtrl.text);
    FocusScope.of(context).unfocus();
  }

  void _openAddMember() {
    final family = context.read<FamilyProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: family,
        child: const AddMemberSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.subtitle.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Family Workspace',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 14),

            // ── Family name ────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _familyNameCtrl,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: 'Family name',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.subtitle),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveFamilyName(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saveFamilyName,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Save',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── Members header ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Family Members',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Text(
                  '${family.members.length} member${family.members.length == 1 ? '' : 's'}',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.subtitle),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Member list ────────────────────────────────────────
            if (family.members.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No members yet — add your first family member below.',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.subtitle),
                ),
              )
            else
              ...family.members.map((m) {
                final color = Color(family.colorValueForMember(m.id));
                return _MemberRow(
                  name: m.name,
                  role: m.role,
                  hasPin: m.pin != null,
                  color: color,
                  onDelete: () =>
                      context.read<FamilyProvider>().deleteMember(m.id),
                );
              }),

            const SizedBox(height: 20),

            // ── Add member button ──────────────────────────────────
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _openAddMember,
                icon: const Icon(Icons.person_add_rounded, size: 20),
                label: Text(
                  'Add Family Member',
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Member row ─────────────────────────────────────────────────────

class _MemberRow extends StatelessWidget {
  final String name;
  final String role;
  final bool hasPin;
  final Color color;
  final VoidCallback onDelete;

  const _MemberRow({
    required this.name,
    required this.role,
    required this.hasPin,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final (String emoji, String label) = switch (role) {
      'admin' => ('👑', 'Admin'),
      'parent' => ('🧑', 'Parent'),
      _ => ('👧', 'Child'),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar
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
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$emoji $label',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.subtitle),
                      ),
                      if (hasPin) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.lock_outline_rounded,
                            size: 12, color: AppColors.subtitle),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Delete
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.deleteRed, size: 20),
              onPressed: onDelete,
              constraints:
                  const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
