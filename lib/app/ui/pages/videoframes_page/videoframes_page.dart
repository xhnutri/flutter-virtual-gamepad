import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoFramesPage extends StatefulWidget {
  @override
  _VideoFramesPageState createState() => _VideoFramesPageState();
}

class _VideoFramesPageState extends State<VideoFramesPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  File? file;
  Socket? socket;
  String? filePath;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));
    _initializeVideoPlayerFuture = _controller.initialize();

    // });
    // socket.listen((data) async {
    //   await File('temp.mp4').writeAsBytes(data);
    //   setState(() {
    //     _controller = VideoPlayerController.file(File('temp.mp4'));
    //     _initializeVideoPlayerFuture = _controller.initialize();
    //   });
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              print("Conection");
              final socket = await Socket.connect("192.168.1.95", 8080);
              stdin.listen((data) {
                print(data);
              });
              socket.listen((data) async {
                try {
                  // print(result!.files.single.path);
                  final file = File(filePath!);
                  // IOSink sinkStream;
                  // sinkStream.add(data);
                  // await sinkStream.flush();
                  // await sinkStream.close();
                  await file.writeAsBytes(data);
                  print("Video");
                  // var sink = file.openWrite();
                  // // await for (final data in socket) {
                  // sink.add(data);
                  // await sink.flush();
                  // await sink.close();

                  setState(() {
                    _controller = VideoPlayerController.file(file);
                    _initializeVideoPlayerFuture = _controller.initialize();
                  });
                } catch (e, stack) {
                  print(e.toString());
                  print(stack.toString());
                }
                // await File('temp.mp4').writeAsBytes(data);
                // setState(() {
                //   _controller = VideoPlayerController.file(File('temp.mp4'));
                //   _initializeVideoPlayerFuture = _controller.initialize();
                // });
              });
              // setState(() {
              // });
            },
            child: Icon(
              _controller.value.isPlaying
                  ? Icons.abc_rounded
                  : Icons.access_alarm,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              try {
                Future<File> createFileInCacheDirectory(String fileName) async {
                  final cacheDir = await getTemporaryDirectory();
                  setState(() {
                    filePath = '${cacheDir.path}/$fileName';
                  });
                  filePath = '${cacheDir.path}/$fileName';
                  return File(filePath!).create();
                }

                await createFileInCacheDirectory("video.mp4");
                // final tempDir = await getTemporaryDirectory();
                // print(tempDir);
                // final result =
                //     await FilePicker.platform.pickFiles(type: FileType.video);
                // print(result!.files.single.path);
                // file = File(result.files.single.path!);
                // final sink = file!.openWrite();
                // await for (final data in socket) {
                // sink.add([]);
                // }
                // await sink.flush();
                // await sink.close();
              } catch (e) {
                print(e.toString());
              }
              // final result =
              //     await FilePicker.platform.pickFiles(type: FileType.video);
              // print("-----------------------------");
              // print(result!.files.single.path);
              // print("-----------------------------");
            },
            child: Icon(
              Icons.add_box,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              try {
                // Future<File> createFileInCacheDirectory(String fileName) async {
                // final cacheDir = await getTemporaryDirectory();
                // setState(() {
                //   filePath = '${cacheDir.path}/$fileName';
                // });
                // var fileName = "video.mp4";
                // var filePaths = '${cacheDir.path}/$fileName';
                // return File(filePaths!).create();
                // }

                // await createFileInCacheDirectory("video.mp4");
                final socket = await Socket.connect("192.168.1.95", 8080);
                socket.listen((data) async {
                  // Create a temporary file to store the frame data
                  File tempFile = await File(
                          '${(await getTemporaryDirectory()).path}/frame.mp4')
                      .create();

                  final sink = tempFile.openWrite();
                  sink.add(data);
                  await sink.close();
                  // Write the frame data to the temporary file
                  // await tempFile.writeAsBytes(data);

                  setState(() {
                    _controller = VideoPlayerController.file(tempFile);
                    _initializeVideoPlayerFuture = _controller.initialize();
                  });
                  // Add the frame to the video player controller
                  // _controller
                  //   ..initialize().then((_) {
                  //     _controller.addTimedMetadata({
                  //       'type': 'video',
                  //       'src': tempFile.path,
                  //     });
                  //   });
                });
              } catch (e, stack) {
                print(e.toString());
                print(stack.toString());
              }
            },
            child: Icon(
              Icons.archive,
            ),
          ),
        ],
      ),
    );
  }
}




