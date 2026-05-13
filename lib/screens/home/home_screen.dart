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
import 'views/feed_view.dart';
import 'views/task_list_view.dart';
import 'widgets/home_header.dart';
import 'widgets/task_list_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dashboard uses single-select member filter
  String? _dashboardMemberId;
  // Task list uses multi-select member filter
  Set<String> _taskMemberIds = {};

  int _navIndex = 0;
  int _taskFilter = 0; // 0=All  1=Today  2=Pending

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final family = context.watch<FamilyProvider>();

    // Clean up stale members
    if (_dashboardMemberId != null &&
        family.findById(_dashboardMemberId!) == null) {
      _dashboardMemberId = null;
    }
    _taskMemberIds.removeWhere((id) => family.findById(id) == null);

    final isChild = auth.isChild;

    // effectiveMemberId for dashboard/home header (single String?)
    final dashboardEffectiveId =
        isChild ? auth.currentUser?.id : _dashboardMemberId;

    // effectiveMemberIds for task list (Set<String>)
    final taskEffectiveIds = isChild
        ? (auth.currentUser?.id != null ? {auth.currentUser!.id} : <String>{})
        : _taskMemberIds;

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
            // Family name bar — always visible on every tab
            HomeHeader(
              selectedMemberId: _dashboardMemberId,
              effectiveMemberId: dashboardEffectiveId,
              showFilters: false,
              onMemberSelect: (id) =>
                  setState(() => _dashboardMemberId = id),
              onManageFamily:
                  auth.canManageFamily ? _showFamilySheet : null,
              onLogout: _logout,
            ),
            // Task list filters — only on the list tab
            if (safeIndex == 1)
              TaskListHeader(
                selectedMemberIds: _taskMemberIds,
                effectiveMemberIds: taskEffectiveIds,
                statusFilter: _taskFilter,
                onStatusFilter: (f) => setState(() => _taskFilter = f),
                onMembersChanged: (ids) =>
                    setState(() => _taskMemberIds = ids),
                onManageFamily:
                    auth.canManageFamily ? _showFamilySheet : null,
              ),
            Expanded(
              child: IndexedStack(
                index: safeIndex,
                children: [
                  DashboardView(
                    onAddTask: _openAddTodo,
                    onViewMember: (id) => setState(() {
                      _taskMemberIds = {id};
                      _navIndex = 1;
                    }),
                  ),
                  TaskListView(
                    effectiveMemberIds: taskEffectiveIds,
                    filter: _taskFilter,
                  ),
                  if (!isChild) const FeedView(),
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
              icon: Icon(Icons.feed_rounded),
              label: 'Family Feed',
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
