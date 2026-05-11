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

const _kRoles = [
  _RoleOption(
    value: 'admin',
    emoji: '👑',
    label: 'Admin',
    description: 'Manages the family workspace',
    tone: Color(0xFFFFF3CD),
    ink: Color(0xFF8B6914),
  ),
  _RoleOption(
    value: 'parent',
    emoji: '👔',
    label: 'Parent',
    description: 'Assigns tasks to kids',
    tone: Color(0xFFDCEEFD),
    ink: Color(0xFF1A6EA8),
  ),
  _RoleOption(
    value: 'child',
    emoji: '🌟',
    label: 'Kid',
    description: 'Does tasks, earns stars',
    tone: Color(0xFFD4F1E4),
    ink: Color(0xFF1A7A4A),
  ),
];

class _RoleOption {
  final String value;
  final String emoji;
  final String label;
  final String description;
  final Color tone;
  final Color ink;

  const _RoleOption({
    required this.value,
    required this.emoji,
    required this.label,
    required this.description,
    required this.tone,
    required this.ink,
  });
}

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
  String _selectedRole = 'admin';
  String _selectedIcon = '🏠';
  bool _nameError = false;
  bool _familyNameError = false;
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
      setState(() => _nameError = false);
    }
    if (_currentPage == 2) {
      final pin = _pinCtrl.text.trim();
      if (pin.isNotEmpty && pin.length != 4) {
        setState(() => _pinError = true);
        return;
      }
      setState(() => _pinError = false);
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
    final member = await family.addMember(
      _nameCtrl.text.trim(),
      _selectedRole,
      pin: pin.isEmpty ? null : pin,
    );
    await auth.login(member);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF6),
      body: SafeArea(
        child: Column(
          children: [
            _ProgressBar(current: _currentPage, total: 3),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _Page1(
                    ctrl: _familyNameCtrl,
                    icon: _selectedIcon,
                    hasError: _familyNameError,
                    onChanged: (_) => setState(() => _familyNameError = false),
                  ),
                  _Page2(
                    ctrl: _nameCtrl,
                    hasError: _nameError,
                    onChanged: (_) => setState(() => _nameError = false),
                  ),
                  _Page3(
                    selectedRole: _selectedRole,
                    selectedIcon: _selectedIcon,
                    pinCtrl: _pinCtrl,
                    pinError: _pinError,
                    onRoleChanged: (r) => setState(() => _selectedRole = r),
                    onIconChanged: (ic) => setState(() => _selectedIcon = ic),
                    onPinChanged: (_) => setState(() => _pinError = false),
                  ),
                ],
              ),
            ),
            _NavBar(
              currentPage: _currentPage,
              onBack: _currentPage > 0 ? _back : null,
              onNext: _next,
              isLast: _currentPage == 2,
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

  const _NavBar({
    required this.currentPage,
    required this.onBack,
    required this.onNext,
    required this.isLast,
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
                child: Text(
                  'Back',
                  style: GoogleFonts.poppins(
                      fontSize: 15, color: const Color(0xFF4a4a4a)),
                ),
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
                isLast ? "Let's go →" : 'Next →',
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

// ─────────────────────────── Page 1 ─────────────────────────────────
// Workspace & family name

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
          // Icon preview
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
            child: Text(
              'icon set on last step',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: const Color(0xFF8a8a8a)),
            ),
          ),

          const SizedBox(height: 32),

          Text(
            'Name your workspace',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1f1f1f),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This is your family\'s shared space',
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF8a8a8a)),
          ),

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

// ─────────────────────────── Page 2 ─────────────────────────────────
// Your name

class _Page2 extends StatelessWidget {
  final TextEditingController ctrl;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _Page2({
    required this.ctrl,
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
                color: const Color(0xFFD4E4FC),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text('👤', style: TextStyle(fontSize: 38)),
            ),
          ),

          const SizedBox(height: 36),

          Text(
            'What\'s your name?',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1f1f1f),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You\'ll be the first member of the family',
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF8a8a8a)),
          ),

          const SizedBox(height: 28),

          _Label('YOUR NAME'),
          const SizedBox(height: 8),
          _Field(
            controller: ctrl,
            hint: 'e.g. Alex',
            prefixIcon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
            hasError: hasError,
            errorText: hasError ? 'Please enter your name' : null,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Page 3 ─────────────────────────────────
// Choose role + family icon

class _Page3 extends StatelessWidget {
  final String selectedRole;
  final String selectedIcon;
  final TextEditingController pinCtrl;
  final bool pinError;
  final ValueChanged<String> onRoleChanged;
  final ValueChanged<String> onIconChanged;
  final ValueChanged<String> onPinChanged;

  const _Page3({
    required this.selectedRole,
    required this.selectedIcon,
    required this.pinCtrl,
    required this.pinError,
    required this.onRoleChanged,
    required this.onIconChanged,
    required this.onPinChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Almost there!',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1f1f1f),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose your role, set a PIN, and pick a family icon',
            style: GoogleFonts.poppins(
                fontSize: 13, color: const Color(0xFF8a8a8a)),
          ),

          const SizedBox(height: 28),

          _Label('YOUR ROLE'),
          const SizedBox(height: 10),
          Column(
            children: _kRoles
                .map((r) => _RoleCard(
                      option: r,
                      selected: selectedRole == r.value,
                      onTap: () => onRoleChanged(r.value),
                    ))
                .toList(),
          ),

          const SizedBox(height: 24),

          _Label('PIN (OPTIONAL)'),
          const SizedBox(height: 4),
          Text(
            'Protects your profile — must be exactly 4 digits if set',
            style: GoogleFonts.poppins(
                fontSize: 11, color: const Color(0xFF8a8a8a)),
          ),
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

          const SizedBox(height: 24),

          _Label('FAMILY ICON'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(ic, style: const TextStyle(fontSize: 22)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final _RoleOption option;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? option.tone : Colors.white,
          border: Border.all(
            color: selected
                ? option.ink.withValues(alpha: 0.5)
                : const Color(0xFF4a4a4a).withValues(alpha: 0.2),
            width: selected ? 1.8 : 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(option.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1f1f1f),
                    ),
                  ),
                  Text(
                    option.description,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: const Color(0xFF8a8a8a)),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFFD0D0D0),
                  width: 1.8,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
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
      style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF1f1f1f)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF8a8a8a)),
        prefixIcon: Icon(prefixIcon,
            color: hasError ? Colors.redAccent : const Color(0xFF8a8a8a),
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
