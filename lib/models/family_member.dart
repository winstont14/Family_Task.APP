import 'package:hive/hive.dart';

part 'family_member.g.dart';

@HiveType(typeId: 1)
class FamilyMember extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String role; // 'parent' or 'child'

  FamilyMember({
    required this.id,
    required this.name,
    this.role = 'child',
  });
}
