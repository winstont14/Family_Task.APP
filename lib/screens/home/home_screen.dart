import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/todo_model.dart';
import '../../providers/family_provider.dart';
import '../../providers/todo_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/progress_widget.dart';
import '../../widgets/section_title.dart';
import '../../widgets/todo_card.dart';
import '../add_todo/add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedMemberId;

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyProvider>();

    // Reset filter if the selected member was deleted
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
              onManageFamily: _showFamilySheet,
              onEditName: _showUsernameSheet,
            ),
            Consumer<TodoProvider>(
              builder: (context, todos, _) {
                final active =
                    todos.activeTodosForMember(_selectedMemberId);
                final done =
                    todos.completedTodosForMember(_selectedMemberId);
                final total = active.length + done.length;
                if (total == 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: ProgressWidget(
                    completed: done.length,
                    total: total,
                  ),
                );
              },
            ),
            if (family.members.isNotEmpty)
              _MemberFilterChips(
                selectedMemberId: _selectedMemberId,
                onSelect: (id) => setState(() => _selectedMemberId = id),
                onManage: _showFamilySheet,
              ),
            Expanded(
              child: _TaskList(selectedMemberId: _selectedMemberId),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTodo,
        icon: const Icon(Icons.add_rounded, size: 28),
        label: Text(
          'Add Task',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
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

  void _showUsernameSheet() {
    final user = context.read<UserProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: user,
        child: const _UsernameSheet(),
      ),
    );
  }
}

// ─────────────────────────── Family Header ───────────────────────────

class _FamilyHeader extends StatelessWidget {
  final VoidCallback onManageFamily;
  final VoidCallback onEditName;

  const _FamilyHeader({
    required this.onManageFamily,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final family = context.watch<FamilyProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 16, 8),
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
                        '${family.familyName} 👨‍👩‍👧‍👦',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.settings_outlined,
                          size: 16, color: AppColors.subtitle),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onEditName,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hello, ${user.displayName} 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.edit_outlined,
                          size: 14, color: AppColors.subtitle),
                    ],
                  ),
                ),
                Text(
                  'What do you want to do today?',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.subtitle),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onManageFamily,
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: const Icon(Icons.people_outline_rounded,
                  color: AppColors.primary, size: 22),
            ),
            tooltip: 'Manage Family',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Member Filter Chips ─────────────────────────

class _MemberFilterChips extends StatelessWidget {
  final String? selectedMemberId;
  final ValueChanged<String?> onSelect;
  final VoidCallback onManage;

  const _MemberFilterChips({
    required this.selectedMemberId,
    required this.onSelect,
    required this.onManage,
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
  final String? selectedMemberId;

  const _TaskList({required this.selectedMemberId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final active = provider.activeTodosForMember(selectedMemberId);
        final completed =
            provider.completedTodosForMember(selectedMemberId);

        if (active.isEmpty && completed.isEmpty) {
          return const EmptyState();
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            if (active.isNotEmpty) ...[
              const SectionTitle(title: 'TODAY'),
              ...active.map((todo) => TodoCard(todo: todo)),
            ],
            if (completed.isNotEmpty) ...[
              const SectionTitle(title: 'COMPLETED'),
              ...completed.map((todo) => TodoCard(todo: todo)),
            ],
          ],
        );
      },
    );
  }
}

// ──────────────────────────── Username Sheet ──────────────────────────────

class _UsernameSheet extends StatefulWidget {
  const _UsernameSheet();

  @override
  State<_UsernameSheet> createState() => _UsernameSheetState();
}

class _UsernameSheetState extends State<_UsernameSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: context.read<UserProvider>().username);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    context.read<UserProvider>().setUsername(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
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
              'Your name',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Used in the greeting on the home screen.',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.subtitle),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              style: GoogleFonts.poppins(
                  fontSize: 18, color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 16, color: AppColors.subtitle),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
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
  late final TextEditingController _nameController;
  late final TextEditingController _familyNameController;
  String _selectedRole = 'child';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _familyNameController = TextEditingController(
      text: context.read<FamilyProvider>().familyName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  void _addMember() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    context.read<FamilyProvider>().addMember(name, _selectedRole);
    _nameController.clear();
    FocusScope.of(context).unfocus();
  }

  void _saveFamilyName() {
    context.read<FamilyProvider>().setFamilyName(_familyNameController.text);
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

            // Family name row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _familyNameController,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: 'Family name (e.g. Smith Family)',
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
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
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
                  'No members yet. Add members below to assign tasks.',
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
                  title: Text(
                    m.name,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                  ),
                  subtitle: Text(
                    m.role == 'parent' ? '👑 Parent' : '🌟 Child',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.subtitle),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.deleteRed),
                    onPressed: () =>
                        context.read<FamilyProvider>().deleteMember(m.id),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 15, color: AppColors.subtitle),
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
                    onSubmitted: (_) => _addMember(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedRole,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    DropdownMenuItem(
                      value: 'child',
                      child: Text('Child',
                          style: GoogleFonts.poppins(fontSize: 14)),
                    ),
                    DropdownMenuItem(
                      value: 'parent',
                      child: Text('Parent',
                          style: GoogleFonts.poppins(fontSize: 14)),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedRole = v ?? 'child'),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _addMember,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Icon(Icons.add_rounded, size: 22),
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
