import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../../../controllers/joystickconfigure_controller.dart';
import '../../../../data/enums/usbgamepad.dart';
import '../../../../data/models/datagamepad.dart';
import 'package:gamepad/joystick/flutter_joystick.dart';
import 'dart:math' as math;

import '../../../../libs/colorpicker/flutter_colorpicker.dart';

class TypesButtons extends StatelessWidget {
  TypesButtons({
    required this.dataButtons,
    required this.nameButton,
    required this.i,
    required this.self,
    required this.context,
  });
  final DataButtons dataButtons;
  final String nameButton;
  final int i;
  final JoystickConfigureController self;
  final BuildContext context;

  Widget allWidget(Widget child) {
    return getSelectMode(transformGamepad(child));
  }

  Widget getSelectMode(
    Widget typeButton,
  ) {
    switch (self.selectMode) {
      case SelectMode.move:
        return GestureDetector(
            onPanUpdate: (details) =>
                self.GestureDetector_OnPanUpdate(details, nameButton, i),
            child: typeButton);
      case SelectMode.scale:
        return GestureDetector(
            onVerticalDragEnd: (details) =>
                self.GestureDetector_onVerticalDragEnd(nameButton),
            onVerticalDragUpdate: (details) =>
                self.GestureDetector_onVerticalDragUpdate(
                    details.delta.dy, nameButton, i),
            child: typeButton);
      default:
        return typeButton;
    }
  }

  Widget transformGamepad(Widget gamepad) {
    return Center(
      child: Transform.translate(
          offset: Offset(dataButtons.transformButton.xOffset,
              dataButtons.transformButton.yOffset),
          child: Transform.scale(
              scale: dataButtons.transformButton.scale, child: gamepad)),
    );
  }

