import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'providers/contact_provider.dart';
import 'utils/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactProvider(),
      child: MaterialApp(
        title: 'Contacts',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
