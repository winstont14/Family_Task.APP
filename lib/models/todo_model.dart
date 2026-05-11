import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  int? colorValue;

  @HiveField(6)
  String? assignedTo; // FamilyMember id

  @HiveField(7)
  String? reward; // e.g. "30 min screen time"

  @HiveField(8)
  int? starRating; // task difficulty 1–5

  @HiveField(9)
  bool? isSuggestion; // child-suggested, awaiting parent approval

  @HiveField(10)
  DateTime? completedAt;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
    this.dueDate,
    this.colorValue,
    this.assignedTo,
    this.reward,
    this.starRating,
    this.isSuggestion,
    this.completedAt,
  });
}
