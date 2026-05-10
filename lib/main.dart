import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/todo_model.dart';
import 'models/family_member.dart';
import 'providers/todo_provider.dart';
import 'providers/user_provider.dart';
import 'providers/family_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'screens/home/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(FamilyMemberAdapter());
  await Hive.openBox<Todo>(AppConstants.todosBox);
  await Hive.openBox<FamilyMember>(AppConstants.membersBox);
  await Hive.openBox(AppConstants.settingsBox);
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()..loadTodos()),
        ChangeNotifierProvider(create: (_) => UserProvider()..load()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()..load()),
      ],
      child: MaterialApp(
        title: 'Family Tasks',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
