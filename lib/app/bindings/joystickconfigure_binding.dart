
import 'package:get/get.dart';
import '../controllers/joystickconfigure_controller.dart';


class JoystickConfigureBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoystickConfigureController>(() => JoystickConfigureController());
  }
}