import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/family_member.dart';
import '../services/family_service.dart';
import '../core/utils/constants.dart';

const List<int> kMemberColorValues = [
  0xFF7B68EE, // soft indigo
  0xFFFF6B9D, // coral pink
  0xFF52C78B, // mint green
  0xFFFFAA57, // warm orange
  0xFF56CCF2, // sky blue
  0xFFBB8FCE, // soft purple
];

class FamilyProvider extends ChangeNotifier {
  final FamilyService _service = FamilyService();
  List<FamilyMember> _members = [];
  String _familyName = 'My Family';
  String _familyIcon = '🏠';
  int _weeklyGoal = 5;

  List<FamilyMember> get members => List.unmodifiable(_members);
  String get familyName => _familyName;
  String get familyIcon => _familyIcon;
  int get weeklyGoal => _weeklyGoal;
  bool get hasAdmin => _members.any((m) => m.role == 'admin');

  int colorValueForMember(String id) {
    final idx = _members.indexWhere((m) => m.id == id);
    if (idx < 0) return kMemberColorValues[0];
    return kMemberColorValues[idx % kMemberColorValues.length];
  }

  FamilyMember? findById(String id) {
    try {
      return _members.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  void load() {
    _members = _service.getAllMembers();
    final box = Hive.box(AppConstants.settingsBox);
    _familyName =
        box.get(AppConstants.familyNameKey, defaultValue: 'My Family') as String;
    _familyIcon =
        box.get(AppConstants.familyIconKey, defaultValue: '🏠') as String;
    _weeklyGoal =
        box.get(AppConstants.weeklyGoalKey, defaultValue: 5) as int;
    notifyListeners();
  }

  Future<FamilyMember> addMember(String name, String role, {String? pin}) async {
    final member = FamilyMember(
      id: '${DateTime.now().microsecondsSinceEpoch}_${math.Random().nextInt(999999)}',
      name: name,
      role: role,
      pin: pin?.isEmpty == true ? null : pin,
    );
    await _service.addMember(member);
    _members.add(member);
    notifyListeners();
    return member;
  }

  Future<void> updateMemberRole(String id, String role) async {
    final m = findById(id);
    if (m == null) return;
    m.role = role;
    await m.save();
    notifyListeners();
  }

  Future<void> updateMemberPin(String id, String? pin) async {
    final m = findById(id);
    if (m == null) return;
    m.pin = (pin == null || pin.isEmpty) ? null : pin;
    await m.save();
    notifyListeners();
  }

  Future<void> deleteMember(String id) async {
    await _service.deleteMember(id);
    _members.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  Future<void> setFamilyIcon(String icon) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.familyIconKey, icon);
    _familyIcon = icon;
    notifyListeners();
  }

  Future<void> setWeeklyGoal(int goal) async {
    if (goal < 1) return;
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.weeklyGoalKey, goal);
    _weeklyGoal = goal;
    notifyListeners();
  }

  Future<void> setFamilyName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.familyNameKey, trimmed);
    _familyName = trimmed;
    notifyListeners();
  }
}
