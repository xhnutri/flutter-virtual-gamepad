import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamepad/app/ui/pages/client_screen_socket_page/widgets/client_video_view.dart';
import 'package:get/get.dart';
// import 'package:three_dart/extra/blob.dart';
import '../../../../neumorphic/flutter_neumorphic.dart';
import '../../../controllers/client_screen_socket_controller.dart';
// import 'package:three_dart/three_dart.dart' as three;
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ClientScreenSocketPage extends GetView<ClientScreenSocketController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ClientScreenSocketPage'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ClientVideoView(""),
            NeumorphicButton(
              padding: EdgeInsets.all(8),
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
              ),
              onPressed: () {
                controller.connectDataChannel();
              },
              child: Text("Conect Udp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            SizedBox(
              height: 50,
            ),
            NeumorphicButton(
              padding: EdgeInsets.all(8),
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
              ),
              onPressed: () {
                controller.sendss();
              },
              child: Text("Send Udp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            SizedBox(
              height: 50,
            ),
            NeumorphicButton(
              padding: EdgeInsets.all(8),
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
              ),
              onPressed: () {
                controller.disconnectServerUdp();
              },
              child: Text("Desconnect Udp",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            if (controller.inCall.value)
              Expanded(
                child: RTCVideoView(
                  controller.remoteRenderer,
                ),
              ),
            Obx(() => Container(
                  width: Get.width,
                  height: Get.height - 300,
                  color: Color.fromARGB(255, 197, 160, 249),
                  child: controller.socketConnet.value
                      ? StreamBuilder<dynamic>(
                          stream: controller.controllerB.stream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Center(
                                child: Text("Connection Closed !"),
                              );
                            }
                            return Image.memory(
                              snapshot.data,
                              gaplessPlayback: true,
                              excludeFromSemantics: true,
                            );
                          })
                      : SizedBox.shrink(),
                )),
          ],
        ),
      ),
    );
  }
}
