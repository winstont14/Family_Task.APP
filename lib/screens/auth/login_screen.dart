import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/family_member.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import 'onboarding_screen.dart';

// Wireframe avatar tone backgrounds (peach · mint · lilac · lemon · pink · teal)
const _kAvatarBgTones = [
  Color(0xFFD4C5F9), // indigo  → pastel lavender
  Color(0xFFFFD6E8), // pink    → pastel rose
  Color(0xFFB5EAD7), // green   → pastel mint
  Color(0xFFFFCBAA), // orange  → pastel peach
  Color(0xFFB5D8F7), // blue    → pastel sky
  Color(0xFFE8D5F5), // purple  → pastel lilac
];

// ─────────────────────────── Router ─────────────────────────────────

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();
    if (!family.hasAdmin) return const OnboardingScreen();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF6), // --paper
      body: SafeArea(
        child: Column(
          children: [
            // ── V6 · centered header ────────────────────────────────
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Text(
                    "Who's using this?",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1f1f1f),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'this device is shared',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF8a8a8a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── V6 · 2-column member grid + add card ────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: family.members.length + 1, // +1 for add card
                  itemBuilder: (ctx, i) {
                    if (i == family.members.length) return const _AddCard();
                    final m = family.members[i];
                    final memberColor = Color(family.colorValueForMember(m.id));
                    final bgTone = _kAvatarBgTones[i % _kAvatarBgTones.length];
                    return _MemberCard(
                      member: m,
                      memberColor: memberColor,
                      avatarBg: bgTone,
                    );
                  },
                ),
              ),
            ),

            // ── V6 · footer ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
              child: Text(
                'parent · 4-digit PIN',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF8a8a8a),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Member Card · V6 ───────────────────────────

class _MemberCard extends StatelessWidget {
  final FamilyMember member;
  final Color memberColor;
  final Color avatarBg;

  const _MemberCard({
    required this.member,
    required this.memberColor,
    required this.avatarBg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF1f1f1f).withValues(alpha: 0.18),
            width: 1.6,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // XL avatar — 56 px, tone-colored background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(shape: BoxShape.circle, color: avatarBg),
              alignment: Alignment.center,
              child: Text(
                member.name[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: memberColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              member.name,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1f1f1f),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Accent-fill pill when PIN-protected (V6 spec)
            _RolePill(role: member.role, hasPin: member.pin != null),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (member.pin != null && member.pin!.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<AuthProvider>(),
          child: _PinDialog(member: member),
        ),
      );
    } else {
      context.read<AuthProvider>().login(member);
    }
  }
}

// ─────────────────────── Add Card · V6 dashed ───────────────────────

class _AddCard extends StatelessWidget {
  const _AddCard();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedBorderPainter(
        color: const Color(0xFF8a8a8a).withValues(alpha: 0.55),
        strokeWidth: 1.4,
        radius: 12,
        dashWidth: 6,
        dashSpace: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '+',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: const Color(0xFF8a8a8a),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'add',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF8a8a8a),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Dashed border painter ──────────────────────────

class _DashedRoundedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  const _DashedRoundedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
          size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashPath = _buildDashPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashPath(Path source) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final len = math.min(dashWidth, metric.length - dist);
        dest.addPath(metric.extractPath(dist, dist + len), Offset.zero);
        dist += dashWidth + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.dashWidth != dashWidth;
}

// ─────────────────────────── Role Pill ──────────────────────────────

class _RolePill extends StatelessWidget {
  final String role;
  final bool hasPin;

  const _RolePill({required this.role, required this.hasPin});

