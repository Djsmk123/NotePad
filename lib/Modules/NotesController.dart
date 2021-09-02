import 'package:get/get.dart';


class NoteContoller extends GetxController{
  var kTitle="Title".obs;
  var kContent="Content".obs;
  var kTime="".obs;
  var isNew=true.obs;
  var isStar=false.obs;
  RxInt kIndex=0.obs;
  var isEdit=false.obs;
}