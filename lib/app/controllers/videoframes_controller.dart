import 'dart:typed_data';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:get/get.dart';
import '../../utils/client_service.dart';

class VideoFramesController extends GetxController {
  late SteerClient client;
  Rx<Uint8List> bytes = Uint8List(0).obs;
  late Socket socket;

  void connectSocket() {
    // client = SteerClient("192.168.1.95");
    // client.socket.on('image', (data) {
    //   print('Get ImageInServers');
    //   // List<int> list = data.codeUnits;
    //   // bytes = Uint8List.fromList(list);
    //   bytes.value = data;
    //   // bytes = data;
    //   // print(object)
    //   print(data);
    // });
  }

  void getImage() {
    print('Get Image');
    client.socket.emit('image', "hello world");
  }

  void disconnect() {
    client.disconnectSocket();
    print("Disconnect");
  }
}
