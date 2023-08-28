
import 'package:get/get.dart';
import '../controllers/firebase_controller.dart';


class FirebaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirebaseController>(() => FirebaseController());
  }
}