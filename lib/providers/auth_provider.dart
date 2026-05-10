import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/family_member.dart';
import '../core/utils/constants.dart';

class AuthProvider extends ChangeNotifier {
  FamilyMember? _currentUser;

  FamilyMember? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';
  bool get isParent => _currentUser?.role == 'parent';
  bool get isChild => _currentUser?.role == 'child';
  bool get canManageTasks => isAdmin || isParent;
  bool get canManageFamily => isAdmin;

  void load() {
    final settings = Hive.box(AppConstants.settingsBox);
    final savedId = settings.get(AppConstants.currentUserKey) as String?;
    if (savedId == null) return;
    final membersBox = Hive.box<FamilyMember>(AppConstants.membersBox);
    _currentUser = membersBox.get(savedId);
    notifyListeners();
  }

  Future<void> login(FamilyMember member) async {
    _currentUser = member;
    final settings = Hive.box(AppConstants.settingsBox);
    await settings.put(AppConstants.currentUserKey, member.id);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    final settings = Hive.box(AppConstants.settingsBox);
    await settings.delete(AppConstants.currentUserKey);
    notifyListeners();
  }
}
