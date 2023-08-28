import 'package:flutter/material.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../../../controllers/pruebavirtualgamepadlinux_controller.dart';

class ListButtonsGamepad extends GetView<PruebaVirtualGamepadLinuxController> {
  ListButtonsGamepad({super.key});

  final List<String> listButtons = [
    "A",
    "B",
    "C",
    "X",
    "Y",
    "Z",
    "TL",
    "TR",
    "TL2",
    "TR2",
    "THUM",
    "THUM2",
    "THUMBL",
    "THUMBR",
    "DPAD_UP",
    "DPAD_DOWN",
    "DPAD_LEFT",
    "DPAD_RIGHT",
    "START",
    "SELECT",
    "MODE",
    "JOYSTICK",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "reconnectgamepad1"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.amber,
            width: Get.width,
            height: 250,
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 6,
              mainAxisSpacing: 1,
              childAspectRatio: 2.5,
              children: List.generate(listButtons.length, (index) {
                return Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(10),
                    child: NeumorphicButton(
                      onPressed: () =>
                          controller.pressGamepad(listButtons[index], false),
                      onEndPressed: () =>
                          controller.pressGamepad(listButtons[index], true),
                      child: Text("${listButtons[index]}"),
                    ));
              }),
            ),
          ),
          Container(
            width: Get.width,
            height: 160,
            color: Colors.red,
            child: Row(
              children: [
                DpadWidget("Right"),
                DpadWidget("Left"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget DpadWidget(selectDpad) {
    return Container(
      width: Get.width / 2,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            left: 100,
            top: 10,
            child: btnDpad("DPAD_UP", selectDpad),
          ),
          Positioned(
            left: 100,
            top: 110,
            child: btnDpad("DPAD_DOWN", selectDpad),
          ),
          Positioned(
            left: 150,
            top: 60,
            child: btnDpad("DPAD_RIGHT", selectDpad),
          ),
          Positioned(
            left: 50,
            top: 60,
            child: btnDpad("DPAD_LEFT", selectDpad),
          ),
        ],
      ),
    );
  }

  Widget btnDpad(nameButton, selectDpad) {
    double degrees = 0;
    double moveDpadX = 0;
    double moveDpadY = 0;
    switch (nameButton) {
      case 'DPAD_LEFT':
        degrees = 90;
        moveDpadX = -1;
        break;
      case 'DPAD_RIGHT':
        degrees = 270;
        moveDpadX = 1;
        break;
      case "DPAD_UP":
        degrees = 180;
        moveDpadY = 1;
        break;
      default:
        degrees = 0;
        moveDpadY = -1;
        break;
    }
    final radians = degrees * math.pi / 180;
    Widget btn(void Function()? onPressed, void Function()? onEndPressed,
            Color color) =>
        NeumorphicButton(
          onPressed: onPressed,
          onEndPressed: onEndPressed,
          style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
            color: color,
            shadowLightColor: Color.fromARGB(197, 0, 0, 0),
          ),
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          child: Transform.rotate(
            angle: radians,
            child: NeumorphicIcon(
              size: 50,
              Icons.arrow_drop_down_circle_outlined,
              style: const NeumorphicStyle(
                depth: 5,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        );

    return btn(
        () => controller.pressJoystickGamepad(0, 0, selectDpad),
        () => controller.pressJoystickGamepad(moveDpadX, moveDpadY, selectDpad),
        Colors.yellow);
  }
}
