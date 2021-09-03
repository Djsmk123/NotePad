import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad/Views/AuthScreen.dart';
import 'package:notepad/Views/HomeScreen.dart';
import 'package:notepad/Views/NoteScreen.dart';
import 'package:notepad/Views/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MpApp());
}
class MpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/Checklist.jpg"), context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My NotePad",
      theme: ThemeData(
        primaryColor: Color(0XFF0f1c47),
        accentColor: Color(0XFF0f1c47),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0XFF0f1c47),
        )
      ),
      home: SplashScreen(),
      getPages: [
        GetPage(name: '/NotesScreen', page: () => NotesScreen()),
        GetPage(name: '/HomesScreen', page:()=> HomeScreen()),
        GetPage(name: '/AuthScreen', page:()=>AuthScreen()),
      ],
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        NotesScreen.id: (context) => NotesScreen(),
      },
    );
  }
}

