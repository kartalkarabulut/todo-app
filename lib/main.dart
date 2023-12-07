import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants/colors.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/riverpod/providers/auth_providers.dart';
import 'package:task_manager/screens/home/home-screen/home_screen.dart';
import 'package:task_manager/screens/validation_screens/register%20screen/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0.7,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(AppColors.secondaryColor),
          overlayColor: const MaterialStatePropertyAll(
            Color(0xFF290001),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.butonBackgroundColor,
          foregroundColor: Colors.black,
          extendedTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
      ),
      home: const AuthWidget(),
    );
  }
}

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen();
          } else {
            return const RegisterScreen();
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Center(child: Text("Hata oluştu")));
  }
}
