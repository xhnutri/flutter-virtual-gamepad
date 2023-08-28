import 'dart:convert';
import 'dart:typed_data';

import 'package:gamepad/app/ui/pages/videopython_page/web_sockets.dart';
// import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:app/styles/styles.dart';

class VideoPythonPage extends StatefulWidget {
  const VideoPythonPage({Key? key}) : super(key: key);

  @override
  State<VideoPythonPage> createState() => _VideoPythonPageState();
}

class _VideoPythonPageState extends State<VideoPythonPage> {
  final WebSocket _socket = WebSocket("ws://192.168.1.95:8080");
  bool _isConnected = false;
  bool isImage = false;
  String snapshota = "";
  void connect(BuildContext context) async {
    _socket.connect();
    setState(() {
      _isConnected = true;
    });
  }

  void disconnect() {
    _socket.disconnect();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Video 3"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Stack(
            children: [
              _isConnected
                  ? Container(
                      width: Get.width,
                      height: Get.height,
                      child: StreamBuilder(
                        stream: _socket.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return isImage
                                ? Image.memory(
                                    snapshot.data,
                                    gaplessPlayback: true,
                                    excludeFromSemantics: true,
                                  )
                                : Center(
                                    child: Text("Connection Closed !"),
                                  );
                          }
                          print(snapshot.data.toString());
                          return Image.memory(
                            // snapshot.data,
                            Uint8List.fromList(
                              base64Decode(
                                (snapshot.data.toString()),
                              ),
                            ),
                            gaplessPlayback: true,
                            excludeFromSemantics: true,
                          );
                        },
                      ),
                    )
                  : const Text("Initiate Connection"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => connect(context),
                    style: Styles.buttonStyle,
                    child: const Text("Connect"),
                  ),
                  ElevatedButton(
                    onPressed: disconnect,
                    style: Styles.buttonStyle,
                    child: const Text("Disconnect"),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Styles {
  static final buttonStyle =
      ElevatedButton.styleFrom(fixedSize: const Size(120.0, 10.0));

  static final buttonStyle2 = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
    primary: Colors.blue,
    minimumSize: const Size(200, 40),
  );

  static const textStyle = TextStyle(
      color: Colors.blue,
      fontFamily: 'Kalam',
      fontSize: 20,
      fontWeight: FontWeight.bold);
}
