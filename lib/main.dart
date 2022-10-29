import 'package:chamitosapp/screens/answers_survey_screen.dart';
import 'package:chamitosapp/services/FirebaseDynamicLinkService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDynamicLinkService.initDynamicLink();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/forms', page: () => const FormsScreen()),
        GetPage(name: '/answer', page: () => const AnswerSurveyScreen()),
        GetPage(name: '/surveys', page: () => const SurveysScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/auth', page: () => const AuthScreen()),
        GetPage(name: '/answers', page: () => const AnswersSurveyScreen()),
      ],
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(elevation: 0, color: Colors.indigo),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo, elevation: 0),
      ),
    );
  }
}
