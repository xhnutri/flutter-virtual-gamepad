
import 'package:get/get.dart';
import '../controllers/pruebavirtualgamepadlinux_controller.dart';


class PruebaVirtualGamepadLinuxBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PruebaVirtualGamepadLinuxController>(() => PruebaVirtualGamepadLinuxController());
  }
}