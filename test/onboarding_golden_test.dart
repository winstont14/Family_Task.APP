import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/family_member.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/family_provider.dart';

// ── Stub providers (no Hive needed) ──────────────────────────────────

class _FakeFamily extends FamilyProvider {
  final bool _hasAdmin;
  final List<FamilyMember> _members;
  final String _name;

  _FakeFamily(
      {bool hasAdmin = false,
      List<FamilyMember>? members,
      String name = 'The Smiths'})
      : _hasAdmin = hasAdmin,
        _members = members ?? [],
        _name = name;

  @override
  bool get hasAdmin => _hasAdmin;
  @override
  List<FamilyMember> get members => _members;
  @override
  String get familyName => _name;
  @override
  int colorValueForMember(String id) {
    const c = [
      0xFF5B8DEF,
      0xFFAB86E8,
      0xFF52C78B,
      0xFFFF9460,
      0xFFFF7BAC,
      0xFF4ECDC4
    ];
    final i = _members.indexWhere((m) => m.id == id);
    return c[(i < 0 ? 0 : i) % c.length];
  }
}

class _FakeAuth extends AuthProvider {
  @override
  bool get isLoggedIn => false;
  @override
  FamilyMember? get currentUser => null;
  @override
  Future<void> login(FamilyMember m) async {}
}

// ── Minimal inline onboarding widgets using only system fonts ─────────

const _ink = Color(0xFF1f1f1f);
const _soft = Color(0xFF8a8a8a);
const _accent = Color(0xFF5B8DEF);
const _paper = Color(0xFFFBFAF6);

const _avatarBg = [
  Color(0xFFD4E4FC),
  Color(0xFFDCD0F0),
  Color(0xFFC9E4CA),
  Color(0xFFF6CFB8),
  Color(0xFFFFD6E8),
  Color(0xFFB2F0ED),
];

// V2 — Admin setup (inline, no GoogleFonts)
class _V2Setup extends StatelessWidget {
  const _V2Setup();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Create workspace',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: _ink)),
              const SizedBox(height: 4),
              const Text('all in one place',
                  style:
                      TextStyle(fontSize: 10, letterSpacing: 1, color: _soft)),
              const SizedBox(height: 36),
              _label('FAMILY NAME'),
              const SizedBox(height: 8),
              _thinField('e.g. The Smiths', Icons.home_outlined),
              const SizedBox(height: 22),
              _label('YOUR NAME (ADMIN)'),
              const SizedBox(height: 8),
              _thinField('e.g. Alex', Icons.person_outline_rounded),
              const SizedBox(height: 22),
              _label('PIN (OPTIONAL)'),
              const SizedBox(height: 4),
              const Text('must be exactly 4 digits if set',
                  style: TextStyle(fontSize: 11, color: _soft)),
              const SizedBox(height: 8),
              _thinField('••••', Icons.lock_outline_rounded),
              const SizedBox(height: 22),
              _label('ADD CHILDREN'),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                _childChip('E', 'Emma', const Color(0xFFC9E4CA)),
                _childChip('L', 'Leo', const Color(0xFFF6CFB8)),
                _addChip(),
              ]),
              const SizedBox(height: 36),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Create family →',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                  "You'll be Admin — add more family members from the home screen.",
                  style: TextStyle(fontSize: 11, color: _soft),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _soft,
          letterSpacing: 1));

  Widget _thinField(String hint, IconData icon) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFF4a4a4a).withValues(alpha: 0.35),
              width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          Icon(icon, size: 19, color: _soft),
          const SizedBox(width: 10),
          Text(hint, style: const TextStyle(fontSize: 14, color: _soft)),
        ]),
      );

  Widget _childChip(String initial, String name, Color tone) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color(0xFF4a4a4a).withValues(alpha: 0.35),
              width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(shape: BoxShape.circle, color: tone),
            alignment: Alignment.center,
            child: Text(initial,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4a4a4a))),
          ),
          const SizedBox(width: 5),
          Text(name, style: const TextStyle(fontSize: 11, color: _ink)),
        ]),
      );

  Widget _addChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: _soft.withValues(alpha: 0.5), width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('+ add another',
            style: TextStyle(fontSize: 11, color: _soft)),
      );
}

