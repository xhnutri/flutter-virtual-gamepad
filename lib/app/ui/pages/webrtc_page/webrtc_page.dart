// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/webrtc_controller.dart';

// class WebrtcPage extends GetView<WebrtcController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('WebrtcPage'),
//       ),
//       body: SafeArea(
//         child: Text('WebrtcController'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:peerdart/peerdart.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import './main.dart';
// import 'dart:html' as html;

class WebrtcPage extends StatefulWidget {
  const WebrtcPage({Key? key}) : super(key: key);

  @override
  State<WebrtcPage> createState() => _WebrtcPageState();
}

class _WebrtcPageState extends State<WebrtcPage> {
  final TextEditingController _controller = TextEditingController();
  late DataConnection conn;
  // var options =
  //     PeerConnectOption(); // Aquí puedes establecer las opciones que quieras
  // var dataConnection = peer.connect('otro-id',
  //     options); // Esto crea una conexión con otro peer usando las opciones dadas

  // final Peer peer = Peer();
  final Peer peer = Peer(
      id: "client2",
      options: PeerOptions(
          debug: LogLevel.All,
          // host: "34.175.24.194",
          host: "192.168.1.95",
          port: 9000,
          path: "/",
          secure: false));
  // final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool inCall = false;
  String? peerId;

  @override
  void initState() {
    super.initState();
    print("cliente222222");
    // _localRenderer.initialize();
    _remoteRenderer.initialize();
    peer.on<MediaConnection>("call").listen((call) async {
      final mediaStream = await navigator.mediaDevices
          .getUserMedia({"video": false, "audio": true});

      call.answer(mediaStream);

      call.on("close").listen((event) {
        setState(() {
          inCall = false;
        });
      });

      call.on<MediaStream>("stream").listen((event) {
        // _localRenderer.srcObject = mediaStream;
        _remoteRenderer.srcObject = event;

        setState(() {
          inCall = true;
        });
      });
    });
    // peer.on("open").listen((id) {
    //   setState(() {
    //     peerId = peer.id;
    //   });
    // });

    // peer.on<MediaConnection>("call").listen((call) async {
    //   print("Me estan llamando");
    //   call.on("close").listen((event) {
    //     setState(() {
    //       inCall = false;
    //     });
    //   });

    //   call.on<MediaStream>("stream").listen((event) {
    //     print("-------------------Stream-----------------------");
    //     // _localRenderer.srcObject = mediaStream;
    //     _remoteRenderer.srcObject = event;

    //     setState(() {
    //       inCall = true;
    //     });
    //   });
    // });
    // peer.on<MediaConnection>("call").listen((call) async {
    //   final mediaStream = await navigator.mediaDevices
    //       .getUserMedia({"video": true, "audio": false});

    //   call.answer(mediaStream);

    //   call.on("close").listen((event) {
    //     setState(() {
    //       inCall = false;
    //     });
    //   });

    //   call.on<MediaStream>("stream").listen((event) {
    //     _localRenderer.srcObject = mediaStream;
    //     _remoteRenderer.srcObject = event;

    //     setState(() {
    //       inCall = true;
    //     });
    //   });
    // });
  }

  @override
  void dispose() {
    peer.dispose();
    _controller.dispose();
    // _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void disconnectr() {
    peer.dispose();
    _controller.dispose();
    // _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void sendf() {
    conn.send("sendShareScreen");
    conn.emit("message", "sendShareScreen");
  }

  void conect2() {
    // Connect to another peer
    conn = peer.connect('1234678');
    print("Conexcions------------------------------------------------");
    // conn.emit('message', "sllsl");
    // conn.send("Hello world!");
    if (conn.open) {
      // conn.on<String>('message').listen((event) {
      //   print("Message Received: " + event);
      // });
    }
    // conn.open = () {};
    // Do something when the connection is open
    // conn.onOpen = () {
    //   print('Connection open');
    //   // Send some data
    //   conn.send('Hello, world!');
    // };
    // Do something when data is received
    // conn.onData = (data) {
    //   print('Received data: $data');
    // };
    // // Do something when the connection is closed
    // conn.onClose = () {
    //   print('Connection closed');
    // };
  }

  void connect() async {
    // PeerConnectOption? options =
    //   PeerConnectOption(); // Aquí puedes establecer las opciones que quieras
//     var dataConnection = peer.connect('1234678'); // Esto crea una conexión con otro peer usando las opciones dadas

// dataConnection.on()
    final mediaStream = await navigator.mediaDevices
        .getUserMedia({"video": false, "audio": true});
    final conn2 = peer.call("1234678", mediaStream);

    conn2.on("close").listen((event) {
      setState(() {
        inCall = false;
      });
    });

    conn2.on<MediaStream>("stream").listen((event) {
      _remoteRenderer.srcObject = event;
      // _localRenderer.srcObject = mediaStream;

      setState(() {
        inCall = true;
      });
    });
    /*
    print(
        "---------------------" + _controller.text + "-----------------------");
    final mediaStream = await navigator.mediaDevices
        .getUserMedia({"video": true, "audio": false});

    final conn = peer.call("R3L86OS", mediaStream);

    conn.on('open').listen((id) {
      print("IDfg  ------------ : " + id.toString());
    });
    conn.on("close").listen((event) {
      setState(() {
        inCall = false;
      });
    });

    conn.on<MediaStream>("stream").listen((event) {
      print("----------ebcjbxjksk=========");
      print(event);
      print("----------end=========");
      _remoteRenderer.srcObject = event;
      // _localRenderer.srcObject = mediaStream;

      setState(() {
        inCall = true;
      });
    });
*/
    // });
    // peer.on<MediaConnection>("call").listen((call) async {
    //   final mediaStream = await navigator.mediaDevices
    //       .getUserMedia({"video": true, "audio": false});

    //   call.answer(mediaStream);

    //   // on peer closed
    //   call.on("close").listen((event) {
    //     setState(() {
    //       inCall = false;
    //     });
    //   });

    //   // Get peer stream
    //   call.on<MediaStream>("stream").listen((event) {
    //     _localRenderer.srcObject = mediaStream;
    //     _remoteRenderer.srcObject = event;

    //     setState(() {
    //       inCall = true;
    //     });
    //   });
    // });
  }

  void send() {
    // conn.send('Hello!');
  }
  @override
  Widget build(BuildContext context) {
    // return ExampleWEBRTC();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            _renderState(),
            SelectableText(peerId ?? ""),
            Positioned(
                top: 30,
                left: 200,
                child: ElevatedButton(
                    onPressed: connect, child: const Text("connect"))),
            Positioned(
                top: 70,
                child: ElevatedButton(
                    onPressed: disconnectr, child: const Text("disconnectr"))),
            Positioned(
                top: 120,
                child: ElevatedButton(
                    onPressed: sendf, child: const Text("sendf"))),
            if (inCall)
              Expanded(
                child: RTCVideoView(
                  _remoteRenderer,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _renderState() {
    Color bgColor = inCall ? Colors.green : Colors.grey;
    Color txtColor = Colors.white;
    String txt = inCall ? "Connected" : "Standby";
    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Text(
        txt,
        style:
            Theme.of(context).textTheme.titleLarge?.copyWith(color: txtColor),
      ),
    );
  }
}
