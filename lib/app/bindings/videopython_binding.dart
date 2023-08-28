
import 'package:get/get.dart';
import '../controllers/videopython_controller.dart';


class VideoPythonBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoPythonController>(() => VideoPythonController());
  }
}