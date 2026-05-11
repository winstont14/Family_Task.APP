import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/todo_model.dart';
import '../../providers/family_provider.dart';
import '../../providers/todo_provider.dart';

const List<int?> kTaskColors = [
  null,
  0xFFDCEEFD, // sky blue
  0xFFE8E0F5, // lavender
  0xFFD4F1E4, // mint
  0xFFFFF9C4, // lemon
  0xFFFFE0CC, // peach
  0xFFFFD6D6, // rose
  0xFFCCF2F4, // aqua
];

class AddTodoScreen extends StatefulWidget {
  final Todo? existingTodo;

  const AddTodoScreen({super.key, this.existingTodo});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late final TextEditingController _controller;
  DateTime? _dueDate;
  int? _colorValue;
  String? _assignedTo;

  bool get _isEditing => widget.existingTodo != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _isEditing ? widget.existingTodo!.title : '',
    );
    _dueDate = widget.existingTodo?.dueDate;
    _colorValue = widget.existingTodo?.colorValue;
    _assignedTo = widget.existingTodo?.assignedTo;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final provider = context.read<TodoProvider>();
    if (_isEditing) {
      await provider.editTodo(
        widget.existingTodo!,
        text,
        dueDate: _dueDate,
        colorValue: _colorValue,
        assignedTo: _assignedTo,
      );
    } else {
      await provider.addTodo(
        text,
        dueDate: _dueDate,
        colorValue: _colorValue,
        assignedTo: _assignedTo,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(minutes: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
    );
    if (time == null || !mounted) return;

    setState(() {
      _dueDate =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
              _isEditing ? 'Edit Task' : 'New Task',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              style: GoogleFonts.poppins(fontSize: 20, color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 18, color: AppColors.subtitle),
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
              minLines: 1,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _DueDatePicker(
              dueDate: _dueDate,
              onTap: _pickDueDate,
              onClear: () => setState(() => _dueDate = null),
            ),
            const SizedBox(height: 14),
            _ColorPicker(
              selected: _colorValue,
              onSelect: (v) => setState(() => _colorValue = v),
            ),
            Consumer<FamilyProvider>(
              builder: (context, family, _) {
                if (family.members.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      'Assign to',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.subtitle),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _AssignChip(
                            label: 'No one',
                            isSelected: _assignedTo == null,
                            color: AppColors.subtitle,
                            onTap: () => setState(() => _assignedTo = null),
                          ),
                          ...family.members.map((m) {
                            final color =
                                Color(family.colorValueForMember(m.id));
                            return _AssignChip(
                              label: m.name,
                              isSelected: _assignedTo == m.id,
                              color: color,
                              onTap: () =>
                                  setState(() => _assignedTo = m.id),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
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
                  _isEditing ? 'Save Changes' : 'Add Task',
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _AssignChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _AssignChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? color : AppColors.subtitle.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.subtitle,
          ),
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelect;

  const _ColorPicker({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card colour',
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.subtitle),
        ),
        const SizedBox(height: 8),
        Row(
          children: kTaskColors.map((colorVal) {
            final isSelected = colorVal == selected;
            final displayColor =
                colorVal != null ? Color(colorVal) : Colors.white;
            return GestureDetector(
              onTap: () => onSelect(colorVal),
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: displayColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.subtitle.withValues(alpha: 0.3),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: colorVal != null
                            ? AppColors.text.withValues(alpha: 0.7)
                            : AppColors.subtitle,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DueDatePicker extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DueDatePicker({
    required this.dueDate,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = dueDate != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hasDate
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: hasDate
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 22,
              color: hasDate ? AppColors.primary : AppColors.subtitle,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasDate
                    ? DateFormat('MMM d, yyyy  h:mm a').format(dueDate!)
                    : 'Set deadline (optional)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: hasDate ? AppColors.primary : AppColors.subtitle,
                  fontWeight: hasDate ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (hasDate)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close_rounded,
                    size: 20, color: AppColors.subtitle),
              ),
          ],
        ),
      ),
    );
  }
}