  @override
  Widget build(BuildContext context) {
    // V6 spec: accent-fill pill for PIN-protected admin/parent
    if (hasPin && (role == 'admin' || role == 'parent')) {
      final label = role == 'admin' ? '👑 Admin' : '👔 Parent';
      return _pill('$label 🔒', AppColors.primary, Colors.white);
    }

    return switch (role) {
      'admin' => _pill('👑 Admin', const Color(0xFFFFF3CD), const Color(0xFF8B6914)),
      'parent' => _pill('👔 Parent', const Color(0xFFDCEEFD), const Color(0xFF1A6EA8)),
      _ => _pill('🌟 Kid', const Color(0xFFD4F1E4), const Color(0xFF1A7A4A)),
    };
  }

  Widget _pill(String label, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      );
}

// ─────────────────────────── PIN Dialog ─────────────────────────────

class _PinDialog extends StatefulWidget {
  final FamilyMember member;
  const _PinDialog({required this.member});

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  String _entered = '';
  bool _error = false;

  void _onDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() {
      _entered += d;
      _error = false;
    });
    if (_entered.length == 4) Future.microtask(_verify);
  }

  void _onDelete() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  void _verify() {
    if (_entered == widget.member.pin) {
      Navigator.pop(context);
      context.read<AuthProvider>().login(widget.member);
    } else {
      setState(() {
        _entered = '';
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter PIN',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1f1f1f)),
            ),
            const SizedBox(height: 4),
            Text(widget.member.name,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: const Color(0xFF8a8a8a))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _entered.length;
                return Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _error
                        ? Colors.redAccent
                        : filled
                            ? AppColors.primary
                            : const Color(0xFF8a8a8a).withValues(alpha: 0.25),
                  ),
                );
              }),
            ),
            if (_error)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Wrong PIN — try again',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.redAccent)),
              ),
            const SizedBox(height: 24),
            ...List.generate(3, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (col) {
                  final digit = (row * 3 + col + 1).toString();
                  return _DigitButton(digit: digit, onTap: () => _onDigit(digit));
                }),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 72),
                _DigitButton(digit: '0', onTap: () => _onDigit('0')),
                SizedBox(
                  width: 72,
                  height: 64,
                  child: IconButton(
                    icon: const Icon(Icons.backspace_outlined,
                        color: Color(0xFF8a8a8a)),
                    onPressed: _onDelete,
                    iconSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: const Color(0xFF8a8a8a))),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitButton extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;
  const _DigitButton({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 64,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          digit,
          style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1f1f1f)),
        ),
      ),
    );
  }
}

// ─────────────────────── Admin Setup · V2 ───────────────────────────

class _AdminSetupScreen extends StatefulWidget {
  const _AdminSetupScreen();

  @override
  State<_AdminSetupScreen> createState() => _AdminSetupScreenState();
}

class _AdminSetupScreenState extends State<_AdminSetupScreen> {
  final _familyNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _obscurePin = true;
  bool _pinError = false;

