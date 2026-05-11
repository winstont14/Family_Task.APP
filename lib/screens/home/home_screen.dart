import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/todo_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/family_provider.dart';
import '../../providers/user_provider.dart';
import '../add_todo/add_todo_screen.dart';
import 'family_sheet.dart';
import 'views/dashboard_view.dart';
import 'views/notion_view.dart';
import 'views/task_list_view.dart';
import 'widgets/home_header.dart';

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

    final isChild = auth.isChild;

    // Clamp index so a child (2 tabs) never holds index 2
    final safeIndex = isChild ? _navIndex.clamp(0, 1) : _navIndex;
    if (safeIndex != _navIndex) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() => _navIndex = safeIndex));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(
              selectedMemberId: _selectedMemberId,
              effectiveMemberId: effectiveMemberId,
              showFilters: safeIndex == 1,
              onMemberSelect: (id) => setState(() => _selectedMemberId = id),
              onManageFamily: auth.canManageFamily ? _showFamilySheet : null,
              onLogout: _logout,
            ),
            Expanded(
              child: IndexedStack(
                index: safeIndex,
                children: [
                  DashboardView(
                    onAddTask: _openAddTodo,
                    onViewMember: (id) => setState(() {
                      _selectedMemberId = id;
                      _navIndex = 1;
                    }),
                  ),
                  TaskListView(effectiveMemberId: effectiveMemberId),
                  if (!isChild) NotionView(onAddTask: _openAddTodo),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (i) => setState(() => _navIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.subtitle,
        selectedLabelStyle:
            GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'List',
          ),
          if (!isChild)
            const BottomNavigationBarItem(
              icon: Icon(Icons.history_edu_rounded),
              label: 'Task Log',
            ),
        ],
      ),
      floatingActionButton: auth.canManageTasks
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
        child: const FamilySheet(),
      ),
    );
  }

  void _logout() {
    context.read<AuthProvider>().logout();
  }
}
