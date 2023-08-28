import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:gamepad/app/ui/pages/joystickconfigure_page/widgets/typebuttons.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../../../controllers/joystickconfigure_controller.dart';
import 'listdrawerconfigure.dart';

class ListNew extends GetView<JoystickConfigureController> {
  JoystickConfigureController get self => controller;
  const ListNew({this.showDialogBool = false});
  final bool showDialogBool;
  List<Widget> listButtons(
      JoystickConfigureController _, BuildContext context) {
    List<Widget> newList = [];
    final listButtons = _.dataButtons.list!;
    for (int i = 0; i < listButtons.length; i++) {
      final nameButton =
          _.dataButtons.list![i].usbgamepad.toString().substring(11);
      newList.add(GetBuilder<JoystickConfigureController>(
          id: nameButton,
          builder: (_) {
            return TypesButtons(
                dataButtons: _.dataButtons.list![i],
                nameButton: nameButton,
                i: i,
                self: _,
                context: context);
          }));
    }
    if (showDialogBool == true) {
      newList.add(Positioned(
          top: 30,
          right: 50,
          child: NeumorphicButton(
            onPressed: () {
              FlutterOverlayWindow.closeOverlay().then((value) {
                FlutterOverlayWindow.showOverlay(
                        height: 250,
                        width: 250,
                        alignment: OverlayAlignment.centerLeft,
                        positionGravity: PositionGravity.auto,
                        enableDrag: true,
                        flag: OverlayFlag.defaultFlag)
                    .then((value) {
                  FlutterOverlayWindow.shareData('bubble');
                });
              });
            },
            style: const NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
              color: Colors.red,
              shadowLightColor: Color.fromARGB(197, 0, 0, 0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Icon(
              Icons.featured_video,
              size: 20,
            ),
          )));
      newList.add(Positioned(
          top: 30,
          right: 5,
          child: NeumorphicButton(
            onPressed: () {
              FlutterOverlayWindow.closeOverlay().then((value) {
                FlutterOverlayWindow.shareData('close').then((val) {});
                self.closeGamepad = false;
                self.update(['selectmode']);
              });
            },
            style: const NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
              color: Colors.red,
              shadowLightColor: Color.fromARGB(197, 0, 0, 0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Icon(
              Icons.close,
              size: 20,
            ),
          )));
    }
    if (_.gamepadState == GamepadState.dialog) {
      newList.add(
        Positioned(
            top: 100,
            right: 100,
            child: NeumorphicButton(
              onPressed: () async {
                await FlutterOverlayWindow.closeOverlay();
              },
              onEndPressed: () => {},
              style: const NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
                color: Colors.red,
                shadowLightColor: Color.fromARGB(197, 0, 0, 0),
              ),
              padding: const EdgeInsets.all(15.0),
              child: const Icon(
                Icons.close,
                size: 30,
              ),
            )),
      );
    } else {}
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    if (showDialogBool) {}
    return GetBuilder<JoystickConfigureController>(
        id: 'selectmode',
        builder: (_) {
          return Scaffold(
              key: _.scaffoldKey,
              backgroundColor:
                  NeumorphicColors.gradientShaderWhiteColor(intensity: 0),
              endDrawer: SafeArea(
                child: Drawer(
                    width: 300,
                    child: ListDrawerConfigure(
                        self: _, showDialogBool: showDialogBool)),
              ),
              body: Opacity(
                  opacity: _.dataButtons.opacity!,
                  child: Stack(children: listButtons(_, context))));
        });
  }
}
