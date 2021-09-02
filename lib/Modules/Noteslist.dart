import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepad/Modules/NotesController.dart';
import 'package:notepad/Views/NoteScreen.dart';

import '../Constants.dart';
final _fireStore = FirebaseFirestore.instance;

class NotesListController extends GetxController
{
  final controller=Get.put(NoteContoller());
  var notesList=<Widget>[].obs;
   addList({content,title,time,star,index})
  {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
          child: GestureDetector(
            onTap: (){
              print("ke");
              controller.kContent.value=content;
              controller.kTitle.value=title;
              controller.kTime.value=time;
              controller.isStar.value=star;
              controller.isNew.value=false;
              controller.kIndex.value=int.parse(index);
              textEditor.text=controller.kContent.value;
               Get.toNamed("/NotesScreen");
            },
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,style: TextStyle(
                        color: Color(0XFF17224b),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: (){
                            _fireStore.collection("Notepad$email").doc('notes$index').update({'star':star?false:true});
                          }, icon: Icon(star?Icons.star:Icons.star_border,size: 20,color:star?Color(0XFFef9f0b):Color(0XFFdadce1),)),
                          IconButton(onPressed: (){
                          },icon:  Icon(Icons.more_vert,size: 20,color: Color(0XFF818498),)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:220,
                        child: Text(content,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0XFFBABABA),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        width:80,
                        child: Text("\n$time",
                          style: TextStyle(
                            color: Color(0XFFBABABA),
                            fontSize: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1.5,
          width:double.infinity,
          color: Color(0XFFf5f6fd),
        ),
      ],
    );
  }
}
