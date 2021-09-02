import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notepad/Views/AuthScreen.dart';
import 'package:notepad/Views/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Future<void> userAuth()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email')!;
    password = prefs.getString('password')!;
    if (email != 'null' && password!='null') {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.id);
    }
    else
      {
        Navigator.pop(context);
        Navigator.pushNamed(context, AuthScreen.id);
      }
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
    
      userAuth();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
            "NotePad",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Color(0XFF17224b),
            )
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("assets/Checklist.jpg"),
          ),
          SizedBox(height: 30,),
          SpinKitThreeBounce(
            size: 30,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index.isEven ? Colors.black : Colors.grey,
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}
