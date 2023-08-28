import 'package:flutter/material.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../utils/enum_typebutton.dart';
import '../../utils/listgamepad.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamepad Virtual'),
      ),
      backgroundColor: NeumorphicColors.embossMaxWhiteColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: NeumorphicButton(
                padding: EdgeInsets.all(5),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                ),
                onPressed: () {
                  final box = GetStorage();
                  // box.read("listGamepads");
                  // print("object");
                  // print(box.read('listGamepads'));
                  if (box.read('listGamepads') == null) {
                    final listGamepad = [
                      GamepadType(
                          name: ListGamepad.GAMEPAD_BUTTON_A,
                          typeButton: TypeButton.button,
                          data: {"gamepad": "A"}).toJson(),
                      GamepadType(
                          name: ListGamepad.GAMEPAD_BUTTON_B,
                          typeButton: TypeButton.button,
                          data: {"gamepad": "B"}).toJson(),
                      GamepadType(
                          name: ListGamepad.GAMEPAD_BUTTON_X,
                          typeButton: TypeButton.button,
                          data: {"gamepad": "X"}).toJson(),
                      GamepadType(
                          name: ListGamepad.GAMEPAD_BUTTON_Y,
                          typeButton: TypeButton.button,
                          data: {"gamepad": "Y"}).toJson(),
                    ];
                    box.write('listGamepads', listGamepad);
                  }
                  print(box.read('listGamepads'));
                  // var gamepad = GamepadType(
                  //     name: ListGamepad.GAMEPAD_BUTTON_A,
                  //     typeButton: TypeButton.button,
                  //     data: {"gamepad": "A"});
                  // print(gamepad.toJson());
                },
                child: Text(
                  "Gamepad play",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            buttonGame(text: 'VGL', route: Routes.VIRTUALGAMEPADLINUX),
            Center(
              heightFactor: 2,
              child: NeumorphicButton(
                padding: EdgeInsets.all(20),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                ),
                onPressed: () {
                  Get.toNamed(Routes.CONFIGURE_GAMEPAD);
                },
                child: Text("Configure Gamepad",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            Center(
              heightFactor: 1.8,
              child: NeumorphicButton(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                ),
                onPressed: () {
                  Get.toNamed(Routes.VIDEO_PYTHON);
                },
                child: Text("Video By frames",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            Center(
              heightFactor: 2,
              child: NeumorphicButton(
                padding: EdgeInsets.all(20),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                ),
                onPressed: () {
                  Get.toNamed(Routes.VIDEO_STREAMING);
                },
                child: Text("Video Streaming",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            Center(
              heightFactor: 2,
              child: NeumorphicButton(
                padding: EdgeInsets.all(20),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                ),
                onPressed: () {
                  Get.toNamed(Routes.VIDEO_RTMP);
                },
                child: Text("Video RTM",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
            buttonGame(text: 'Window Screen', route: Routes.WINDOW),
            buttonGame(
                text: 'Client Screen Socket',
                route: Routes.CLIENT_SCREEN_SOCKET),
            buttonGame(text: 'WEB RTC', route: Routes.WEBRTC),
            buttonGame(text: 'Firebase', route: Routes.FIREBASE),
          ],
        ),
      )),
    );
  }

  Widget buttonGame({required String text, required String route}) {
    return Center(
      heightFactor: 1.5,
      child: NeumorphicButton(
        padding: EdgeInsets.all(8),
        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
        ),
        onPressed: () {
          Get.toNamed(route);
        },
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }
}
