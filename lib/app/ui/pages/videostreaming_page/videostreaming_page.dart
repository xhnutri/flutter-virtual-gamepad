import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../../controllers/videostreaming_controller.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';

class VideoStreamingPage extends GetView<VideoStreamingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VideoStreamingPage'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              color: Color.fromARGB(255, 106, 0, 255),
              child: StreamBuilder<dynamic>(
                  stream: controller.datbytesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: Text("Connection Closed !"),
                      );
                    }
                    return Image.memory(
                      snapshot.data,
                      gaplessPlayback: true,
                      excludeFromSemantics: true,
                    );
                  }),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: NeumorphicButton(
                    child: Text("Connect"),
                    onPressed: controller.connectSocket,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: NeumorphicButton(
                    child: Text("Disconect"),
                    onPressed: controller.disconnect,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NeumorphicButton(
                    child: Text("GetImage"),
                    onPressed: controller.getImage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NeumorphicButton(
                    child: Text("disconsdjn"),
                    onPressed: controller.dddd,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NeumorphicButton(
                    child: Text("PRUEBAS"),
                    onPressed: () => controller.uuu(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NeumorphicButton(
                    child: Text("Disconnect udp"),
                    onPressed: () => controller.closeudp(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageFromBytes extends StatelessWidget {
  final Uint8List bytes;
  StreamController<Uint8List> _controller = StreamController<Uint8List>();

  ImageFromBytes({required this.bytes});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final bytes = snapshot.data!;
          Image.memory(bytes);
          // Do something with the bytes...
          return Container();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class VideoPlayerFromBytes extends StatefulWidget {
  final Uint8List bytes;

  VideoPlayerFromBytes({required this.bytes});

  @override
  _VideoPlayerFromBytesState createState() => _VideoPlayerFromBytesState();
}

class _VideoPlayerFromBytesState extends State<VideoPlayerFromBytes> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.memory(widget.bytes)
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}
