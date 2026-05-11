import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/todo_model.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

class CalendarView extends StatefulWidget {
  final VoidCallback onAddTask;
  const CalendarView({super.key, required this.onAddTask});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedMonth = DateTime(
      DateTime.now().year, DateTime.now().month);
  DateTime _selectedDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void _prevMonth() => setState(() {
        _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      });

  @override
  Widget build(BuildContext context) {
    final allTodos = context.watch<TodoProvider>().activeTodos +
        context.watch<TodoProvider>().completedTodos;

    // Build a set of days that have tasks
    final taskDays = <String>{};
    for (final t in allTodos) {
      if (t.dueDate != null) {
        taskDays.add(_dayKey(t.dueDate!));
      }
    }

    final tasksForDay = allTodos
        .where((t) =>
            t.dueDate != null && _sameDay(t.dueDate!, _selectedDay))
        .toList()
      ..sort((a, b) => a.isDone == b.isDone
          ? 0
          : a.isDone
              ? 1
              : -1);

    return Column(
      children: [
        // ── Calendar header ──────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              // Month navigation
              Row(
                children: [
                  IconButton(
                    onPressed: _prevMonth,
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: AppColors.text,
                    iconSize: 22,
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM yyyy').format(_focusedMonth),
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right_rounded),
                    color: AppColors.text,
                    iconSize: 22,
                  ),
                ],
              ),
              // Day-of-week labels
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    _DayLabel('Su'),
                    _DayLabel('Mo'),
                    _DayLabel('Tu'),
                    _DayLabel('We'),
                    _DayLabel('Th'),
                    _DayLabel('Fr'),
                    _DayLabel('Sa'),
                  ],
                ),
              ),
              // Day grid
              _MonthGrid(
                focusedMonth: _focusedMonth,
                selectedDay: _selectedDay,
                taskDays: taskDays,
                onDayTap: (d) => setState(() => _selectedDay = d),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),

        // ── Divider with selected date label ─────────────────────
        Container(
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          child: Row(
            children: [
              Text(
                _isToday(_selectedDay)
                    ? 'Today'
                    : DateFormat('EEEE, MMM d').format(_selectedDay),
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text),
              ),
              const Spacer(),
              if (tasksForDay.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${tasksForDay.length} task${tasksForDay.length == 1 ? '' : 's'}',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),

        // ── Task list for selected day ────────────────────────────
        Expanded(
          child: tasksForDay.isEmpty
              ? _EmptyDay(
                  day: _selectedDay, onAddTask: widget.onAddTask)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  itemCount: tasksForDay.length,
                  itemBuilder: (ctx, i) =>
                      _CalendarTaskCard(todo: tasksForDay[i]),
                ),
        ),
      ],
    );
  }

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  bool _isToday(DateTime d) => _sameDay(d, DateTime.now());
}

// ── Month grid ───────────────────────────────────────────────────────

class _MonthGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final Set<String> taskDays;
  final ValueChanged<DateTime> onDayTap;

  const _MonthGrid({
    required this.focusedMonth,
    required this.selectedDay,
    required this.taskDays,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    // Sunday = 0 offset; DateTime weekday: Mon=1 … Sun=7
    final startOffset = firstDay.weekday % 7;
    final today = DateTime.now();

    final cells = <Widget>[];

    // Leading empty cells
    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedMonth.year, focusedMonth.month, day);
      final key = '${date.year}-${date.month}-${date.day}';
      final isSelected = date.year == selectedDay.year &&
          date.month == selectedDay.month &&
          date.day == selectedDay.day;
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final hasTask = taskDays.contains(key);

      cells.add(_DayCell(
        day: day,
        isSelected: isSelected,
        isToday: isToday,
        hasTask: hasTask,
        onTap: () => onDayTap(date),
      ));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: cells,
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isToday;
  final bool hasTask;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasTask,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isToday || isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : isToday
                        ? AppColors.primary
                        : AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasTask
                  ? (isSelected ? Colors.white : AppColors.primary)
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.subtitle),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ── Empty day state ──────────────────────────────────────────────────

class _EmptyDay extends StatelessWidget {
  final DateTime day;
  final VoidCallback onAddTask;

  const _EmptyDay({required this.day, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final isToday = day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📭', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text(
            isToday ? 'Nothing due today' : 'No tasks on this day',
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.text),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onAddTask,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text('Add task for this day',
                style: GoogleFonts.poppins(fontSize: 13)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Task card for selected day ───────────────────────────────────────

class _CalendarTaskCard extends StatelessWidget {
  final Todo todo;
  const _CalendarTaskCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TodoProvider>();
    final family = context.read<FamilyProvider>();
    final member = todo.assignedTo != null
        ? family.findById(todo.assignedTo!)
        : null;
    final memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4a4a4a).withValues(alpha: 0.1),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => provider.toggleTodo(todo),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isDone ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: todo.isDone
                      ? AppColors.primary
                      : const Color(0xFFB0B0B0),
                  width: 1.8,
                ),
              ),
              child: todo.isDone
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              todo.title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: todo.isDone ? AppColors.subtitle : AppColors.text,
                decoration:
                    todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (member != null) ...[
            const SizedBox(width: 8),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: memberColor!.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                member.name[0].toUpperCase(),
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: memberColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
