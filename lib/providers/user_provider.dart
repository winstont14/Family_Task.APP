import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../core/utils/constants.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';

  String get username => _username;
  bool get hasUsername => _username.isNotEmpty;
  String get displayName => hasUsername ? _username : 'there';

  void load() {
    final box = Hive.box(AppConstants.settingsBox);
    _username =
        box.get(AppConstants.usernameKey, defaultValue: '') as String;
  }

  Future<void> setUsername(String name) async {
    final trimmed = name.trim();
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.usernameKey, trimmed);
    _username = trimmed;
    notifyListeners();
  }
}
