import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:three_dart/extra/blob.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:three_dart/three_dart.dart' as THREE;
import 'package:web_socket_channel/io.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../../example-webrtc/src/call_sample/signaling.dart';

class ClientScreenSocketController extends GetxController {
  RawDatagramSocket? socket;
  IOWebSocketChannel? channel;
  final getdata = StreamController<dynamic>();
  StreamController<Uint8List> controllerB =
      StreamController<Uint8List>.broadcast();
  StreamSink<Uint8List> get controllerBSink => controllerB.sink;
  Stream<Uint8List> get controllerBStream => controllerB.stream;

  StreamSink<dynamic> get getdataSink => getdata.sink;
  Stream<dynamic> get getdataStream => getdata.stream;
  final socketConnet = false.obs;
  late MediaStream _localStream;
  final remoteRenderer = RTCVideoRenderer();
  final inCall = false.obs;

  Uint8List buffer = Uint8List(0);
  int buffersize = 0;
  int parts = 0;

  @override
  void onInit() {
    super.onInit();
    remoteRenderer.initialize();
  }
  // assuming `byteArray` came in from the websocket
  // void newTexture(){
  // var texture = new three.Texture();
  // var imageBlob = new Blob([], {"type": "image/png"});
  // // var url = URL.createObjectURL(imageBlob);

  // var image = new Image();
  // image.src = url;
  // image.onload = function() {
  //     texture.image = image;
  //     texture.needsUpdate = true;
  // };
// String textureName = "images/texture.jpg";
//   Future<TextStyle> textureText(
//     TextStyle textStyle,
//   ) async {
//     ui.Image img;
//     img = await ImageLoader.load(textureName);
//     Float64List matrix4 = new Matrix4.identity().storage;
//     return textStyle.copyWith(
//         foreground: Paint1()
//           ..shader =
//               ImageShader(img, TileMode.mirror, TileMode.mirror, matrix4));
//   }
  // }
  sendss() {
    channel!.sink.add("data");
    channel!.innerWebSocket!.add("data");
    print(channel!.innerWebSocket!.readyState);
    print(channel!.innerWebSocket!);
  }

  void connectDataChannel() async {
    // /*
    try {
      String serverAddress = "192.168.1.95";
      final wsUrl = Uri.parse('ws://$serverAddress:9000/');
      channel = IOWebSocketChannel.connect(wsUrl);
      // socketConnet.value = true;
      channel!.stream.listen((message) {
        Uint8List bytesAscii = AsciiCodec().encode(message);
        // print("---");
        print(message.length);
        // print(utf8.encode(message));
        socketConnet.value = true;
        // controllerBSink.add(Uint8List.fromList(base64Decode(message)));
        getSocket(bytesAscii);
      });
    } catch (e) {
      print(e.toString());
    }
    // */
    // Signaling sig = Signaling("192.168.1.95", context);
    // await Signaling("192.168.1.95", context)
    //   ..connect();
    // await Signaling("192.168.1.95", context)
    //   ..invite(
    //       "data_channel_851091f3-3af1-4a70-9dd0-a423863178ab", "ss", false);
    // Crear el objeto FlutterWebRTCServer

    // var server = FlutterWebRTCServer(
    //   turnApiKey: "your-turn-api-key",
    //   turnSecret: "your-turn-secret",
    //   turnUrl: "turn:ip-address:port",
    // );

    // var dataChannel = RTCDataChannel(server);

// Escuchar los mensajes del servidor
//     server.stream.listen((message) {
//       // Procesar el mensaje recibido
//       print("Received message: $message");
//     });

// // Enviar un mensaje al servidor
//     dataChannel.send(RTCDataChannelMessage("Hello"));
  }

  void getSocket(Uint8List obj) {
    Uint8List recivedBytes = obj;

    try {
      // Cópias das variáveis
      Uint8List ibuffer = buffer;
      int ibuffersize = buffersize;
      int iparts = parts;
      int istate = recivedBytes[0];

      if (istate == 0) {
        parts = recivedBytes[8];
        iparts = recivedBytes[8];

        Uint8List byteBuffer = new Uint8List(7);
        List.copyRange(recivedBytes, 1, byteBuffer, 0, 7);
        // Buffer.BlockCopy(recivedBytes, 1, byteBuffer, 0, 7);
        // buffersize = Convert.ToInt32(Encoding.ASCII.GetString(byteBuffer, 0, byteBuffer.Length).Replace("-", ""));
        // print(utf8.decode(byteBuffer));
        print(AsciiCodec().decode(byteBuffer));
        buffersize = AsciiCodec().decode(byteBuffer).replaceAll("-", "").length;
        print("buffersize" + buffersize.toString());

        if (iparts == 0) {
          ibuffer = new Uint8List(buffersize);
          List.copyRange(recivedBytes, 9, ibuffer, 0, buffersize);
          // Buffer.BlockCopy(recivedBytes, 9, ibuffer, 0, buffersize);

          // ThreadPool.QueueUserWorkItem(new WaitCallback(drawBitmap), ibuffer);
          // controllerBSink.add(ibuffer);
          // Console.WriteLine("Frame"); // LOG
          return;
        }

        buffer = new Uint8List(buffersize);
        List.copyRange(recivedBytes, 9, buffer, 0, 64999);
        // Buffer.BlockCopy(recivedBytes, 9, buffer, 0, 64999);

        // Console.WriteLine("Inicio"); // LOG
      } else if (istate == parts) {
        List.copyRange(recivedBytes, 1, ibuffer, 64999 * iparts,
            ibuffersize - (64999 * iparts));
        // Buffer.BlockCopy(recivedBytes, 1, ibuffer, 64999 * iparts, ibuffersize - (64999 * iparts));
        // controllerBSink.add(ibuffer);
        // Console.WriteLine("Final"); // LOG
        // ThreadPool.QueueUserWorkItem(new WaitCallback(drawBitmap), ibuffer);
      } else {
        List.copyRange(recivedBytes, 1, ibuffer, 64999 * istate, 64999);
        // Buffer.BlockCopy(recivedBytes, 1, ibuffer, 64999 * istate, 64999);
        buffer = ibuffer;
        // Console.WriteLine("Parte"); // LOG
      }
      print("ibuffer " + ibuffer.length.toString());
    } catch (e, stack) {
      print("err: {0}" + e.toString());
      print("stack: {0}" + stack.toString());
      // Console.WriteLine("err: {0}", e);
    }
  }

