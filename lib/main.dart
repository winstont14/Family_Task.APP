import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/todo_model.dart';
import 'models/family_member.dart';
import 'providers/auth_provider.dart';
import 'providers/family_provider.dart';
import 'providers/todo_provider.dart';
import 'providers/user_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/constants.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/notification_service.dart';

// Keep semantics alive for the lifetime of the app (enables E2E testing on web).
SemanticsHandle? _webSemanticsHandle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    _webSemanticsHandle = SemanticsBinding.instance.ensureSemantics();
  }
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(FamilyMemberAdapter());
  await Hive.openBox<Todo>(AppConstants.todosBox);
  await Hive.openBox<FamilyMember>(AppConstants.membersBox);
  await Hive.openBox(AppConstants.settingsBox);
  await Hive.openBox(AppConstants.userActivityBox);
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
        ChangeNotifierProvider(create: (_) => AuthProvider()..load()),
      ],
      child: MaterialApp(
        title: 'Family Tasks',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (!auth.isLoggedIn) return const LoginScreen();
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
