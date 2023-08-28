import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';
import '../data/mixin/prueba_mixin.dart';
import '../data/models/datagamepad.dart';

extension GetString on String {
  String get inCaps =>
      '${this.substring(11)[0].toUpperCase()}${this.substring(12)}';
}

enum SelectMode { play, move, scale, color }

enum SockectConnect { success, pending, loading, error }

enum GamepadState {
  dialog,
  bubble,
  inApp,
}

class PruebaVirtualGamepadLinuxController extends GetxController {
  //Keys
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseFirestore db = FirebaseFirestore.instance;
  ListDataButtons dataButtons = ListDataButtons();
  double opacityButtons = 1.0;
  double changeScale = 0;
  IO.Socket? socket;
  // bool
  bool isVibrate = false;
  bool closeGamepad = false;
  RxBool neumorphicSwitch = false.obs;
  RxBool isSave = false.obs;
  // Strings
  String gamepadName = 'gamepad1';
  String hostConnect = 'firebase';
  // Enums
  final connectSocket = ValuePrueba(SockectConnect.pending);
  SelectMode selectMode = SelectMode.play;
  GamepadState gamepadState = GamepadState.inApp;
  var idBTN = "";

  @override
  void onInit() async {
    super.onInit();
    connectSocket.change(SockectConnect.pending,
        status: RxPruebaStatus.empty());
    dataButtons = ListDataButtons.fromJson({"list": jsondata, "opacity": 1.0});
  }

  // void gamepadDialog(bool type) {
  //   closeGamepad = type;
  //   update(['selectmode']);
  // }

  Future<void> getDataGamepads() async {
    final data = await db.collection("gamepadList").doc('Nintendo64').get();
    dataButtons = ListDataButtons.fromJson(data.data()!);
    update(['selectmode']);
    print(data.data()!['list'] is List);
  }

  void connectSockect(String host, int port, String gamepad) async {
    String urlnew = "tcp://34.175.106.229:8080";
    // String url = port == 8080 ? "http://" : "tcp://";
    hostConnect = host;
    // socket = IO.io('$url$host:$port', <String, dynamic>{
    //   'transports': ['websocket', 'polling'],
    // });
    socket = IO.io(urlnew, <String, dynamic>{
      'transports': ['websocket', 'polling'],
    });
    socket!.onConnect((data) {
      connectSocket.change(SockectConnect.success,
          status: RxPruebaStatus.success());
      socket!.emit(gamepadName, gamepadName);
    });
    socket!.onError((data) {
      connectSocket.change(SockectConnect.error,
          status: RxPruebaStatus.error());
      print(data);
      socket!.disconnect();
      socket!.close();
    });
    connectSocket.change(SockectConnect.loading,
        status: RxPruebaStatus.loading());
    socket!.connect();
  }

  void isSaveChanges() {
    if (isSave.value == true) {
      isSave.value = false;
    }
  }

  void disconnectSocket() {
    socket!.disconnect();
    socket!.close();
    connectSocket.change(SockectConnect.pending,
        status: RxPruebaStatus.empty());
  }

  void changeColor(String upd, int i, int color) {
    dataButtons.list![i].color = color;
    isSaveChanges();
    update([upd]);
  }

  void vibrateButton(bool press) {
    if (selectMode == SelectMode.play) {
      if (press) {
        if (!isVibrate) {
          Vibration.vibrate(duration: 150, amplitude: 255);
          isVibrate = true;
        } else {
          Vibration.cancel();
          Vibration.vibrate(duration: 150, amplitude: 255);
          isVibrate = true;
        }
      } else {
        if (isVibrate) {
          Vibration.cancel();
          isVibrate = false;
        }
      }
    }
  }

  void pressGamepad(String id, bool press) async {
    // vibrateButton(press);
    if (hostConnect == "firebase") {
      await db.collection("gamepad1").doc('self').update({
        id: press,
      });
    } else {
      socket!.emit(id, {id: press, "gamepad": gamepadName});
    }
  }

  void pressJoystickGamepad(
      double joystickX, double joystickY, selectDpad) async {
    print('${selectDpad}joystickX');
    if (joystickX == 0 && joystickY == 0) {
      // vibrateButton(false);
    } else {
      // vibrateButton(true);
    }
    if (hostConnect == "firebase") {
      await db.collection(gamepadName).doc('self').update({
        '${selectDpad}joystickX': joystickX,
        '${selectDpad}joystickY': joystickY
      });
    } else {
      socket!.emit("${selectDpad}Joystick", {
        "joystickX": joystickX,
        "joystickY": joystickY,
        "gamepad": gamepadName
      });
    }
  }

