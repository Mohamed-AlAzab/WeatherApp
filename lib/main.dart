import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/Pages/home.dart';
import 'package:weatherapp/Pages/login.dart';
import 'package:weatherapp/Pages/profile.dart';
import 'package:weatherapp/Pages/setting.dart';
import 'package:weatherapp/Pages/signup.dart';
import 'package:weatherapp/Pages/splashScreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDzSWBejGSMNjHaFZUbTveI1_IBBCf2k48",
        appId: "1:316060077139:web:d776d3d674954e6384caa6",
        messagingSenderId: "316060077139",
        projectId: "weatherapp-flutter-track",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      routes: {
        '/': (context) => SplashScreen(child: Login()),
        '/Login': (context) => Login(),
        '/SignUp': (context) => SignUp(),
        '/Home': (context) => HomePage(),
        '/Setting': (context) => Setting(),
        '/Profile': (context) => Profile(),
      },
    );
  }
}
