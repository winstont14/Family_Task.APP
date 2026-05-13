import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/family_member.dart';
import '../core/utils/constants.dart';
import '../services/user_activity_service.dart';

class AuthProvider extends ChangeNotifier {
  FamilyMember? _currentUser;
  final UserActivityService _activityService = UserActivityService();

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
    await _activityService.log(
      event: 'login_success',
      userId: member.id,
      username: member.name,
      success: true,
      source: 'login_screen',
    );
    notifyListeners();
  }

  Future<void> logout({String source = 'home_screen'}) async {
    final current = _currentUser;
    _currentUser = null;
    final settings = Hive.box(AppConstants.settingsBox);
    await settings.delete(AppConstants.currentUserKey);
    if (current != null) {
      await _activityService.log(
        event: 'logout',
        userId: current.id,
        username: current.name,
        success: true,
        source: source,
      );
    }
    notifyListeners();
  }

  Future<void> logFailedLogin({
    required FamilyMember member,
    String source = 'pin_dialog',
    String reason = 'wrong_pin',
  }) async {
    await _activityService.log(
      event: 'login_failed',
      userId: member.id,
      username: member.name,
      success: false,
      source: source,
      reason: reason,
    );
  }
}