// V6 — Profile picker (inline, no GoogleFonts)
class _V6Picker extends StatelessWidget {
  final List<FamilyMember> members;
  const _V6Picker({required this.members});

  @override
  Widget build(BuildContext context) {
    final family = context.read<FamilyProvider>();
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 48),
          const Text("Who's using this?",
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: _ink),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          const Text('this device is shared',
              style: TextStyle(fontSize: 13, color: _soft),
              textAlign: TextAlign.center),
          const SizedBox(height: 28),
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
                itemCount: members.length + 1,
                itemBuilder: (ctx, i) {
                  if (i == members.length) return _addCard();
                  final m = members[i];
                  final mc = Color(family.colorValueForMember(m.id));
                  final bg = _avatarBg[i % _avatarBg.length];
                  return _memberCard(m, mc, bg);
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 12, 28, 28),
            child: Text('parent · 4-digit PIN',
                style: TextStyle(fontSize: 12, color: _soft),
                textAlign: TextAlign.center),
          ),
        ]),
      ),
    );
  }

  Widget _memberCard(FamilyMember m, Color mc, Color bg) {
    final hasPin = m.pin != null;
    final isProtected = hasPin && (m.role == 'admin' || m.role == 'parent');
    final (label, pillBg, pillFg) = switch (m.role) {
      'admin' when isProtected => ('👑 Admin 🔒', _accent, Colors.white),
      'parent' when isProtected => ('👔 Parent 🔒', _accent, Colors.white),
      'admin' => ('👑 Admin', const Color(0xFFFFF3CD), const Color(0xFF8B6914)),
      'parent' => (
          '👔 Parent',
          const Color(0xFFDCEEFD),
          const Color(0xFF1A6EA8)
        ),
      _ => ('🌟 Kid', const Color(0xFFD4F1E4), const Color(0xFF1A7A4A)),
    };
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _ink.withValues(alpha: 0.18), width: 1.6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
          alignment: Alignment.center,
          child: Text(m.name[0].toUpperCase(),
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: mc)),
        ),
        const SizedBox(height: 10),
        Text(m.name,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: _ink),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              color: pillBg, borderRadius: BorderRadius.circular(999)),
          child: Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, color: pillFg)),
        ),
      ]),
    );
  }

  Widget _addCard() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _soft.withValues(alpha: 0.55), width: 1.4),
        ),
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('+',
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w300, color: _soft)),
              SizedBox(height: 2),
              Text('add', style: TextStyle(fontSize: 11, color: _soft)),
            ]),
      );
}

// ── Tests ─────────────────────────────────────────────────────────────

Widget _wrap(Widget child, FamilyProvider fam) => MultiProvider(
      providers: [
        ChangeNotifierProvider<FamilyProvider>.value(value: fam),
        ChangeNotifierProvider<AuthProvider>.value(value: _FakeAuth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: _paper, useMaterial3: true),
        home: child,
      ),
    );

void main() {
  testWidgets('V2 Admin Setup Screen golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(_wrap(const _V2Setup(), _FakeFamily()));
    await tester.pump();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/v2_admin_setup.png'));
  });

  testWidgets('V6 Profile Picker golden', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    final members = [
      FamilyMember(id: '1', name: 'Maya', role: 'admin', pin: '1234'),
      FamilyMember(id: '2', name: 'Sam', role: 'parent', pin: null),
      FamilyMember(id: '3', name: 'Emma', role: 'child', pin: null),
      FamilyMember(id: '4', name: 'Leo', role: 'child', pin: null),
    ];
    final fam = _FakeFamily(hasAdmin: true, members: members);
    await tester.pumpWidget(_wrap(_V6Picker(members: members), fam));
    await tester.pump();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/v6_profile_picker.png'));
  });
}
