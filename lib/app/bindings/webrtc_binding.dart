
import 'package:get/get.dart';
import '../controllers/webrtc_controller.dart';


class WebrtcBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebrtcController>(() => WebrtcController());
  }
}