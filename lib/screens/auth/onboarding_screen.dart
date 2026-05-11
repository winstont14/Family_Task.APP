import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';

const _kFamilyIcons = [
  '🏠', '🌳', '⭐', '🎨', '🏡', '🌈',
  '🦁', '🌻', '🐾', '🎯', '🚀', '❤️',
];

// ─────────────────────────── Data class ─────────────────────────────

class _MemberDraft {
  final String name;
  final String role;
  final String? pin;
  _MemberDraft({required this.name, required this.role, this.pin});
}

// ─────────────────────────── Screen ─────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _familyNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();

  int _currentPage = 0;
  String _selectedIcon = '🏠';
  final List<_MemberDraft> _newMembers = [];

  bool _familyNameError = false;
  bool _nameError = false;
  bool _pinError = false;

  @override
  void dispose() {
    _pageController.dispose();
    _familyNameCtrl.dispose();
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == 0) {
      if (_familyNameCtrl.text.trim().isEmpty) {
        setState(() => _familyNameError = true);
        return;
      }
      setState(() => _familyNameError = false);
    }
    if (_currentPage == 1) {
      if (_nameCtrl.text.trim().isEmpty) {
        setState(() => _nameError = true);
        return;
      }
      final pin = _pinCtrl.text.trim();
      if (pin.isNotEmpty && pin.length != 4) {
        setState(() => _pinError = true);
        return;
      }
      setState(() {
        _nameError = false;
        _pinError = false;
      });
    }
    if (_currentPage == 3) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  void _back() {
    if (_currentPage == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    final family = context.read<FamilyProvider>();
    final auth = context.read<AuthProvider>();
    final pin = _pinCtrl.text.trim();
    await family.setFamilyName(_familyNameCtrl.text.trim());
    await family.setFamilyIcon(_selectedIcon);
    // Creator is always admin
    final admin = await family.addMember(
      _nameCtrl.text.trim(),
      'admin',
      pin: pin.isEmpty ? null : pin,
    );
    // Add all drafted members
    for (final m in _newMembers) {
      await family.addMember(m.name, m.role, pin: m.pin);
    }
    await auth.login(admin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF6),
      body: SafeArea(
        child: Column(
          children: [
            _ProgressBar(current: _currentPage, total: 4),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  // Page 1 — Workspace name
                  _Page1(
                    ctrl: _familyNameCtrl,
                    icon: _selectedIcon,
                    hasError: _familyNameError,
                    onChanged: (_) =>
                        setState(() => _familyNameError = false),
                  ),
                  // Page 2 — Your name + PIN
                  _Page2(
                    nameCtrl: _nameCtrl,
                    pinCtrl: _pinCtrl,
                    nameError: _nameError,
                    pinError: _pinError,
                    onNameChanged: (_) =>
                        setState(() => _nameError = false),
                    onPinChanged: (_) =>
                        setState(() => _pinError = false),
                  ),
                  // Page 3 — Family icon
                  _Page3(
                    selectedIcon: _selectedIcon,
                    onIconChanged: (ic) =>
                        setState(() => _selectedIcon = ic),
                  ),
                  // Page 4 — Add family members
                  _Page4(
                    adminName: _nameCtrl.text.isEmpty
                        ? 'You'
                        : _nameCtrl.text.trim(),
                    members: _newMembers,
                    onAdd: (m) => setState(() => _newMembers.add(m)),
                    onRemove: (i) =>
                        setState(() => _newMembers.removeAt(i)),
                  ),
                ],
              ),
            ),
            _NavBar(
              currentPage: _currentPage,
              onBack: _currentPage > 0 ? _back : null,
              onNext: _next,
              isLast: _currentPage == 3,
              lastLabel: 'Go to Board →',
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Progress bar ───────────────────────────

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: List.generate(total, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: i == current ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i <= current
                    ? AppColors.primary
                    : const Color(0xFFD6D6D6),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────── Nav bar ────────────────────────────────

class _NavBar extends StatelessWidget {
  final int currentPage;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final bool isLast;
  final String lastLabel;

  const _NavBar({
    required this.currentPage,
    required this.onBack,
    required this.onNext,
    required this.isLast,
    this.lastLabel = "Let's go →",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Row(
        children: [
          if (onBack != null) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFF4a4a4a), width: 1.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Back',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: const Color(0xFF4a4a4a))),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLast ? lastLabel : 'Next →',
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Page 1 — Workspace name ────────────────

class _Page1 extends StatelessWidget {
  final TextEditingController ctrl;
  final String icon;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _Page1({
    required this.ctrl,
    required this.icon,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBE3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF4a4a4a).withValues(alpha: 0.12),
                  width: 1.4,
                ),
              ),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('icon set on step 3',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: const Color(0xFF8a8a8a))),
          ),
          const SizedBox(height: 32),
          Text('Name your workspace',
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1f1f1f))),
          const SizedBox(height: 6),
          Text('This is your family\'s shared space',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF8a8a8a))),
          const SizedBox(height: 28),
          _Label('FAMILY NAME'),
          const SizedBox(height: 8),
          _Field(
            controller: ctrl,
            hint: 'e.g. The Smiths',
            prefixIcon: Icons.home_outlined,
            textCapitalization: TextCapitalization.words,
            hasError: hasError,
            errorText: hasError ? 'Please enter a family name' : null,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Page 2 — Your name + PIN ───────────────

class _Page2 extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController pinCtrl;
  final bool nameError;
  final bool pinError;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPinChanged;

  const _Page2({
    required this.nameCtrl,
    required this.pinCtrl,
    required this.nameError,
    required this.pinError,
    required this.onNameChanged,
    required this.onPinChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFD4E4FC),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('👑', style: TextStyle(fontSize: 38)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('Auto Admin',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8B6914))),
            ),
          ),
          const SizedBox(height: 28),
          Text('What\'s your name?',
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1f1f1f))),
          const SizedBox(height: 6),
          Text('You\'ll be the Admin of this family workspace',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF8a8a8a))),
          const SizedBox(height: 28),
          _Label('YOUR NAME'),
          const SizedBox(height: 8),
          _Field(
            controller: nameCtrl,
            hint: 'e.g. Alex',
            prefixIcon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
            hasError: nameError,
            errorText: nameError ? 'Please enter your name' : null,
            onChanged: onNameChanged,
          ),
          const SizedBox(height: 24),
          _Label('PIN (OPTIONAL)'),
          const SizedBox(height: 4),
          Text('Protects your Admin profile — exactly 4 digits',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: const Color(0xFF8a8a8a))),
          const SizedBox(height: 8),
          _Field(
            controller: pinCtrl,
            hint: '••••',
            prefixIcon: Icons.lock_outline_rounded,
            hasError: pinError,
            errorText: pinError ? 'PIN must be exactly 4 digits' : null,
            onChanged: onPinChanged,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Page 3 — Family icon ───────────────────

class _Page3 extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconChanged;

  const _Page3({
    required this.selectedIcon,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                selectedIcon,
                key: ValueKey(selectedIcon),
                style: const TextStyle(fontSize: 64),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text('Pick a family icon',
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1f1f1f))),
          const SizedBox(height: 6),
          Text('This will show in the dashboard header',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF8a8a8a))),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: _kFamilyIcons.map((ic) {
              final picked = ic == selectedIcon;
              return GestureDetector(
                onTap: () => onIconChanged(ic),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: picked
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : Colors.white,
                    border: Border.all(
                      color: picked
                          ? AppColors.primary
                          : const Color(0xFF4a4a4a).withValues(alpha: 0.2),
                      width: picked ? 2.0 : 1.2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(ic, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Page 4 — Add family members ────────────

class _Page4 extends StatefulWidget {
  final String adminName;
  final List<_MemberDraft> members;
  final void Function(_MemberDraft) onAdd;
  final void Function(int) onRemove;

  const _Page4({
    required this.adminName,
    required this.members,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<_Page4> createState() => _Page4State();
}

class _Page4State extends State<_Page4> {
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  String _role = 'child';
  bool _nameError = false;
  bool _pinError = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _addMember() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    final pin = _pinCtrl.text.trim();
    if (pin.isNotEmpty && pin.length != 4) {
      setState(() => _pinError = true);
      return;
    }
    widget.onAdd(_MemberDraft(
      name: name,
      role: _role,
      pin: pin.isEmpty ? null : pin,
    ));
    _nameCtrl.clear();
    _pinCtrl.clear();
    setState(() {
      _nameError = false;
      _pinError = false;
      _role = 'child';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add your family 👨‍👩‍👧‍👦',
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1f1f1f))),
          const SizedBox(height: 6),
          Text('Add parents and kids to the workspace',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF8a8a8a))),

          const SizedBox(height: 20),

          // Admin chip (auto-added)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MemberChip(
                name: widget.adminName,
                role: 'admin',
                onRemove: null,
              ),
              for (int i = 0; i < widget.members.length; i++)
                _MemberChip(
                  name: widget.members[i].name,
                  role: widget.members[i].role,
                  onRemove: () => widget.onRemove(i),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Add member form ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF4a4a4a).withValues(alpha: 0.12),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Label('ADD A MEMBER'),
                const SizedBox(height: 12),
                _Field(
                  controller: _nameCtrl,
                  hint: 'Name',
                  prefixIcon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  hasError: _nameError,
                  errorText: _nameError ? 'Enter a name' : null,
                  onChanged: (_) => setState(() => _nameError = false),
                ),
                const SizedBox(height: 12),
                // Role toggle
                Row(
                  children: [
                    _RoleToggle(
                      label: '👔 Parent',
                      selected: _role == 'parent',
                      onTap: () => setState(() => _role = 'parent'),
                    ),
                    const SizedBox(width: 8),
                    _RoleToggle(
                      label: '🌟 Kid',
                      selected: _role == 'child',
                      onTap: () => setState(() => _role = 'child'),
                    ),
                  ],
                ),
                if (_role == 'parent') ...[
                  const SizedBox(height: 12),
                  _Field(
                    controller: _pinCtrl,
                    hint: 'PIN (optional) ••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    hasError: _pinError,
                    errorText: _pinError ? 'PIN must be 4 digits' : null,
                    onChanged: (_) => setState(() => _pinError = false),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text('Add Member',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.primary, width: 1.4),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (widget.members.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'You can also add family members later from the home screen.',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF8a8a8a)),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Member chip ──────────────────────────────────────────────────────

class _MemberChip extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onRemove;

  const _MemberChip({
    required this.name,
    required this.role,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final (emoji, bg, fg) = switch (role) {
      'admin' => ('👑', const Color(0xFFFFF3CD), const Color(0xFF8B6914)),
      'parent' => ('👔', const Color(0xFFDCEEFD), const Color(0xFF1A6EA8)),
      _ => ('🌟', const Color(0xFFD4F1E4), const Color(0xFF1A7A4A)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(name,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: fg)),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close_rounded, size: 14, color: fg),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Role toggle button ───────────────────────────────────────────────

class _RoleToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.1)
              : const Color(0xFFF5F5F5),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFF4a4a4a).withValues(alpha: 0.2),
            width: selected ? 1.8 : 1.2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                color: selected
                    ? AppColors.primary
                    : const Color(0xFF4a4a4a))),
      ),
    );
  }
}

// ─────────────────────────── Shared widgets ─────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: const Color(0xFF8a8a8a),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final TextCapitalization textCapitalization;
  final bool hasError;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool obscureText;

  const _Field({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    required this.hasError,
    required this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError
        ? Colors.redAccent
        : const Color(0xFF4a4a4a).withValues(alpha: 0.35);

    return TextField(
      controller: controller,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: obscureText,
      inputFormatters: keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      onChanged: onChanged,
      style: GoogleFonts.poppins(
          fontSize: 15, color: const Color(0xFF1f1f1f)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            fontSize: 14, color: const Color(0xFF8a8a8a)),
        prefixIcon: Icon(prefixIcon,
            color: hasError
                ? Colors.redAccent
                : const Color(0xFF8a8a8a),
            size: 19),
        errorText: errorText,
        errorStyle: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.redAccent,
            fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: hasError ? Colors.redAccent : AppColors.primary,
            width: 1.6,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}
