import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/todo_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/todo_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/progress_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/todo_card.dart';
import '../add_todo/add_todo_screen.dart';
import 'views/notion_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMemberId;
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();

    final effectiveMemberId =
        auth.isChild ? auth.currentUser?.id : _selectedMemberId;

    if (_selectedMemberId != null &&
        family.findById(_selectedMemberId!) == null) {
      _selectedMemberId = null;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FamilyHeader(
              onManageFamily: auth.canManageFamily ? _showFamilySheet : null,
              onLogout: _logout,
            ),
            // List-only extras: progress bar + member chips
            if (_navIndex == 0) ...[
              Consumer<TodoProvider>(
                builder: (context, todos, _) {
                  final active =
                      todos.activeTodosForMember(effectiveMemberId);
                  final done =
                      todos.completedTodosForMember(effectiveMemberId);
                  final total = active.length + done.length;
                  if (total == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: ProgressWidget(
                        completed: done.length, total: total),
                  );
                },
              ),
              if (auth.canManageTasks && family.members.isNotEmpty)
                _MemberFilterChips(
                  selectedMemberId: _selectedMemberId,
                  onSelect: (id) =>
                      setState(() => _selectedMemberId = id),
                  onManage:
                      auth.canManageFamily ? _showFamilySheet : null,
                ),
            ],
            Expanded(
              child: IndexedStack(
                index: _navIndex,
                children: [
                  _TaskList(effectiveMemberId: effectiveMemberId),
                  NotionView(onAddTask: _openAddTodo),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.subtitle,
        selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Notion',
          ),
        ],
      ),
      // FAB only on List + Notion tabs, and only for Admin/Parent
      floatingActionButton: auth.canManageTasks &&
              (_navIndex == 0 || _navIndex == 1)
          ? FloatingActionButton.extended(
              onPressed: _openAddTodo,
              icon: const Icon(Icons.add_rounded, size: 28),
              label: Text(
                'Add Task',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  void _openAddTodo({Todo? todo}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTodoScreen(existingTodo: todo),
    );
  }

  void _showFamilySheet() {
    final family = context.read<FamilyProvider>();
    final user = context.read<UserProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: family),
          ChangeNotifierProvider.value(value: user),
        ],
        child: const _FamilySheet(),
      ),
    );
  }

  void _logout() {
    context.read<AuthProvider>().logout();
  }
}

// ─────────────────────────── Family Header ───────────────────────────

class _FamilyHeader extends StatelessWidget {
  final VoidCallback? onManageFamily;
  final VoidCallback onLogout;

  const _FamilyHeader({
    required this.onManageFamily,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();
    final user = auth.currentUser;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 12, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onManageFamily,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${family.familyIcon} ${family.familyName}',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      if (onManageFamily != null) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.settings_outlined,
                            size: 15, color: AppColors.subtitle),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Hello, ${user?.name ?? 'there'} 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (user != null) _RolePill(role: user.role),
                  ],
                ),
                Text(
                  auth.isChild
                      ? 'Here are your tasks!'
                      : 'What do you want to do today?',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.subtitle),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded,
                color: AppColors.subtitle, size: 22),
            tooltip: 'Log out',
            constraints:
                const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ],
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String role;
  const _RolePill({required this.role});

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
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
    );
  }
}

// ─────────────────────── Member Filter Chips ─────────────────────────

class _MemberFilterChips extends StatelessWidget {
  final String? selectedMemberId;
  final ValueChanged<String?> onSelect;
  final VoidCallback? onManage;

  const _MemberFilterChips({
    required this.selectedMemberId,
    required this.onSelect,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              isSelected: selectedMemberId == null,
              color: AppColors.primary,
              onTap: () => onSelect(null),
            ),
            ...family.members.map((m) {
              final color = Color(family.colorValueForMember(m.id));
              return _FilterChip(
                label: m.name,
                isSelected: selectedMemberId == m.id,
                color: color,
                onTap: () => onSelect(m.id),
              );
            }),
            if (onManage != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onManage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.subtitle.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined,
                          size: 14, color: AppColors.subtitle),
                      const SizedBox(width: 4),
                      Text(
                        'Manage',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.subtitle),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? color
                : AppColors.subtitle.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.subtitle,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── Task List ─────────────────────────────

class _TaskList extends StatelessWidget {
  final String? effectiveMemberId;

  const _TaskList({required this.effectiveMemberId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final active =
            provider.activeTodosForMember(effectiveMemberId);
        final completed =
            provider.completedTodosForMember(effectiveMemberId);

        if (active.isEmpty && completed.isEmpty) {
          return const EmptyState();
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            if (active.isNotEmpty) ...[
              SectionTitle(
                  title: 'TODAY',
                  count: active.length,
                  emoji: '📅'),
              ...active.map((todo) => TodoCard(todo: todo)),
            ],
            if (completed.isNotEmpty) ...[
              SectionTitle(
                  title: 'DONE',
                  count: completed.length,
                  emoji: '✅'),
              ...completed.map((todo) => TodoCard(todo: todo)),
            ],
          ],
        );
      },
    );
  }
}

// ──────────────────────────── Family Sheet ────────────────────────────────

class _FamilySheet extends StatefulWidget {
  const _FamilySheet();

  @override
  State<_FamilySheet> createState() => _FamilySheetState();
}

class _FamilySheetState extends State<_FamilySheet> {
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
    context
        .read<FamilyProvider>()
        .setFamilyName(_familyNameCtrl.text);
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0, vertical: 2),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        color.withValues(alpha: 0.18),
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
                            fontSize: 12,
                            color: AppColors.subtitle),
                      ),
                      if (m.pin != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.lock_outline_rounded,
                            size: 12, color: AppColors.subtitle),
                      ],
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.deleteRed),
                    onPressed: () => context
                        .read<FamilyProvider>()
                        .deleteMember(m.id),
                    constraints: const BoxConstraints(
                        minWidth: 48, minHeight: 48),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
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
