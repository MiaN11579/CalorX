import 'package:final_project/google_sign_in.dart';
import 'package:final_project/views/main_page.dart';
import 'package:final_project/views/questions_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'views/auth_gate.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).themeData,
          initialRoute: '/auth',
          onGenerateRoute: (settings) {
            if (settings.name == '/auth') {
              return MaterialPageRoute(
                builder: (_) => const AuthGate(),
              );
            } else if (settings.name == '/question') {
              return MaterialPageRoute(
                builder: (_) => const QuestionsPage(),
              );
            } else if (settings.name == '/main') {
              final args = settings.arguments as MainPage;
              return MaterialPageRoute(
                builder: (_) =>
                    MainPage(dailyCalorieIntake: args.dailyCalorieIntake),
              );
            }
            return null;
          },
        ),
      );
}
