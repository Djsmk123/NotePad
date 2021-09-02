import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad/Constants.dart';
import 'package:notepad/Functions/NumberToMonth.dart';
import 'package:notepad/Modules/NotesController.dart';
import 'package:notepad/Views/HomeScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final textEditor = new TextEditingController();
class NotesScreen extends StatelessWidget {
  final controller=Get.put(NoteContoller());
  static String id = 'Notes_Screen';
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Material(
        elevation: 20,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0XFFf5f6fd),
            boxShadow: [
              BoxShadow(
                color: Color(0XFFdcdfe9),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Obx(()=>Icon(FontAwesomeIcons.pencilAlt,size: 20,color: controller.isEdit.value?Colors.lightBlueAccent:Color(0XFF232c4f),)),
                onPressed: () {
                  controller.isEdit.isTrue?controller.isEdit.value=false:controller.isEdit.value=true;
                },
              ),
              IconButton(
                onPressed: (){
                  controller.isStar.isTrue?controller.isStar.value=false:controller.isStar.value=true;
                  int index=controller.isNew.value?controller.kIndex.value+1:controller.kIndex.value;
                  FirebaseFirestore.instance.collection('Notepad$email').doc('notes${index.toString()}').update({'star':controller.isStar.value});
                },
              icon: Obx(()=>Icon(controller.isStar.value?Icons.star:Icons.star_border,size: 25,color: controller.isStar.value?Color(0XFFf1a006):Color(0XFF232c4f),),
              ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.share_outlined,size: 25,color: Color(0XFF0f193f),),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) async {
                  await showMenu(
                    color: Color(0XFFf5f6fd),
                      context: context,
                      position: RelativeRect.fromLTRB(400,600,0,0),
                  items: [
                  PopupMenuItem(
                  value: 1,
                  child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 40),
                  child: Row(
                  children: [
                  Icon(Icons.save, color: Color(0XFF0f193f),),
                  SizedBox(
                  width: 5,
                  ),
                  Text(
                  "Save",
                  style: TextStyle(color: Color(0XFF0f193f)),
                  ),
                  ],
                  ),
                  ),
                  ),
                  PopupMenuItem(
                  value: 2,
                  child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 40),
                  child: Row(
                  children: [
                  Icon(Icons.delete_outline,color: Color(0XFF0f193f),),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                  "Delete",
                  style: TextStyle(color: Color(0XFF0f193f)),
                  ),
                  ],
                  ),
                  ),
                  ),
                  ],
                  elevation:0,
                  ).then((value) {
                  if (value == 1) {
                    DateTime now = DateTime.now();
                    String formattedTime = numberToMonth(mon: now.month).toString() + " " + now.day.toString() + " " + now.year.toString() + ", " + now.hour.toString() + ":" + now.minute.toString();
                    controller.kTime.value=formattedTime;
                    controller.kContent.value= textEditor.text;
                    if(controller.isNew.isFalse) {
                      FirebaseFirestore.instance.collection('Notepad$email').doc('notes${controller.kIndex.value.toString()}').update({'content':controller.kContent.value,
                    'time':Timestamp.now()
                    }).catchError((error){
                      Get.snackbar(
                        "Failed",
                        "Done",
                        titleText: Text(error.message),
                        icon: Icon(Icons.error, color: Color(0XFFFF0f1c47)),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }).whenComplete((){
                      Get.snackbar(
                        "Successfully",
                        "Done",
                        titleText: Text("Saved Done"),
                        icon: Icon(Icons.save, color: Color(0XFFFF0f1c47)),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    });
                    }
                    else {
                     int index=controller.kIndex.value+1;
                     controller.isNew.value=false;
                      FirebaseFirestore.instance.collection('Notepad$email').doc('notes${index.toString()}').set({
                       'content':controller.kContent.value,
                        'title':controller.kTitle.value,
                        'star':false,
                        'time':Timestamp.now()
                      }).catchError((error){
                        Get.snackbar(
                          "Failed",
                          "Done",
                          titleText: Text(error),
                          icon: Icon(Icons.error, color: Color(0XFFFF0f1c47)),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }).whenComplete((){
                        Get.snackbar(
                          "Successfully",
                          "Done",
                          titleText: Text("Saved Done"),
                          icon: Icon(Icons.save, color: Color(0XFFFF0f1c47)),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      });
                    }
                  }
                  if (value == 2) {
                    if(controller.isNew.isFalse) {
                        FirebaseFirestore.instance
                            .collection('Notepad$email')
                            .doc('notes${controller.kIndex.value.toString()}')
                            .delete();
                        Get.back();
                      }
                    }
                  }
                  );
                },
                child:Icon(Icons.more_vert,size: 25,color: Color(0XFF0f193f),),
              ),
            ],
            //
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AppBarIconButton(
          onPress: (){
          Get.back();
          },
          icn: Icon(
            Icons.arrow_back_ios,
            color: Color(0XFF5a6284),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
          child: Container(
            height:MediaQuery.of(context).size.height,
            color: Color(0XFFf5f6fd),
            padding: EdgeInsets.fromLTRB(20, 35, 20, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.kTitle.value,
                  style: TextStyle(
                      color: Color(0XFF141f4b),
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 1.5,
                  width:double.infinity,
                  color: Color(0XFFD9DCED),
                ),
                SizedBox(height: 30,),
                Obx(
                  ()=> TextFormField(
                    controller: textEditor,
                    enabled: controller.isEdit.value,
                    focusNode:  FocusNode(),
                    style: TextStyle(
                      color: Color(0XFF5f6580),
                      fontSize: 15
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 70,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                    ()=> Text(controller.kTime.value,style: TextStyle(
                          color: Color(0XFFb5bcca
                          )
                      ),),
                    ),
                   Spacer(),
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.photo_camera_back,color: Color(0XFFc1c5d4),size: 30,),
                        title: Icon(Icons.mic,color: Color(0XFFc1c5d4),size: 30,),
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
