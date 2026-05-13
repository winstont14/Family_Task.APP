import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../models/family_member.dart';
import '../../../providers/family_provider.dart';
import '../../../providers/todo_provider.dart';

// ── Feed event (derived, not stored) ──────────────────────────────

enum _EventType { completed, pending, reward, streak }

class _FeedEvent {
  final _EventType type;
  final DateTime time;
  final String? memberId;
  final String title;
  final int? xp;
  final String? rewardText;
  final int? streakDays;

  const _FeedEvent({
    required this.type,
    required this.time,
    this.memberId,
    required this.title,
    this.xp,
    this.rewardText,
    this.streakDays,
  });
}

// ── Main view ──────────────────────────────────────────────────────

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  int _filter = 0; // 0=All  1=Tasks  2=Rewards

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>();
    final family = context.watch<FamilyProvider>();

    final all = _buildEvents(todos);
    final filtered = switch (_filter) {
      1 => all
          .where((e) =>
              e.type == _EventType.completed || e.type == _EventType.pending)
          .toList(),
      2 => all
          .where((e) =>
              e.type == _EventType.reward || e.type == _EventType.streak)
          .toList(),
      _ => all,
    };
    final grouped = _groupByDay(filtered);

    return Column(
      children: [
        _FilterBar(
          selected: _filter,
          onSelect: (i) => setState(() => _filter = i),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const _EmptyFeed()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  itemCount: grouped.length,
                  itemBuilder: (_, i) {
                    final item = grouped[i];
                    if (item is String) return _DayHeader(label: item);
                    return _EventCard(
                      event: item as _FeedEvent,
                      family: family,
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<_FeedEvent> _buildEvents(TodoProvider todos) {
    final events = <_FeedEvent>[];
    final now = DateTime.now();

    for (final t in todos.completedTodos) {
      if (t.completedAt == null) continue;
      final xp = TodoProvider.xpForTask(t.starRating);
      events.add(_FeedEvent(
        type: _EventType.completed,
        time: t.completedAt!,
        memberId: t.assignedTo,
        title: t.title,
        xp: xp,
      ));
      if (t.reward != null && t.reward!.trim().isNotEmpty) {
        events.add(_FeedEvent(
          type: _EventType.reward,
          time: t.completedAt!.add(const Duration(milliseconds: 1)),
          memberId: t.assignedTo,
          title: t.title,
          rewardText: t.reward,
        ));
      }
    }

    for (final t in todos.suggestedTodos) {
      events.add(_FeedEvent(
        type: _EventType.pending,
        time: t.createdAt,
        memberId: t.assignedTo,
        title: t.title,
      ));
    }

    final streak = todos.streakDays;
    if (streak >= 3) {
      events.add(_FeedEvent(
        type: _EventType.streak,
        time: DateTime(now.year, now.month, now.day),
        title: '',
        streakDays: streak,
      ));
    }

    events.sort((a, b) => b.time.compareTo(a.time));
    return events;
  }

  static List<dynamic> _groupByDay(List<_FeedEvent> events) {
    final result = <dynamic>[];
    String? last;
    for (final e in events) {
      final label = _dayLabel(e.time);
      if (label != last) {
        result.add(label);
        last = label;
      }
      result.add(e);
    }
    return result;
  }

  static String _dayLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEEE').format(dt);
    return DateFormat('MMM d').format(dt);
  }
}

// ── Event card ─────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final _FeedEvent event;
  final FamilyProvider family;

  const _EventCard({required this.event, required this.family});

  @override
  Widget build(BuildContext context) {
    final (Color accent, IconData fallbackIcon) = _accent(event.type);
    final FamilyMember? member =
        event.memberId != null ? family.findById(event.memberId!) : null;
    final Color memberColor = member != null
        ? Color(family.colorValueForMember(member.id))
        : AppColors.subtitle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(
            event: event,
            member: member,
            memberColor: memberColor,
            accent: accent,
            fallbackIcon: fallbackIcon,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
                    child: _cardBody(member, memberColor, accent),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardBody(FamilyMember? member, Color memberColor, Color accent) =>
      switch (event.type) {
        _EventType.streak =>
          _StreakBody(days: event.streakDays!, accent: accent),
        _EventType.reward => _RewardBody(
            member: member,
            memberColor: memberColor,
            rewardText: event.rewardText!,
            accent: accent,
          ),
        _EventType.pending => _PendingBody(
            member: member,
            memberColor: memberColor,
            title: event.title,
            accent: accent,
          ),
        _EventType.completed => _CompletedBody(
            member: member,
            memberColor: memberColor,
            title: event.title,
            xp: event.xp,
            accent: accent,
          ),
      };

  static (Color, IconData) _accent(_EventType type) => switch (type) {
        _EventType.completed =>
          (const Color(0xFF52C78B), Icons.check_circle_rounded),
        _EventType.pending =>
          (const Color(0xFFFFAA57), Icons.hourglass_top_rounded),
        _EventType.reward =>
          (const Color(0xFF9B59B6), Icons.card_giftcard_rounded),
        _EventType.streak =>
          (const Color(0xFFFF6B35), Icons.local_fire_department_rounded),
      };
}

// ── Avatar circle ──────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final _FeedEvent event;
  final FamilyMember? member;
  final Color memberColor;
  final Color accent;
  final IconData fallbackIcon;

  const _Avatar({
    required this.event,
    required this.member,
    required this.memberColor,
    required this.accent,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        (member != null ? memberColor : accent).withValues(alpha: 0.12);
    Widget content;
    if (event.type == _EventType.streak) {
      content = const Text('🔥', style: TextStyle(fontSize: 17));
    } else if (event.type == _EventType.reward) {
      content = const Text('🎁', style: TextStyle(fontSize: 17));
    } else if (member != null) {
      content = member!.emoji != null
          ? Text(member!.emoji!, style: const TextStyle(fontSize: 17))
          : Text(
              member!.name[0].toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: memberColor,
              ),
            );
    } else {
      content = Icon(fallbackIcon, size: 17, color: accent);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: content,
    );
  }
}

// ── Card body variants ─────────────────────────────────────────────

class _CompletedBody extends StatelessWidget {
  final FamilyMember? member;
  final Color memberColor;
  final String title;
  final int? xp;
  final Color accent;

  const _CompletedBody({
    required this.member,
    required this.memberColor,
    required this.title,
    this.xp,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (member != null)
                Text(member!.name,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: memberColor)),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtitle,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.subtitle.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (xp != null) ...[
          const SizedBox(width: 8),
          _Badge(label: '+$xp XP', color: accent),
        ],
      ],
    );
  }
}

class _PendingBody extends StatelessWidget {
  final FamilyMember? member;
  final Color memberColor;
  final String title;
  final Color accent;

  const _PendingBody({
    required this.member,
    required this.memberColor,
    required this.title,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (member != null)
                Text(member!.name,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: memberColor)),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Waiting for approval',
                style: GoogleFonts.poppins(fontSize: 12, color: accent),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _Badge(label: 'Review', color: accent),
      ],
    );
  }
}

