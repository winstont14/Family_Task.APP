import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../providers/family_provider.dart';

const _kChildAvatars = [
  '🐶', '🐱', '🐸', '🦊', '🐼', '🐨',
  '🦁', '🦄', '🐧', '🦋', '⭐', '🌈',
];

const _kParentAvatars = [
  '😊', '🙋', '🤗', '😎', '💪', '🌟',
  '🧑', '👩', '👨', '🧑‍💼', '👩‍💼', '👨‍💼',
];

// ── Sheet host ─────────────────────────────────────────────────────

class AddMemberSheet extends StatefulWidget {
  const AddMemberSheet({super.key});

  @override
  State<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<AddMemberSheet> {
  int _step = 0; // 0=role  1=info  2=success
  String _role = 'child';
  String _avatar = _kChildAvatars.first;
  final _nameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _nameError = false;
  bool _pinError = false;
  String _addedName = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() {
      _role = role;
      _avatar = role == 'child' ? _kChildAvatars.first : _kParentAvatars.first;
      _step = 1;
    });
  }

  Future<void> _confirm() async {
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
    final provider = context.read<FamilyProvider>();
    await provider.addMember(name, _role,
        pin: pin.isEmpty ? null : pin, emoji: _avatar);
    if (!mounted) return;
    setState(() {
      _addedName = name;
      _step = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.subtitle.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Step dots (only during role & info steps)
          if (_step < 2) ...[
            const SizedBox(height: 16),
            _StepDots(step: _step),
          ],
          // Animated page content
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: switch (_step) {
                0 => _RoleStep(
                    key: const ValueKey(0),
                    onSelect: _selectRole,
                  ),
                1 => _InfoStep(
                    key: const ValueKey(1),
                    role: _role,
                    avatar: _avatar,
                    nameCtrl: _nameCtrl,
                    pinCtrl: _pinCtrl,
                    nameError: _nameError,
                    pinError: _pinError,
                    onAvatarChange: (a) => setState(() => _avatar = a),
                    onNameChange: (_) => setState(() => _nameError = false),
                    onPinChange: (_) => setState(() => _pinError = false),
                    onBack: () => setState(() => _step = 0),
                    onConfirm: _confirm,
                  ),
                _ => _SuccessStep(
                    key: const ValueKey(2),
                    name: _addedName,
                    role: _role,
                    avatar: _avatar,
                    onDone: () => Navigator.of(context).pop(),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step dots progress bar ─────────────────────────────────────────

class _StepDots extends StatelessWidget {
  final int step;
  const _StepDots({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (i) {
        final active = i == step;
        final done = i < step;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: active ? 28 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: (active || done)
                  ? AppColors.primary
                  : AppColors.subtitle.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

// ── Step 1 — Role selection ────────────────────────────────────────

class _RoleStep extends StatelessWidget {
  final void Function(String) onSelect;
  const _RoleStep({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who are you adding?',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose their role in the family',
            style:
                GoogleFonts.poppins(fontSize: 13, color: AppColors.subtitle),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  emoji: '👧',
                  title: 'Child',
                  description: 'Can complete tasks & earn rewards',
                  color: const Color(0xFF52C78B),
                  onTap: () => onSelect('child'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _RoleCard(
                  emoji: '🧑',
                  title: 'Parent',
                  description: 'Can manage tasks & review activity',
                  color: AppColors.primary,
                  onTap: () => onSelect('parent'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: color.withValues(alpha: 0.25), width: 1.5),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.subtitle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2 — Name + Avatar (+ PIN for parent) ──────────────────────

class _InfoStep extends StatelessWidget {
  final String role;
  final String avatar;
  final TextEditingController nameCtrl;
  final TextEditingController pinCtrl;
  final bool nameError;
  final bool pinError;
  final ValueChanged<String> onAvatarChange;
  final ValueChanged<String> onNameChange;
  final ValueChanged<String> onPinChange;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  static const _childAvatars = [
    '🐶', '🐱', '🐸', '🦊', '🐼', '🐨',
    '🦁', '🦄', '🐧', '🦋', '⭐', '🌈',
  ];
  static const _parentAvatars = [
    '😊', '🙋', '🤗', '😎', '💪', '🌟',
    '🧑', '👩', '👨', '🧑‍💼', '👩‍💼', '👨‍💼',
  ];

  const _InfoStep({
    super.key,
    required this.role,
    required this.avatar,
    required this.nameCtrl,
    required this.pinCtrl,
    required this.nameError,
    required this.pinError,
    required this.onAvatarChange,
    required this.onNameChange,
    required this.onPinChange,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final avatars = role == 'child' ? _childAvatars : _parentAvatars;
    final Color accent =
        role == 'child' ? const Color(0xFF52C78B) : AppColors.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Big avatar preview
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                avatar,
                key: ValueKey(avatar),
                style: const TextStyle(fontSize: 68),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            role == 'child' ? 'Add a child' : 'Add a parent',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role == 'child'
                ? "They'll complete tasks and earn rewards"
                : "They'll manage tasks and review activity",
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.subtitle),
          ),
          const SizedBox(height: 22),

          // Name field
          TextField(
            controller: nameCtrl,
            textCapitalization: TextCapitalization.words,
            onChanged: onNameChange,
            style:
                GoogleFonts.poppins(fontSize: 16, color: AppColors.text),
            decoration: InputDecoration(
              hintText: role == 'child' ? "Child's name" : "Parent's name",
              hintStyle: GoogleFonts.poppins(
                  fontSize: 15, color: AppColors.subtitle),
              errorText: nameError ? 'Please enter a name' : null,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: accent, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.redAccent, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Avatar picker label
          Text(
            'CHOOSE AN AVATAR',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: AppColors.subtitle,
            ),
          ),
          const SizedBox(height: 10),

          // Avatar grid
          GridView.count(
            crossAxisCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: avatars.map((a) {
              final picked = a == avatar;
              return GestureDetector(
                onTap: () => onAvatarChange(a),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  decoration: BoxDecoration(
                    color: picked
                        ? accent.withValues(alpha: 0.12)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: picked
                        ? Border.all(color: accent, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(a,
                      style: const TextStyle(fontSize: 22)),
                ),
              );
            }).toList(),
          ),

          // PIN (parent only)
          if (role == 'parent') ...[
            const SizedBox(height: 20),
            Text(
              'PIN (OPTIONAL)',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
                color: AppColors.subtitle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Protects this profile — exactly 4 digits',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.subtitle),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pinCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onPinChange,
              style:
                  GoogleFonts.poppins(fontSize: 16, color: AppColors.text),
              decoration: InputDecoration(
                hintText: '••••',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 15, color: AppColors.subtitle),
                errorText:
                    pinError ? 'PIN must be exactly 4 digits' : null,
                counterText: '',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accent, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
              ),
            ),
          ],

          const SizedBox(height: 28),

          Row(
            children: [
              OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.subtitle.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.poppins(
                      fontSize: 15, color: AppColors.subtitle),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Add to Family',
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Step 3 — Success screen ────────────────────────────────────────

class _SuccessStep extends StatefulWidget {
  final String name;
  final String role;
  final String avatar;
  final VoidCallback onDone;

  const _SuccessStep({
    super.key,
    required this.name,
    required this.role,
    required this.avatar,
    required this.onDone,
  });

  @override
  State<_SuccessStep> createState() => _SuccessStepState();
}

class _SuccessStepState extends State<_SuccessStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 44),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          ScaleTransition(
            scale: _scale,
            child: Text(widget.avatar,
                style: const TextStyle(fontSize: 80)),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fade,
            child: Column(
              children: [
                Text(
                  '🎉 ${widget.name} joined the family!',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.role == 'child'
                      ? 'They can now complete tasks and earn rewards'
                      : 'They can now manage family tasks',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.subtitle),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          FadeTransition(
            opacity: _fade,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
