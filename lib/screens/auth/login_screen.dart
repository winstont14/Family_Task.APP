import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/family_member.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();

    if (!family.hasAdmin) {
      return const _AdminSetupScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                family.familyName,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Who are you? 👋',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: AppColors.subtitle,
                ),
              ),
              const SizedBox(height: 36),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: family.members.length,
                  itemBuilder: (ctx, i) {
                    final m = family.members[i];
                    final color = Color(family.colorValueForMember(m.id));
                    return _MemberTile(member: m, color: color);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Member Tile ────────────────────────────

class _MemberTile extends StatelessWidget {
  final FamilyMember member;
  final Color color;

  const _MemberTile({required this.member, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Text(
              member.name[0].toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _RoleBadge(role: member.role),
          if (member.pin != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(Icons.lock_outline_rounded,
                  size: 13, color: AppColors.subtitle),
            ),
        ],
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

// ─────────────────────────── Role Badge ─────────────────────────────

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final (label, bg) = switch (role) {
      'admin' => ('👑 Admin', const Color(0xFFFFF3CD)),
      'parent' => ('👔 Parent', const Color(0xFFDCEEFD)),
      _ => ('🌟 Child', const Color(0xFFD4F1E4)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
    );
  }
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
    if (_entered.length == 4) {
      Future.microtask(_verify);
    }
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
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.member.name,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.subtitle),
            ),
            const SizedBox(height: 24),
            // PIN dots
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
                            : AppColors.subtitle.withValues(alpha: 0.25),
                  ),
                );
              }),
            ),
            if (_error)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Wrong PIN — try again',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.redAccent),
                ),
              ),
            const SizedBox(height: 24),
            // Numpad rows 1-9
            ...List.generate(3, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (col) {
                  final digit = (row * 3 + col + 1).toString();
                  return _DigitButton(
                      digit: digit, onTap: () => _onDigit(digit));
                }),
              );
            }),
            // Bottom row: empty / 0 / backspace
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
                        color: AppColors.subtitle),
                    onPressed: _onDelete,
                    iconSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppColors.subtitle),
              ),
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
            color: AppColors.text,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────── Admin Setup Screen ──────────────────────────

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
    if (familyName.isEmpty || name.isEmpty) return;

    final family = context.read<FamilyProvider>();
    final auth = context.read<AuthProvider>();

    await family.setFamilyName(familyName);
    final pin = _pinCtrl.text.trim();
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 56, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome! 👋',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Set up your family workspace.',
                style: GoogleFonts.poppins(
                    fontSize: 16, color: AppColors.subtitle),
              ),
              const SizedBox(height: 44),
              _Label('Family name'),
              const SizedBox(height: 8),
              _SetupField(
                controller: _familyNameCtrl,
                hint: 'e.g. Smith Family',
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: 24),
              _Label('Your name'),
              const SizedBox(height: 8),
              _SetupField(
                controller: _nameCtrl,
                hint: 'e.g. Alex',
                icon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),
              _Label('PIN (optional)'),
              const SizedBox(height: 8),
              _SetupField(
                controller: _pinCtrl,
                hint: '4-digit PIN',
                icon: Icons.lock_outline_rounded,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: _obscurePin,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePin
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.subtitle,
                    size: 20,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePin = !_obscurePin),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are the Admin — you can manage all members and tasks.',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.subtitle),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: _create,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    );
  }
}

class _SetupField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool obscureText;
  final Widget? suffix;
  final TextCapitalization textCapitalization;

  const _SetupField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.obscureText = false,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(fontSize: 15, color: AppColors.subtitle),
        prefixIcon: Icon(icon, color: AppColors.subtitle, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppColors.subtitle.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: AppColors.subtitle.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Public role badge export so home_screen can reuse it ──
class RoleBadge extends StatelessWidget {
  final String role;
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) => _RoleBadge(role: role);
}
