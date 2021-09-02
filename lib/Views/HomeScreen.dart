import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/Functions/NumberToMonth.dart';
import 'package:notepad/Modules/NotesController.dart';
import 'package:notepad/Modules/Noteslist.dart';
import 'package:get/get.dart';
import 'package:notepad/Views/AuthScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants.dart';
import 'NoteScreen.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
final _fireStore = FirebaseFirestore.instance;
final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();
class HomeScreen extends StatelessWidget {
  static String id = 'Home_Screen';
  final controller = Get.put(NotesListController());
  final controller2=Get.put(NoteContoller());
  @override
  Widget build(BuildContext context) {
    Widget buildMenu() {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png"),
                    backgroundColor: Colors.transparent,
                    radius: 150.0,
                  ),
                  ListTile(
                    onTap: () async {
                      FirebaseAuth.instance.signOut();
                      email = 'null';
                      password = 'null';
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('email', email);
                      await prefs.setString('password', password);
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AuthScreen.id);
                    },
                    leading: Icon(Icons.logout, size: 30.0, color: Color(0XFF353e62)),
                    title: Text("Log_Out",style: TextStyle(
                      color: Color(0XFF17224b),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    dense: true,
                    // padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return SideMenu(
      key: _endSideMenuKey,
      type: SideMenuType.slideNRotate,
      background: Colors.white,
      radius: null,
      menu: buildMenu(),
      closeIcon: Icon(Icons.close_rounded,color: Color(0XFF353e62),),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
      onPressed: () {
        DateTime now = DateTime.now();
        String formattedTime = numberToMonth(mon: now.month).toString() + " " + now.day.toString() + " " + now.year.toString() + ", " + now.hour.toString() + ":" + now.minute.toString();
        controller2.kContent.value="Content";
        controller2.kTitle.value="title";
        controller2.kTime.value=formattedTime;
        controller2.isStar.value=false;
        controller2.isNew.value=true;
        controller2.kIndex.value=controller.notesList.length;
        textEditor.text=controller2.kContent.value;
        Navigator.pushNamed(context, NotesScreen.id);
      },
      child: Icon(
        Icons.add,
        size: 30,
      ),
      backgroundColor: Color(0XFF0a1747),
        ),
        appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "MyNotes",
        style: TextStyle(
            color: Color(0XFF353e62),
            fontSize: 25,
            fontWeight: FontWeight.w900),
      ),
      leading: AppBarIconButton(
        onPress: (){

            final _state = _endSideMenuKey.currentState;
            if (_state!.isOpened)
              _state.closeSideMenu();
            else
              _state.openSideMenu();
        },
        icn: Icon(
          Icons.menu,
          color: Color(0XFF999faf),
        ),
      ),
      actions: [
        AppBarIconButton(
          onPress: (){},
          icn: Icon(
            Icons.search,
            color: Color(0XFF999faf),
          ),
        ),
      ],
        ),
        body: SingleChildScrollView(
        child: GetBuilder<NotesListController>(builder: (controller) {
      return StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection('Notepad$email').orderBy('star',descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            controller.notesList.clear();
            final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            for (var items in documents) {
              DateTime myDateTime = (items['time']).toDate();
              String formattedTime =
                  numberToMonth(mon: myDateTime.month).toString() +
                      " " +
                      myDateTime.day.toString() +
                      " " +
                      myDateTime.year.toString() +
                      ", " +
                      myDateTime.hour.toString() +
                      ":" +
                      myDateTime.minute.toString();
              controller.notesList.add(controller.addList(
                  content: items['content'],
                  star: items['star'],
                  time: formattedTime,
                  title: items['title'],
                   index: items.id.split("notes")[1]
              )
              );
            }
            return ListView(shrinkWrap: true, children: controller.notesList);
          });
        })),
      ),
    );
  }
}

// ignore: must_be_immutable
class AppBarIconButton extends StatelessWidget {
  AppBarIconButton({required this.icn, required this.onPress});
  final Icon icn;
  var onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0XFFf1f5fd),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          onPressed:onPress,
          icon: icn,
        ),
      ),
    );
  }
}

