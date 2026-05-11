import 'package:hive/hive.dart';

part 'family_member.g.dart';

@HiveType(typeId: 1)
class FamilyMember extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String role; // 'admin' | 'parent' | 'child'

  @HiveField(3)
  String? pin; // 4-digit PIN, null = no PIN required

  @HiveField(4)
  String? emoji; // avatar emoji chosen during member creation

  FamilyMember({
    required this.id,
    required this.name,
    this.role = 'child',
    this.pin,
    this.emoji,
  });
}
