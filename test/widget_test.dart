import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/core/utils/constants.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/family_member.dart';
import 'package:todo_app/models/todo_model.dart';

void main() {
  late Directory hiveDirectory;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;

    hiveDirectory = await Directory.systemTemp.createTemp('todo_app_test_');
    Hive.init(hiveDirectory.path);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FamilyMemberAdapter());
    }

    await Hive.openBox<Todo>(AppConstants.todosBox);
    await Hive.openBox<FamilyMember>(AppConstants.membersBox);
    await Hive.openBox(AppConstants.settingsBox);
  });

  tearDown(() async {
    await Hive.close();
    if (await hiveDirectory.exists()) {
      await hiveDirectory.delete(recursive: true);
    }
  });

  testWidgets('shows onboarding when no admin has been created',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Name your workspace'), findsOneWidget);
    expect(find.text('Dashboard'), findsNothing);
  });
}
