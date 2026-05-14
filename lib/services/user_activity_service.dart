import 'package:hive/hive.dart';
import '../core/utils/constants.dart';

class UserActivityService {
  Future<void> log({
    required String event,
    required String userId,
    required String username,
    required bool success,
    required String source,
    String? reason,
  }) async {
    final box = Hive.box(AppConstants.userActivityBox);
    await box.add({
      'event': event,
      'userId': userId,
      'username': username,
      'success': success,
      'source': source,
      if (reason != null) 'reason': reason,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
