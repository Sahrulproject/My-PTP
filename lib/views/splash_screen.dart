import 'package:flutter/material.dart';
import 'package:myptp/extension/navigation.dart';
import 'package:myptp/preference/shared_preference.dart';
import 'package:myptp/utils/app_image.dart';
import 'package:myptp/views/auth/login_screen.dart';
import 'package:myptp/views/navbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splashscreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        context.pushReplacementNamed(NavScreen.id);
      } else {
        context.push(LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImage.background),
            SizedBox(height: 20),
            Text("Welcome"),
          ],
        ),
      ),
    );
  }
}