  @override
  void dispose() {
    _familyNameCtrl.dispose();
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final familyName = _familyNameCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final pin = _pinCtrl.text.trim();

    if (familyName.isEmpty || name.isEmpty) return;
    if (pin.isNotEmpty && pin.length != 4) {
      setState(() => _pinError = true);
      return;
    }
    setState(() => _pinError = false);

    final family = context.read<FamilyProvider>();
    final auth = context.read<AuthProvider>();
    await family.setFamilyName(familyName);
    final member = await family.addMember(
      name,
      'admin',
      pin: pin.isEmpty ? null : pin,
    );
    await auth.login(member);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFAF6), // --paper
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── V2 · header ────────────────────────────────────────
              Text(
                'Create workspace',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1f1f1f),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'all in one place',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  letterSpacing: 1.0,
                  color: const Color(0xFF8a8a8a),
                ),
              ),

              const SizedBox(height: 36),

              // ── Family name ────────────────────────────────────────
              const _FieldLabel('Family name'),
              const SizedBox(height: 8),
              _ThinInput(
                controller: _familyNameCtrl,
                hint: 'e.g. The Smiths',
                prefixIcon: Icons.home_outlined,
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 22),

              // ── Admin name ─────────────────────────────────────────
              const _FieldLabel('Your name (Admin)'),
              const SizedBox(height: 8),
              _ThinInput(
                controller: _nameCtrl,
                hint: 'e.g. Alex',
                prefixIcon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 22),

              // ── PIN ────────────────────────────────────────────────
              const _FieldLabel('PIN (optional)'),
              const SizedBox(height: 4),
              Text(
                'must be exactly 4 digits if set',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFF8a8a8a),
                ),
              ),
              const SizedBox(height: 8),
              _ThinInput(
                controller: _pinCtrl,
                hint: '••••',
                prefixIcon: Icons.lock_outline_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 4,
                obscureText: _obscurePin,
                errorText: _pinError ? 'PIN must be exactly 4 digits' : null,
                onChanged: (_) => setState(() => _pinError = false),
                suffix: IconButton(
                  icon: Icon(
                    _obscurePin
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF8a8a8a),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePin = !_obscurePin),
                ),
              ),

              const SizedBox(height: 22),

              // ── V2 · add children (mock — visual only) ─────────────
              const _FieldLabel('add children'),
              const SizedBox(height: 8),
              const Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _ChildChip(initial: 'E', name: 'Emma', tone: Color(0xFFC9E4CA)),
                  _ChildChip(initial: 'L', name: 'Leo', tone: Color(0xFFF6CFB8)),
                  _AddChildChip(),
                ],
              ),

              const SizedBox(height: 36),

              // ── V2 · primary button ────────────────────────────────
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _create,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Create family →',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "You'll be Admin — add more family members from the home screen.",
                style: GoogleFonts.poppins(
                    fontSize: 11, color: const Color(0xFF8a8a8a)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Thin-stroke field label (V2 · wf-cap style) ───────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF8a8a8a),
        letterSpacing: 1.0,
      ),
    );
  }
}

// ── Thin-stroke input (V2 · wf-stroke-thin: 1.2px solid, 10px radius) ──

class _ThinInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _ThinInput({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final borderColor = hasError
        ? Colors.redAccent
        : const Color(0xFF4a4a4a).withValues(alpha: 0.35);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF1f1f1f)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            fontSize: 14, color: const Color(0xFF8a8a8a)),
        prefixIcon: Icon(prefixIcon,
            color: hasError ? Colors.redAccent : const Color(0xFF8a8a8a),
            size: 19),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        errorText: errorText,
        errorStyle: GoogleFonts.poppins(
            fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.w500),
        // wf-stroke-thin: 1.2px solid ink-soft, 10px radius
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

// ── Mock child chip (V2 · visual only, no logic) ─────────────────────

class _ChildChip extends StatelessWidget {
  final String initial;
  final String name;
  final Color tone;
  const _ChildChip({required this.initial, required this.name, required this.tone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4a4a4a).withValues(alpha: 0.35), width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 20, height: 20,
          decoration: BoxDecoration(shape: BoxShape.circle, color: tone),
          alignment: Alignment.center,
          child: Text(initial,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold,
                  color: const Color(0xFF4a4a4a))),
        ),
        const SizedBox(width: 5),
        Text(name, style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF1f1f1f))),
      ]),
    );
  }
}

class _AddChildChip extends StatelessWidget {
  const _AddChildChip();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedBorderPainter(
        color: const Color(0xFF8a8a8a).withValues(alpha: 0.5),
        strokeWidth: 1.2,
        radius: 10,
        dashWidth: 5,
        dashSpace: 3,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text('+ add another',
            style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF8a8a8a))),
      ),
    );
  }
}

// ── Public export so home_screen can reuse the role pill ─────────────
class RoleBadge extends StatelessWidget {
  final String role;
  final bool hasPin;
  const RoleBadge({super.key, required this.role, this.hasPin = false});

  @override
  Widget build(BuildContext context) =>
      _RolePill(role: role, hasPin: hasPin);
}