/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../neumorphic/src/widget/button.dart';
import '../../../controllers/videoframes_controller.dart';

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
// import 'dart:convert';
import 'dart:io';

// void main() async {
// }

class VideoFramesPage extends StatefulWidget {
  @override
  _ImageFromSocketState createState() => _ImageFromSocketState();
}

class _ImageFromSocketState extends State<VideoFramesPage> {
  IOWebSocketChannel? channel;
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    String serverAddress = "192.168.1.95";
    final wsUrl = Uri.parse('ws://$serverAddress:8080');
    channel = IOWebSocketChannel.connect(wsUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image from Socket'),
      ),
      body: StreamBuilder(
        stream: channel!.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bytes = snapshot.data;
            return Image.memory(bytes!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    channel!.sink.close();
  }
}

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class VideoFramesPage2 extends StatefulWidget {
  const VideoFramesPage2({Key? key}) : super(key: key);

  @override
  _SocketStreamState createState() => _SocketStreamState();
}

class _SocketStreamState extends State<VideoFramesPage2> {
  late IO.Socket socket;
  List<String> messages = [];
  StreamSocket streamSocket = StreamSocket();

  @override
  void initState() {
    super.initState();
    String serverAddress = "192.168.1.95";
    socket = IO.io('http://$serverAddress:8080', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.on('connect', (_) => print('connect: ${socket.id}'));
    socket.on('image', (data) => streamSocket.addResponse(data));
    socket.on('disconnect', (_) => print('disconnect'));
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Socket Stream'),
        ),
        body: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: Text("Connection Closed !"),
              );
            }
            //? Working for single frames
            return Image.memory(
              Uint8List.fromList(utf8.encode(snapshot.data!)),
              // Uint8List.fromList(
              //   base64Decode(
              //     (snapshot.data.toString()),
              //   ),
              // ),
              gaplessPlayback: true,
            );
          },
        )

        // StreamBuilder(
        //   stream: Stream.fromIterable(messages),
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData) return const Text('No data');
        //     return ListView.builder(
        //       itemCount: snapshot.data!.length,
        //       itemBuilder: (context, index) =>
        //           ListTile(title: Text(snapshot.data![index])),
        //     );
        //   },
        // ),
        );
  }
}
/*
class VideoFramesPage extends GetView<VideoFramesController> {
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
                color: Colors.red,
                child: StreamBuilder(
                    stream: controller.client.streamSocket.getResponse,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        return const Center(
                          child: Text("Connection Closed !"),
                        );
                      }
                      //? Working for single frames
                      return Image.memory(
                        Uint8List.fromList(
                          base64Decode(
                            (snapshot.data.toString()),
                          ),
                        ),
                        gaplessPlayback: true,
                      );
                    })),
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/
// import 'dart:async';

//Step3: Build widgets with streambuilder

// class BuildWithSocketStream extends StatelessWidget {
//   const BuildWithSocketStream({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: StreamBuilder(
//         stream: controller.client.streamSocket.getResponse ,
//         builder: (BuildContext context, AsyncSnapshot<String> snapshot){
//           return Container(
//             child: snapshot.data,
//           );
//         },
//       ),
//     );
//   }
// }

class VideoPlayerFromNetwork extends StatefulWidget {
  final String url;

  VideoPlayerFromNetwork({required this.url});

  @override
  _VideoPlayerFromNetworkState createState() => _VideoPlayerFromNetworkState();
}

class _VideoPlayerFromNetworkState extends State<VideoPlayerFromNetwork> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  List<Uint8List> frames = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
    _controller.addListener(() async {
      if (_controller.value.isPlaying) {
        // final imageBytes = await _controller.
        // texture.toImage(
        //   _controller.value.size.width.toInt(),
        //   _controller.value.size.height.toInt(),
        // );
        // final byteData =
        //     await imageBytes.toByteData(format: ImageByteFormat.png);
        // final bytes = byteData!.buffer.asUint8List();
        // setState(() {
        //   frames.add(0);
        // });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: frames.length,
                    itemBuilder: (context, index) =>
                        Image.memory(frames[index]),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controller.value.isPlaying) {
            await _controller.pause();
          } else {
            await _controller.play();
          }
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
*/