  void changeColorBtn(
      Widget Function(void Function()?, void Function()?, Color) widgetBtn) {
    Color pickerColor = Color(dataButtons.color);
    void changeColor(Color color) {
      pickerColor = color;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            colorPickerWidth: 250,
            pickerHsvColor: HSVColor.fromColor(pickerColor),
            pickerColor: Color(dataButtons.color),
            hexInputBar: false,
            widgetBtn: widgetBtn,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Change Color'),
            onPressed: () {
              int colorInt = int.parse(pickerColor
                  .toString()
                  .substring(6, pickerColor.toString().length - 1));
              self.changeColor(nameButton, i, colorInt);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget btnNormal() {
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
          padding: const EdgeInsets.all(15.0),
          child: NeumorphicText(
            dataButtons.nameButton,
            style: NeumorphicStyle(
              depth: 5,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
        );
    if (self.selectMode == SelectMode.color) {
      return btn(() => changeColorBtn(btn), () {}, Color(dataButtons.color));
    } else {
      return btn(() => self.pressGamepad(nameButton, false),
          () => self.pressGamepad(nameButton, true), Color(dataButtons.color));
    }
  }

  Widget btnIcon() {
    double degrees = 0;
    double moveDpadX = 0;
    double moveDpadY = 0;
    String nameFirebase = "joystickY";
    switch (nameButton) {
      case 'DPAD_LEFT':
        degrees = 90;
        moveDpadX = -1;
        nameFirebase = "joystickX";
        break;
      case 'DPAD_RIGHT':
        degrees = 270;
        moveDpadX = 1;
        nameFirebase = "joystickX";
        break;
      case "DPAD_UP":
        degrees = 180;
        moveDpadY = 1;
        nameFirebase = "joystickY";
        break;
      default:
        degrees = 0;
        moveDpadY = -1;
        nameFirebase = "joystickY";
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

    if (self.selectMode == SelectMode.color) {
      return btn(() => changeColorBtn(btn), () {}, Color(dataButtons.color));
    } else {
      return btn(
          () => self.pressJoystickGamepad(nameFirebase, 0, 0),
          () => self.pressJoystickGamepad(nameFirebase, moveDpadX, moveDpadY),
          Color(dataButtons.color));
    }
  }

  Widget btnDpad() {
    double degrees = 0;
    double moveDpadX = 0;
    double moveDpadY = 0;
    String nameFirebase = "joystickY";
    switch (nameButton) {
      case 'DPAD_LEFT':
        degrees = 90;
        moveDpadX = -1;
        nameFirebase = "joystickX";
        break;
      case 'DPAD_RIGHT':
        degrees = 270;
        moveDpadX = 1;
        nameFirebase = "joystickX";
        break;
      case "DPAD_UP":
        degrees = 180;
        moveDpadY = 1;
        nameFirebase = "joystickY";
        break;
      default:
        degrees = 0;
        moveDpadY = -1;
        nameFirebase = "joystickY";
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

    if (self.selectMode == SelectMode.color) {
      return btn(() => changeColorBtn(btn), () {}, Color(dataButtons.color));
    } else {
      return btn(
          () => self.pressJoystickGamepad(nameFirebase, 0, 0),
          () => self.pressJoystickGamepad(nameFirebase, moveDpadX, moveDpadY),
          Color(dataButtons.color));
    }
  }

  Widget btnHigh() {
    Widget btn(void Function()? onPressed, void Function()? onEndPressed,
            Color color) =>
        NeumorphicButton(
          margin: const EdgeInsets.only(top: 12),
          onPressed: onPressed,
          onEndPressed: onEndPressed,
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
            color: color,
            shadowLightColor: const Color.fromARGB(200, 255, 255, 255),
            intensity: 5,
            depth: 2,
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            dataButtons.nameButton,
            style: const TextStyle(
                color: Color.fromARGB(188, 255, 255, 255),
                fontSize: 15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        );

    if (self.selectMode == SelectMode.color) {
      return btn(() => changeColorBtn(btn), () {}, Color(dataButtons.color));
    } else {
      return btn(() => self.pressGamepad(nameButton, false),
          () => self.pressGamepad(nameButton, true), Color(dataButtons.color));
    }
  }

  Widget btnThumb() {
    Widget btn(void Function()? onPressed, void Function()? onEndPressed,
            Color color) =>
        NeumorphicButton(
          margin: EdgeInsets.only(top: 12),
          onPressed: onPressed,
          onEndPressed: onEndPressed,
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            color: color,
            shadowLightColor: Color.fromARGB(200, 255, 255, 255),
            intensity: 5,
            depth: 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
          child: Text(
            dataButtons.nameButton,
            style: TextStyle(
                color: Color.fromARGB(188, 255, 255, 255),
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
        );
    if (self.selectMode == SelectMode.color) {
      return btn(() => changeColorBtn(btn), () {}, Color(dataButtons.color));
    } else {
      return btn(() => self.pressGamepad(nameButton, false),
          () => self.pressGamepad(nameButton, true), Color(dataButtons.color));
    }
  }

  Widget leftJoy() {
    if (self.selectMode == SelectMode.scale) {
      return NeumorphicButton(
        style: const NeumorphicStyle(
          color: Color.fromARGB(0, 0, 0, 0),
          shadowLightColor: Color.fromARGB(0, 0, 0, 0),
        ),
        child: Joystick(
          listener: (percentage) {},
          isMoveOrZoom: true,
        ),
      );
    }
    if (self.selectMode == SelectMode.play) {
      return Joystick(
        listener: (percentage) {
          self.moveJoystickGamepad(percentage.x, percentage.y);
        },
        isMoveOrZoom: false,
      );
    }
    return Joystick(
      listener: (percentage) {
        self.moveJoystickGamepad(percentage.x, percentage.y);
      },
      isMoveOrZoom: true,
    );
  }

  Widget rightJoy() {
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    switch (dataButtons.typeGamepad) {
      case TypeGamepad.normal:
        return allWidget(btnNormal());
      case TypeGamepad.dpad:
        return allWidget(btnDpad());
      case TypeGamepad.high:
        return allWidget(btnHigh());
      case TypeGamepad.thumb:
        return allWidget(btnThumb());
      case TypeGamepad.leftJoy:
        return allWidget(leftJoy());
      case TypeGamepad.rightJoy:
        return allWidget(rightJoy());
      default:
        return Text("heloo");
    }
  }
}
