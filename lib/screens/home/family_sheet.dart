import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../providers/family_provider.dart';

class FamilySheet extends StatefulWidget {
  const FamilySheet({super.key});

  @override
  State<FamilySheet> createState() => _FamilySheetState();
}

class _FamilySheetState extends State<FamilySheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _familyNameCtrl;
  late final TextEditingController _pinCtrl;
  String _selectedRole = 'child';
  bool _pinError = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _pinCtrl = TextEditingController();
    _familyNameCtrl = TextEditingController(
      text: context.read<FamilyProvider>().familyName,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    _familyNameCtrl.dispose();
    super.dispose();
  }

  void _addMember() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final pin = _pinCtrl.text.trim();

    if (pin.isNotEmpty && pin.length != 4) {
      setState(() => _pinError = true);
      return;
    }

    setState(() => _pinError = false);
    context.read<FamilyProvider>().addMember(
          name,
          _selectedRole,
          pin: pin.isEmpty ? null : pin,
        );
    _nameCtrl.clear();
    _pinCtrl.clear();
    FocusScope.of(context).unfocus();
  }

  void _saveFamilyName() {
    context.read<FamilyProvider>().setFamilyName(_familyNameCtrl.text);
    FocusScope.of(context).unfocus();
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
            const SizedBox(height: 24),
            Text(
              'Family Members',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            // ── Member list ────────────────────────────────────────
            if (family.members.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No members yet. Add members below.',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.subtitle),
                ),
              )
            else
              ...family.members.map((m) {
                final color = Color(family.colorValueForMember(m.id));
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: color.withValues(alpha: 0.18),
                    child: Text(
                      m.name[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  title: Text(m.name,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: AppColors.text)),
                  subtitle: Row(
                    children: [
                      Text(
                        switch (m.role) {
                          'admin' => '👑 Admin',
                          'parent' => '👔 Parent',
                          _ => '🌟 Child',
                        },
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.subtitle),
                      ),
                      if (m.pin != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.lock_outline_rounded,
                            size: 12, color: AppColors.subtitle),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.deleteRed),
                    onPressed: () =>
                        context.read<FamilyProvider>().deleteMember(m.id),
                    constraints:
                        const BoxConstraints(minWidth: 48, minHeight: 48),
                  ),
                );
              }),
            const SizedBox(height: 20),
            Text(
              'Add Member',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            // ── Add member form ────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: 'Name',
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
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _pinCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 4,
                    onChanged: (_) => setState(() => _pinError = false),
                    style: GoogleFonts.poppins(
                        fontSize: 15, color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: 'PIN',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.subtitle),
                      filled: true,
                      fillColor: _pinError
                          ? Colors.redAccent.withValues(alpha: 0.06)
                          : AppColors.background,
                      counterText: '',
                      errorText: _pinError ? '4 digits' : null,
                      errorStyle: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: _pinError
                            ? const BorderSide(
                                color: Colors.redAccent, width: 1.5)
                            : BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: _pinError
                            ? const BorderSide(
                                color: Colors.redAccent, width: 1.5)
                            : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: _pinError
                            ? const BorderSide(
                                color: Colors.redAccent, width: 2)
                            : const BorderSide(
                                color: AppColors.primary, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                DropdownButton<String>(
                  value: _selectedRole,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('👑 Admin',
                          style: GoogleFonts.poppins(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'parent',
                      child: Text('👔 Parent',
                          style: GoogleFonts.poppins(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'child',
                      child: Text('🌟 Child',
                          style: GoogleFonts.poppins(fontSize: 14)),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedRole = v ?? 'child'),
                ),
                const Spacer(),
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text('Add',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
