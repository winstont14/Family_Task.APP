import 'package:hive_flutter/hive_flutter.dart';
import '../models/family_member.dart';
import '../core/utils/constants.dart';

class FamilyService {
  Box<FamilyMember> get _box =>
      Hive.box<FamilyMember>(AppConstants.membersBox);

  List<FamilyMember> getAllMembers() => _box.values.toList();

  Future<void> addMember(FamilyMember member) async {
    await _box.put(member.id, member);
  }

  Future<void> deleteMember(String id) async {
    await _box.delete(id);
  }
}
