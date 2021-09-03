import 'package:get/get.dart';
// ignore: camel_case_types
class authController extends GetxController  {
   var isPassVisible=false.obs;
   var isSignUp=false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  void passHide()
  {  print(isPassVisible.value);
    if(isPassVisible.isTrue)
      isPassVisible.value=false;
    else {
      isPassVisible.value = true;
    }

  }
}

