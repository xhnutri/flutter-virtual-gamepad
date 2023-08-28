
import 'package:get/get.dart';
import '../controllers/windowscreen_controller.dart';


class WindowScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WindowScreenController>(() => WindowScreenController());
  }
}