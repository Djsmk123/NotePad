import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad/Modules/userAuths.dart';
import 'package:notepad/Views/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';
final emailTextController = new TextEditingController();
final passCodeTextController = new TextEditingController();
FirebaseAuth auth = FirebaseAuth.instance;
class AuthScreen extends StatelessWidget {
  static String id = 'Auth_Screen';
  final control = Get.put(authController());
  void logIN() {
    auth.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passCodeTextController.text).then((email) async {
      if (auth.currentUser!.email != null) {
        Get.snackbar(
          "Successfully",
          "Done",
          titleText: Text("Authentication Done"),
          icon: Icon(Icons.save, color: Color(0XFFFF0f1c47)),
          snackPosition: SnackPosition.BOTTOM,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', emailTextController.text);
            await prefs.setString('password', passCodeTextController.text);
        emailTextController.clear();
        passCodeTextController.clear();
      }
    }).catchError((error) {
      var msg = error.message;
      Get.snackbar(
        "TryAgain",
        msg.toString(),
        titleText: Text("Authentication Failed"),
        icon: Icon(Icons.error, color: Color(0XFFFF0f1c47)),
        snackPosition: SnackPosition.BOTTOM,
      );
    });

  }
  void signUP()
  {
   auth.createUserWithEmailAndPassword(email: emailTextController.text, password: passCodeTextController.text).then((user) async {
     if(auth.currentUser!.email != null)
     {
       Get.snackbar(
         "Successfully",
         "Done",
         titleText: Text("Done"),
         icon: Icon(Icons.save, color: Color(0XFFFF0f1c47)),
         snackPosition: SnackPosition.BOTTOM,
       );
       SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setString('email', emailTextController.text);
     await prefs.setString('password', passCodeTextController.text);
     emailTextController.clear();
     passCodeTextController.clear();
     Get.offNamed("/AuthScreen");
     Get.to(HomeScreen.id);
         emailTextController.clear();
         passCodeTextController.clear();
       }
   }
   ).catchError((error){
     Get.snackbar(
       "TryAgain",
       error.message.toString(),
       titleText: Text("Failed"),
       icon: Icon(Icons.error, color: Color(0XFFFF0f1c47)),
       snackPosition: SnackPosition.BOTTOM,
     );
   });
  }
  @override
  Widget build(BuildContext context) {
    return GetX<authController>(builder: (control) {
      return WillPopScope(
        onWillPop: () async{
         if(control.isSignUp.isTrue)control.isSignUp.value=false;
         return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color(0XFFffffff),
            centerTitle: true,
            title: Text(
              "Notepad",
              style: TextStyle(
                  color: Color(0XFF0f1c47),
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset("assets/Checklist.jpg"),
                ),
                textFields(
                    controller: emailTextController,
                    hintTxt: "Enter your email",
                    labText: "Email",
                    isEmail: true),
                textFields(
                    controller: passCodeTextController,
                    hintTxt: "Enter your password",
                    labText: "Password",
                    isEmail: false),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                         control.isSignUp.isFalse?logIN():signUP();
                         email=emailTextController.text;
                         password=passCodeTextController.text;
                         Future.delayed(Duration(seconds: 2), () {
                         });
                         Navigator.pop(context);
                         Navigator.pushNamed(context, HomeScreen.id);
                      },
                      child: Text(
                       control.isSignUp.value?"SIGN UP":"SIGN IN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 5,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0XFF0a1847),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: control.isSignUp.isFalse,
                  child: Padding(padding: EdgeInsets.fromLTRB(20,0,20,0),
                    child: TextButton(
                      onPressed: (){},
                      child: Text("Forgot Password",style: TextStyle(
                        color:Color(0XFF0a1847),
                        letterSpacing: 1,
                      ),),
                    ),
                  ),
                ),
                Visibility(
                  visible: control.isSignUp.isFalse,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Don't have an account?",style: TextStyle(
                        color:Color(0XFF0a1847),
                        letterSpacing: 1,
                        ),
                        ),
                        TextButton(onPressed: (){
                          control.isSignUp.value=true;
                        }, child: Text("Sign up",style: TextStyle(
                          color:Color(0XFF0a1847),
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold
                        ),))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  Padding textFields({controller, hintTxt, labText, isEmail}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          height: 60,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(20),
          ),
          child: new TextFormField(
            keyboardType: isEmail
                ? TextInputType.emailAddress
                : TextInputType.visiblePassword,
            controller: isEmail ? emailTextController : passCodeTextController,
            obscureText: isEmail ? false : !control.isPassVisible.value,
            decoration: new InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade500),
                gapPadding: 20,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 45, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Color(0XFFc7c7c7)),
                gapPadding: 20,
              ),
              suffixIcon: GestureDetector(
                child: Icon(isEmail
                    ? Icons.email
                    : control.isPassVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                onTap: () {
                  if (!isEmail) {
                    control.passHide();
                  }
                },
              ),
              hintText: hintTxt,
              labelText: labText,
              hintStyle: TextStyle(
                color: Color(0XFFc7c7c7),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              labelStyle: TextStyle(
                color: Color(0XFFc7c7c7),
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}