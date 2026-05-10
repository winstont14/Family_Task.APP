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

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
    this.dueDate,
    this.colorValue,
    this.assignedTo,
  });
}
