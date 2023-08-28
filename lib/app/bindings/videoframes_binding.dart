import 'package:get/get.dart';
import '../controllers/videoframes_controller.dart';

class VideoFramesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoFramesController>(() => VideoFramesController());
  }
}
