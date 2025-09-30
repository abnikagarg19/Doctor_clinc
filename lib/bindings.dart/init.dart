import 'package:chatbot/controller/splashController.dart';
import 'package:get/get.dart';


class InitBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<splashController>(() => splashController());
  }
}
