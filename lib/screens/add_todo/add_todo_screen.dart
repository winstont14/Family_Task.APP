import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors.dart';
import '../../models/todo_model.dart';
import '../../providers/auth_provider.dart';
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
  late final TextEditingController _titleCtrl;
  late final TextEditingController _rewardCtrl;
  DateTime? _dueDate;
  int? _colorValue;
  String? _assignedTo;
  int _starRating = 0;
  bool _isSuggestion = false;

  bool get _isEditing => widget.existingTodo != null;

  @override
  void initState() {
    super.initState();
    final t = widget.existingTodo;
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _rewardCtrl = TextEditingController(text: t?.reward ?? '');
    _dueDate = t?.dueDate;
    _colorValue = t?.colorValue;
    _assignedTo = t?.assignedTo;
    _starRating = t?.starRating ?? 0;
    _isSuggestion = t?.isSuggestion ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _rewardCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _titleCtrl.text.trim();
    if (text.isEmpty) return;
    final reward = _rewardCtrl.text.trim();
    final provider = context.read<TodoProvider>();
    if (_isEditing) {
      await provider.editTodo(
        widget.existingTodo!,
        text,
        dueDate: _dueDate,
        colorValue: _colorValue,
        assignedTo: _assignedTo,
        reward: reward.isEmpty ? null : reward,
        starRating: _starRating > 0 ? _starRating : null,
      );
    } else {
      await provider.addTodo(
        text,
        dueDate: _dueDate,
        colorValue: _colorValue,
        assignedTo: _assignedTo,
        reward: reward.isEmpty ? null : reward,
        starRating: _starRating > 0 ? _starRating : null,
        isSuggestion: _isSuggestion,
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
    final auth = context.watch<AuthProvider>();
    final isChild = auth.isChild;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.subtitle.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isEditing
                          ? 'Edit Task'
                          : (isChild ? 'Suggest a Task 💡' : 'New Task'),
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Title ──────────────────────────────────────
                    TextField(
                      controller: _titleCtrl,
                      autofocus: true,
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: AppColors.text),
                      decoration: InputDecoration(
                        hintText: 'What needs to be done?',
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
                      textInputAction: TextInputAction.next,
                      minLines: 1,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),

                    // ── Due date ───────────────────────────────────
                    _DueDatePicker(
                      dueDate: _dueDate,
                      onTap: _pickDueDate,
                      onClear: () => setState(() => _dueDate = null),
                    ),
                    const SizedBox(height: 14),

                    // ── Difficulty stars ───────────────────────────
                    _FieldLabel(label: 'Difficulty'),
                    const SizedBox(height: 8),
                    _StarRatingPicker(
                      value: _starRating,
                      onChange: (v) => setState(() => _starRating = v),
                    ),
                    const SizedBox(height: 14),

                    // ── Reward ─────────────────────────────────────
                    _FieldLabel(label: 'Reward 🎁 (optional)'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _rewardCtrl,
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: AppColors.text),
                      decoration: InputDecoration(
                        hintText: 'e.g. 30 min screen time',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.subtitle),
                        filled: true,
                        fillColor: const Color(0xFFFFF8E1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.card_giftcard_rounded,
                            color: Color(0xFFFFAA57), size: 20),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Card colour ────────────────────────────────
                    _ColorPicker(
                      selected: _colorValue,
                      onSelect: (v) => setState(() => _colorValue = v),
                    ),

                    // ── Assign to ──────────────────────────────────
                    Consumer<FamilyProvider>(
                      builder: (context, family, _) {
                        if (family.members.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14),
                            _FieldLabel(label: 'Assign to'),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _AssignChip(
                                    label: 'No one',
                                    isSelected: _assignedTo == null,
                                    color: AppColors.subtitle,
                                    onTap: () =>
                                        setState(() => _assignedTo = null),
                                  ),
                                  ...family.members.map((m) {
                                    final color = Color(
                                        family.colorValueForMember(m.id));
                                    return _AssignChip(
                                      label: m.name,
                                      isSelected: _assignedTo == m.id,
                                      color: color,
                                      onTap: () => setState(
                                          () => _assignedTo = m.id),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // ── Suggest to parent (child only) ─────────────
                    if (isChild && !_isEditing) ...[
                      const SizedBox(height: 16),
                      _SuggestToggle(
                        value: _isSuggestion,
                        onChange: (v) => setState(() => _isSuggestion = v),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Save button ────────────────────────────────
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSuggestion
                              ? const Color(0xFFFFAA57)
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isEditing
                              ? 'Save Changes'
                              : (_isSuggestion
                                  ? '💡 Suggest to Parent'
                                  : 'Add Task'),
                          style: GoogleFonts.poppins(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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

// ── Field label ───────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.subtitle),
    );
  }
}

// ── Star rating picker ────────────────────────────────────────────────

class _StarRatingPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;
  const _StarRatingPicker({required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < value;
        return GestureDetector(
          onTap: () => onChange(value == i + 1 ? 0 : i + 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              size: 32,
              color: filled ? const Color(0xFFFFAA57) : AppColors.subtitle,
            ),
          ),
        );
      }),
    );
  }
}

// ── Suggest toggle ────────────────────────────────────────────────────

class _SuggestToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChange;
  const _SuggestToggle({required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChange(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFFFFAA57).withValues(alpha: 0.12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? const Color(0xFFFFAA57)
                : AppColors.subtitle.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text('💡', style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggest to parent',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: value
                          ? const Color(0xFFCC7700)
                          : AppColors.text,
                    ),
                  ),
                  Text(
                    'Parent will approve before it becomes a task',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.subtitle),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChange,
              activeThumbColor: const Color(0xFFFFAA57),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Assign chip ───────────────────────────────────────────────────────

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

// ── Color picker ──────────────────────────────────────────────────────

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
          style:
              GoogleFonts.poppins(fontSize: 13, color: AppColors.subtitle),
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

// ── Due date picker ───────────────────────────────────────────────────

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
              ? Border.all(
                  color: AppColors.primary.withValues(alpha: 0.4))
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
                  fontSize: 15,
                  color:
                      hasDate ? AppColors.primary : AppColors.subtitle,
                  fontWeight:
                      hasDate ? FontWeight.w500 : FontWeight.normal,
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
