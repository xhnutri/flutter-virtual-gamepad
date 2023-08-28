
import 'package:get/get.dart';
import '../controllers/client_screen_socket_controller.dart';


class ClientScreenSocketBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientScreenSocketController>(() => ClientScreenSocketController());
  }
}