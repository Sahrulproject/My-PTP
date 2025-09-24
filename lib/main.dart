import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myptp/views/auth/login_screen.dart';
import 'package:myptp/views/forgot_password_screen.dart';
import 'package:myptp/views/home_screen.dart';
import 'package:myptp/views/presence_screen.dart';
import 'package:myptp/widgets/bottom_nav.dart';
import 'package:myptp/widgets/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'StageGrotesk_Regular',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('id', 'ID'), // Indonesian
      ],
      // home: SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ButtomPage.id: (context) => ButtomPage(),
        PresenceScreen.id: (context) => PresenceScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