  void connectServerUdp() async {
    connectDataChannel();
    // Crea un socket UDP que escucha en el puerto 8000
    // Crear un canal de web socket y conectarse al servidor
    /*
    try {
      String serverAddress = "192.168.1.95";
      final wsUrl = Uri.parse('ws://$serverAddress:9000/');
      channel = IOWebSocketChannel.connect(wsUrl);
      // socketConnet.value = true;
      channel!.stream.listen((message) {
        // message es un array de bytes
        //// hacer algo con el mensaje
        print(message);
      });
    } catch (e) {
      print(e.toString());
    }*/
    // Crear un widget StreamBuilder para escuchar los eventos del canal

// Enviar un mensaje al servidor usando el método sink.add
// channel.sink.add(‘Hola mundo!’);

// Cerrar el canal cuando no se necesite más channel.sink.close();
    // try {
    //   print("newdjkd");
    // final wsUrl = Uri.parse('ws://192.168.1.95:8080');
    // var socket2 = await Socket.connect("192.168.1.95", 8080);
    // var channel = WebSocketChannel.connect(wsUrl);
    // socket2.
    // socket2.listen((message) {
    // print("getfiles");
    // print("$message");
    // getdataSink.add(message);
    //   var texture = new THREE.Texture();
    //   var imageBlob = new Blob([message], {"type": "image/png"});

    //  var url = URL.createObjectURL(imageBlob);

    //   Image imagex = new Image(url);
    //   imagex.src = url;
    //   imagex.onload = function() {
    //       texture.image = imagex;
    //       texture.needsUpdate = true;
    //   };
    // channel.sink.add('received!');
    // channel.sink.close(status.goingAway);
    //   }, onError: (e) => print(e.toString()), onDone: () => print("Donekjsk"));
    //   print("Termino");
    //   // return null;
    // } catch (e) {
    //   print(e.toString());
    // }
    // return null;
    /*
    try {
      ///   // Read the current time from an NTP server.
      final serverAddress =
          (await InternetAddress.lookup('192.168.1.95')).first;
      print("$serverAddress");
      socket = await RawDatagramSocket.bind(serverAddress,
          8080); // Registra una función que se ejecuta cuando hay un datagrama entrante
      socket!.listen((RawSocketEvent event) {
        print("dddddddddd");
        if (event == RawSocketEvent.read) {
          // Lee el datagrama y lo decodifica como texto
          Datagram? datagram = socket!.receive();
          String message = utf8.decode(datagram!.data);
          print(
              'Recibido: $message de ${datagram.address.address}:${datagram.port}');

          // Envía una respuesta al remitente
          socket!.send(utf8.encode('Hola, recibí tu mensaje'), datagram.address,
              datagram.port);
        }
      });
      print(
          'Servidor UDP escuchando en ${socket!.address.address}:${socket!.port}');
    } catch (e) {
      print(e.toString());
    }*/
  }

  void _getUserMedia() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "turn:192.168.1.95:9000"},
        {"username": "new"},
        {"password": "r3l86lf1"},
      ]
    };
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    print("getUserMedia");
    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);
    // await pc.createDataChannel("data_channel_df26f8ee-e186-403c-9564-4e9bdc2af157");
    // pc.close;
    // pc.addStream(_localStream);
    pc.onConnectionState = (RTCPeerConnectionState state) {
      print("Statetnjd");
      print(state);
    };
    pc.onDataChannel = (e) {
      print("OndataChannel");
      print(e);
    };
    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate,
          'sdpMid': e.sdpMid,
          'sdpMlineIndex': e.sdpMLineIndex
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print('addStream: ');
      inCall.value = true;
      remoteRenderer.srcObject = stream;
    };
    // RTCDataChannel rtcChannel = RTCDataChannel.;
    // pc.onDataChannel();
    // return pc;
  }

  void disconnectServerUdp() async {
    channel!.sink.close();
    // socket!.close();
  }
}
