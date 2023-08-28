import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../../../../neumorphic/flutter_neumorphic.dart';
import '../../../../../neumorphic/src/widget/button_double.dart';
import 'listnew.dart';

class BubbleGamepad extends StatefulWidget {
  const BubbleGamepad({Key? key}) : super(key: key);

  @override
  State<BubbleGamepad> createState() => _BubbleGamepadState();
}

class _BubbleGamepadState extends State<BubbleGamepad> {
  Color color = const Color(0xFFFFFFFF);
  BoxShape _currentShape = BoxShape.circle;
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? messageFromOverlay;
  String eventInProcess = "";
  String saveEventInProcess = "close";

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      // if (eventInProcess == "") {
      if (event.toString() == "close") {
        // eventInProcess = "close";
        setState(() {
          saveEventInProcess = "close";
        });
        // FlutterOverlayWindow.closeOverlay()
        //     .then((value) => eventInProcess = "");
      }
      if (event.toString() == "bubble") {
        // eventInProcess = "bubble";
        setState(() {
          saveEventInProcess = "bubble";
        });
        // FlutterOverlayWindow.closeOverlay().then((value) {
        //   eventInProcess = "";
        //   FlutterOverlayWindow.showOverlay(
        //       height: 250,
        //       width: 250,
        //       alignment: OverlayAlignment.centerLeft,
        //       positionGravity: PositionGravity.auto,
        //       enableDrag: true,
        //       flag: OverlayFlag.focusPointer);
        //   setState(() {
        //     saveEventInProcess = "bubble";
        //   });
        // });
      }
      if (event.toString() == "dialog") {
        // eventInProcess = "dialog";
        // FlutterOverlayWindow.closeOverlay().then((value) {
        //   eventInProcess = "";
        //   FlutterOverlayWindow.showOverlay(
        //       height: WindowSize.fullCover,
        //       width: WindowSize.fullCover,
        //       alignment: OverlayAlignment.centerLeft,
        //       positionGravity: PositionGravity.auto,
        //       enableDrag: false,
        //       flag: OverlayFlag.focusPointer);
        // });
        // }
      }
      log("--------skjdkjsdkj-----------");
      log(event.toString());
      log("---------djdsks----------");
    });
    // if (homePort != null) return;
    // final res = IsolateNameServer.registerPortWithName(
    //   _receivePort.sendPort,
    //   _kPortNameOverlay,
    // );
    // log("$res : HOME");
    // _receivePort.listen((message) {
    //   log("message from UI: $message");
    //   setState(() {
    //     messageFromOverlay = 'message from UI: $message';
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    log("saveEventInProcess: " + saveEventInProcess.toString());
    return prueba(context);
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        // onPanUpdate: (details) async {
        //   // await FlutterOverlayWindow.showOverlay();
        //   await FlutterOverlayWindow.resizeOverlay(50, 100);
        // },
        onTap: () async {
          print("Ontap");
          if (_currentShape == BoxShape.rectangle) {
            await FlutterOverlayWindow.resizeOverlay(50, 100);
            setState(() {
              _currentShape = BoxShape.circle;
            });
          } else {
            await FlutterOverlayWindow.resizeOverlay(
              WindowSize.matchParent,
              WindowSize.matchParent,
            );
            setState(() {
              _currentShape = BoxShape.rectangle;
            });
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: _currentShape,
          ),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _currentShape == BoxShape.rectangle
                    ? SizedBox(
                        width: 200.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            homePort ??= IsolateNameServer.lookupPortByName(
                              _kPortNameHome,
                            );
                            homePort?.send('Date: ${DateTime.now()}');
                          },
                          child: const Text("Send message to UI"),
                        ),
                      )
                    : Positioned(right: 0, top: 0, child: Icon(Icons.cancel)),
                _currentShape == BoxShape.rectangle
                    ? messageFromOverlay == null
                        ? const FlutterLogo()
                        : Text(messageFromOverlay ?? '')
                    : const FlutterLogo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget prueba(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    log("saveEventInProcess.toString() : " + saveEventInProcess.toString());
    if (saveEventInProcess.toString() == "dialog") {
      return ListNew(
        showDialogBool: true,
      );
    }
    if (saveEventInProcess.toString() == "close") {
      return Container(width: 100, height: 100, color: Colors.blue);
    }
    return Container(
      color: Color.fromARGB(0, 121, 111, 152),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 10,
            child: NeumorphicButtonDouble(
              onPressed: () {
                FlutterOverlayWindow.closeOverlay().then((value) {
                  FlutterOverlayWindow.showOverlay(
                          height: WindowSize.fullCover,
                          width: WindowSize.fullCover,
                          enableDrag: false,
                          flag: OverlayFlag.focusPointer)
                      .then((value) {
                    setState(() {
                      saveEventInProcess = "dialog";
                    });
                  });
                });
              },
              style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  color: Color(0xff00aff4),
                  shadowLightColor: Color.fromARGB(198, 6, 6, 6),
                  intensity: 1,
                  depth: 2,
                  surfaceIntensity: .6),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Icon(
                Icons.videogame_asset,
                size: 40,
              ),
            ),
          ),
          // Positioned(
          //     top: 10,
          //     right: 10,
          //     child: NeumorphicButton(
          //       onPressed: () async {
          //         await FlutterOverlayWindow.closeOverlay();
          //       },
          //       padding: EdgeInsets.all(2),
          //       style: const NeumorphicStyle(
          //           shape: NeumorphicShape.concave,
          //           boxShape: NeumorphicBoxShape.circle(),
          //           shadowLightColor: Color.fromARGB(197, 0, 0, 0),
          //           color: Color(0xfff4493c),
          //           lightSource: LightSource.bottomLeft),
          //       child: Icon(
          //         Icons.close,
          //         size: 20,
          //       ),
          //     )),
          // GestureDetector(
          //   onTap: () => log("Eliminar Dialog"),
          //   child: CircleAvatar(
          //     backgroundColor: Color(0xfff4493c),
          //     radius: 12,
          //     child: Icon(
          //       Icons.close,
          //       size: 15,
          //     ),
          //   ),
          // ),
          // ),
          // ElevatedButton(
          //     onPressed: () async {
          //       log('Try to close');
          //       // await FlutterOverlayWindow.closeOverlay();
          //     },
          //     child: Text("Exit Dialog")),
          // SizedBox(
          //   height: 10,
          // ),
          // ElevatedButton(
          //     onPressed: () {
          //       log('Try to close');
          //       // FlutterOverlayWindow.closeOverlay().then((value) {
          //       //   FlutterOverlayWindow.showOverlay(
          //       //       height: 500,
          //       //       width: 200,
          //       //       alignment: OverlayAlignment.center,
          //       //       positionGravity: PositionGravity.auto,
          //       //       enableDrag: true,
          //       //       flag: OverlayFlag.focusPointer);
          //       //   log('Open Dialog Window:');
          //       // });
          //     },
          //     child: Text("Open Dialog Window")),
        ],
      ),
    );
  }
}
