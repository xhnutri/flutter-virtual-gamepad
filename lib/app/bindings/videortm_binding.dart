
import 'package:get/get.dart';
import '../controllers/videortm_controller.dart';


class VideortmBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideortmController>(() => VideortmController());
  }
}