class _RewardBody extends StatelessWidget {
  final FamilyMember? member;
  final Color memberColor;
  final String rewardText;
  final Color accent;

  const _RewardBody({
    required this.member,
    required this.memberColor,
    required this.rewardText,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (member != null)
          Text(member!.name,
              style:
                  GoogleFonts.poppins(fontSize: 11, color: memberColor)),
        Text(
          'Reward unlocked',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
        Text(
          rewardText,
          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.subtitle),
        ),
      ],
    );
  }
}

class _StreakBody extends StatelessWidget {
  final int days;
  final Color accent;

  const _StreakBody({required this.days, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$days-day streak!',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: accent,
          ),
        ),
        Text(
          '$days days in a row — keep it up!',
          style:
              GoogleFonts.poppins(fontSize: 12, color: AppColors.subtitle),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── Filter bar (segmented control) ────────────────────────────────

class _FilterBar extends StatelessWidget {
  final int selected;
  final void Function(int) onSelect;

  const _FilterBar({required this.selected, required this.onSelect});

  static const _labels = ['All', 'Tasks', 'Rewards'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: List.generate(_labels.length, (i) {
            final isSelected = selected == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _labels[i],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.subtitle,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final String label;
  const _DayHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.subtitle,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('👋', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text(
              'No activity yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Complete your first family task!',
              style:
                  GoogleFonts.poppins(fontSize: 14, color: AppColors.subtitle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
