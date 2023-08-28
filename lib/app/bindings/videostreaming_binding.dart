
import 'package:get/get.dart';
import '../controllers/videostreaming_controller.dart';


class VideoStreamingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoStreamingController>(() => VideoStreamingController());
  }
}