  void moveJoystickGamepad(double joystickX, double joystickY) async {
    if (joystickX != 0 && joystickY != 0) {
      if (!isVibrate) {
        // vibrateButton(true);
      }
    } else {
      // vibrateButton(false);
    }
    int fixed = 5;
    double joystickXNew = double.parse((joystickX).toStringAsFixed(fixed));
    double joystickYNew = double.parse((joystickY).toStringAsFixed(fixed)) * -1;
    print(joystickXNew.toString() + " ---- " + joystickYNew.toString());
    if (hostConnect == "firebase") {
      await db.collection(gamepadName).doc('self').update(
          {'LeftjoystickX': joystickXNew, 'LeftjoystickY': joystickYNew});
    } else {
      socket!.emit("LeftJoystick", {
        "joystickX": joystickXNew,
        "joystickY": joystickYNew,
        "gamepad": gamepadName
      });
    }
  }

  void NeumorphicSwitch_OnChanged(value) {
    neumorphicSwitch.value = value;
  }

  void NeumorphicToggle_OnChanged(value) {
    SelectMode selectNewMode;
    switch (value) {
      case 0:
        selectNewMode = SelectMode.play;
        break;
      case 1:
        selectNewMode = SelectMode.move;
        break;
      case 2:
        selectNewMode = SelectMode.scale;
        break;
      case 3:
        selectNewMode = SelectMode.color;
        break;
      default:
        selectNewMode = SelectMode.play;
        break;
    }
    selectMode = selectNewMode;
    update(['selectmode']);
  }

  void ChangeGamepadState(value) {
    print(value.toString() + " ---------- ");
    switch (value) {
      case 0:
        gamepadState = GamepadState.dialog;
        if (!closeGamepad) {
          FlutterOverlayWindow.showOverlay(
                  height: WindowSize.fullCover,
                  width: WindowSize.fullCover,
                  enableDrag: false,
                  flag: OverlayFlag.focusPointer)
              .then((value) => closeGamepad = true);
        } else {
          FlutterOverlayWindow.shareData('dialog');
          // FlutterOverlayWindow.closeOverlay().then((value) {
          //   FlutterOverlayWindow.showOverlay(
          //       height: WindowSize.fullCover,
          //       width: WindowSize.fullCover,
          //       enableDrag: false,
          //       flag: OverlayFlag.focusPointer);
          // });
        }
        break;
      case 1:
        gamepadState = GamepadState.bubble;
        if (!closeGamepad) {
          FlutterOverlayWindow.showOverlay(
                  height: 250,
                  width: 250,
                  alignment: OverlayAlignment.centerLeft,
                  positionGravity: PositionGravity.auto,
                  enableDrag: true,
                  flag: OverlayFlag.focusPointer)
              .then((value) => closeGamepad = true);
        } else {
          FlutterOverlayWindow.shareData('bubble');
          FlutterOverlayWindow.closeOverlay().then((value) {
            FlutterOverlayWindow.showOverlay(
                height: 250,
                width: 250,
                alignment: OverlayAlignment.centerLeft,
                positionGravity: PositionGravity.auto,
                enableDrag: true,
                flag: OverlayFlag.focusPointer);
          });
        }

        break;
      default:
        gamepadState = GamepadState.inApp;
        FlutterOverlayWindow.shareData('close');
        FlutterOverlayWindow.closeOverlay()
            .then((value) => closeGamepad = false);
        break;
    }
    print(gamepadState);
    update(['selectmode']);
  }

  void saveGamepad() async {
    if (isSave == false) {
      await db
          .collection("gamepadList")
          .doc('Nintendo64')
          .update(dataButtons.toList());
      isSave.value = true;
    }
  }

  void Slider_OnChangeOpacity(double value) {
    isSaveChanges();
    dataButtons.opacity = value;
    opacityButtons = value;
    update(["selectmode"]);
  }

  void GestureDetector_OnPanUpdate(
      DragUpdateDetails details, String upd, int i) {
    isSaveChanges();
    dataButtons.list![i].transformButton.yOffset += details.delta.dy;
    dataButtons.list![i].transformButton.xOffset += details.delta.dx;
    bool isMaxWidth = dataButtons.list![i].transformButton.xOffset.abs() >=
        ((Get.width / 2) - 20);
    if (isMaxWidth) {
      double direction =
          dataButtons.list![i].transformButton.xOffset > 0 ? 1 : -1;
      dataButtons.list![i].transformButton.xOffset =
          ((Get.width / 2) - 20) * direction;
    }
    bool isMaxHeight = dataButtons.list![i].transformButton.yOffset.abs() >=
        ((Get.height / 2) - 20);
    if (isMaxHeight) {
      double direction =
          dataButtons.list![i].transformButton.yOffset > 0 ? 1 : -1;
      dataButtons.list![i].transformButton.yOffset =
          ((Get.height / 2) - 20) * direction;
    }
    update([upd]);
  }

  void GestureDetector_onVerticalDragEnd(String upd) {
    isSaveChanges();
    changeScale = 0;
    update([upd]);
  }

  void GestureDetector_onVerticalDragUpdate(double dy, String upd, int i) {
    isSaveChanges();
    if (changeScale != 0) {
      dataButtons.list![i].transformButton.scale += changeScale;
      update([upd]);
    } else {
      if (dy != 0) {
        if (dy < 1) {
          changeScale = 0.005;
        } else {
          changeScale = -0.005;
        }
      }
    }
  }
}
