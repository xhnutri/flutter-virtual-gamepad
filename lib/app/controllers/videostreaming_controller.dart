import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../utils/client_service.dart';

class VideoStreamingController extends GetxController {
  late SteerClient client;
  Rx<Uint8List> bytes = Uint8List(0).obs;

  final datbytes = StreamController<dynamic>();
  StreamSink<dynamic> get datbytesSink => datbytes.sink;
  Stream<dynamic> get datbytesStream => datbytes.stream;

  /// Obtenemos los datos de los usuarios
  final counterStateController = StreamController<Uint8List>();
  StreamSink<Uint8List> get mStreamSink => counterStateController.sink;
  Stream<Uint8List> get counter => counterStateController.stream;
  VideoPlayerController? _controller;
  File? _videoFile;
  Socket? socket2;
  RawDatagramSocket? socketUDP;
  void connectSocket() async {
    // final socket = await Socket.connect("192.168.1.95", 8080);
    // socket.listen((data) {
    //   print("");
    //   // final message = utf8.decode(data);
    //   print('Received hhhhh: $data');
    //   final sizeInBytes = data.lengthInBytes;
    //   print(sizeInBytes);
    //   counterStateController.add(data);
    //   // bytes.value = data;
    // });
    client = SteerClient("192.168.1.95");
    client.socket.on('image', (data) {
      //   print('Get ImageInServers');
      //   // List<int> list = data.codeUnits;
      //   // bytes = Uint8List.fromList(list);
      final sizeInBytes = data.lengthInBytes;
      print(sizeInBytes);
      counterStateController.add(data);
      //   // bytes.value = data;
      //   // bytes = data;
      //   // print(object)
      //   print(data);
    });
    // client.socket.onAny((event, data) {
    //   print(event);
    //   print("data");
    // });
  }

  void getImage() async {
    print('Get Image');
    // tcp: //:17583
    socket2 = await Socket.connect("192.168.1.95", 8080);
    List<int> imagebase64 = [];
    bool isInit = false;
    int sizeImageInit = 0;
    int sizeImageComplete = 0;
    String imageString = '';
    String sssss = '';
    bool LengthImageLista = false;
    String dadada = '';
    int sizeImageInit2 = 0;
    int sizeImageComplete2 = 0;
    int listenInt = 0;
    socket2!.listen((dynamic data) async {
      String datad = utf8.decode(data);
      listenInt++;
      print(listenInt);
      // print(data);
      int lenBytesImage = data.length;
      imageString += utf8.decode(data);
      void PrintImage() {
        sizeImageComplete2 = imageString.length;
        if (sizeImageInit2 == 0) {
          if (imageString.length >= 8) {
            sizeImageInit2 = pruebas(imageString.substring(0, 8)) + 8;
          }
        }
        print("gfgv: " + imageString.length.toString());
        print("sizeImageInit: " +
            sizeImageInit2.toString() +
            "  ==========  sizeImageComplete2: " +
            sizeImageComplete2.toString());
        if (sizeImageInit2 != 0 && !LengthImageLista) {
          if (sizeImageComplete2 == sizeImageInit2) {
            dadada = imageString.substring(8, sizeImageInit2);
            var send = Uint8List.fromList(base64Decode(dadada));
            datbytesSink.add(send);
            sizeImageInit2 = 0;
            imageString = '';
          } else if (sizeImageComplete2 > sizeImageInit2) {
            dadada = imageString.substring(8, sizeImageInit2);
            var send = Uint8List.fromList(base64Decode(dadada));
            datbytesSink.add(send);
            print("anterior: " + imageString.length.toString());
            imageString =
                imageString.substring(sizeImageInit2, imageString.length);
            print("imageString: " + imageString);
            sizeImageInit2 = 0;
            // if (imageString.length >= 8) {
            PrintImage();
            // }
            // print(imageString.substring(sizeImageInit2, sizeImageInit2 + ));
            // print(stringutf);
            // LengthImageLista = true;
          } else {
            if (dadada != '' && ((imageString.length - 8) < dadada.length)) {
              dadada = dadada.substring(imageString.length, dadada.length);
              dadada = imageString.substring(8, imageString.length) + dadada;
              var send = Uint8List.fromList(base64Decode(dadada));
              datbytesSink.add(send);
            }
            print("ENTRO");
          }
        }
      }

      PrintImage();

      // if (dadada != '') {
      //   try {
      //     var send = Uint8List.fromList(base64Decode(dadada));
      //     datbytesSink.add(send);
      //     dadada = '';
      //   } catch (e) {
      //     print(e.toString());
      //   }
      // }
      // final string = utf8.decode(data);
      final string = '';
      // print(string.length);
      // var send = Uint8List.fromList(base64Decode(string));
      // datbytesSink.add(send);
      // if (dadada != '') {
      //   var send = Uint8List.fromList(base64Decode(dadada));
      //   datbytesSink.add(send);
      // }
      /*
      print(isInit);
      if (!isInit) {
        print(string);
        final inicio = string.split('KCk=');
        if (inicio.length > 1) {
          final lenImage = inicio[0];
          // final lenImage = inicio[0];
          sizeImageComplete = inicio[1].length;
          imageString = inicio[1];
          print(sizeImageComplete);
          print(inicio[1]);
          sizeImageInit = int.parse(utf8.decode(base64.decode(lenImage)));
          print("sizeImageInit: " + sizeImageInit.toString());
          print("Inicio length: " + inicio.length.toString());
          isInit = true;
        }
      } else {
        if (!imageLista) {
          final lengthListData = string.length;
          imageString += string;
          sizeImageComplete += lengthListData;
          final suma = sizeImageComplete;
          if (suma > sizeImageInit) {
            print("suma");
            dadada = imageString.substring(0, sizeImageInit);
            print(dadada);
            print(dadada.length);
            imageLista = true;
          }
          if (suma < sizeImageInit) {
            // int lengthdata = lengthListData;
            print('ImageMenor: ' + sizeImageComplete.toString());
          }
          if (suma == sizeImageInit) {
            print("ImagenCOmpleta");
            imageLista = true;
            // isInit = false;
          }
        }
      }*/
      // final string = '';
      void sifunciona() {
        final inicio = string.split('KCk=');
        // var end = string.split('KQ==');
        print(inicio.length);
        if (inicio.length == 1) {
          var end = inicio[0].split('KQ==');
          // print(inicio[0].length);
          print("end 0: " + end.length.toString());
          for (var element in end) {
            print("end element =============");
            print(element);
          }
        } else if (inicio.length > 1) {
          // final inicio = string.split('KCk=');
          for (String element in inicio) {
            print("inicio");
            print(element);
            if (element != '') {
              var end = element.split('KQ==');
              print("End length: " + end.length.toString());
              for (String element2 in end) {
                print(element2);
                if (element2 != '') {
                  // print("End length: " + element2.length.toString());
                  // print("end");
                  // print(element2);
                  // var send = Uint8List.fromList(base64Decode(element2));
                  // Uint8List.fromList(base64Decode(element));
                  // datbytesSink.add(send);
                }
              }
            }
          }
        }
      }

      // sifunciona();
      // print("end length: " + inicio.length.toString());
      // for (var element in end) {
      //   print("end");
      //   print(element);
      // }
      // print(string);
      print("--------------------------------------");
      //print("Listening for");
      //   final string = utf8.decode(data);
      //   print(string);
      // if(data.length == 6512){
      // var send = Uint8List.fromList(base64Decode(utf8.decode(data)));
      //   datbytesSink.add(send);
      // datbytesSink.add(base64Decode(base64Encode(utf8.decode(data))));
      // }
      // });
      // socketUDP!.listen((dynamic data) async {
      // final string = utf8.decode(data);
      try {
        /*
        String final2 =
            utf8.decode(data.sublist(data.length - 4, data.length));
        if (final2 == 'KQ==') {
          imagebase64= [...imagebase64,...data.sublist(0, data.length - 4)];
          print('final');
          print(imagebase64);
          // await Future.delayed(const Duration(milliseconds: 1000), () {
            final send = Uint8List.fromList(base64Decode(utf8.decode(data)));
            datbytesSink.add(send);
          // });
          // datbytesSink.add(imagebase64);
          imagebase64 =[];
        } else {
          imagebase64 = [...imagebase64,...data];
        }
      */

        /*
        String init2 = utf8.decode(data.sublist(0, 4));
        String final2 = utf8.decode(data.sublist(data.length - 4, data.length));
        print(data);
        print(data.length);
        String base64String = utf8.decode(data);
        // print(text);
        // print(base64Encode(data));
        String init = base64String.substring(0, 4);
        String end =
            base64String.substring(base64String.length - 4, base64String.length);
        print(base64String.length);
        if (init2 == 'KCk=') {
          print("init");
        }
        if (final2 == 'KQ==') {
          print('final');
        }*/
        // print(object)
        // base64Encode(data);
        // print(base64Encode(data));
        // var base = Uint8List.fromList(base64Decode(base64Encode(data)));
        // if (data is Uint8List) {
        //   var len = data.toList().length;
        //   // print(data.toList().length);
        //   if (len >= 41518) {
        //     datbytesSink.add(data);
        //   }
        // }
        // print("no error");
      } catch (e, stack) {
        print("--------------error-----------");
        print(e);
        print(stack);
      }
      // final bytes = base64.decode(data);
      // final string = utf8.decode(data);
      // print(string);
      // Uint8List bytes = base64.decode(string);
      // byte[] decodedImageBytes = Base64.decode(encodedImage, Base64.DEFAULT);
      // Bitmap bitmap = BitmapFactory.decodeByteArray(decodedImageBytes, 0, decodedImageBytes.length)
      // await Future.delayed(const Duration(milliseconds: 1000), () {
      // datbytesSink.add(data);
      // });
      // });
      // stdin.listen((data) {
      //   print(data);
      //   datbytesSink.add(data);
    });
    // client.socket.emit('image', "hello world");
  }

  void dddd() async {
    print('Get Image');

    socket2!.close();
    socket2!.destroy();
    // stdin.listen((data) {
    //   print(data);
    // });
    // client.socket.emit('image', "hello world");
  }

  void closeudp() {
    socketUDP!.close();
  }

  int pruebas(bytesdata) {
    String pp = bytesdata;
    final bytes = Uint8List.fromList(base64Decode(pp));
    final buffer = Uint8List.fromList(bytes).buffer;
    final data = ByteData.view(buffer);
    final value = data.getUint32(0, Endian.big);
    print(value);
    return value;
  }

  void uuu() async {
    var data = 'Hello, World!'.codeUnits;
    var address = InternetAddress("192.168.1.95");
    var port = 8080;
    socketUDP = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socketUDP!.send(data, address, port);
    print('Get Image');
    String imageString = '';
    String dadada = '';
    int sizeImageInit2 = 0;
    int sizeImageComplete2 = 0;
    int listenInt = 0;
    socketUDP!.listen((dynamic rawdata) async {
      print(data);

      Datagram? d = socketUDP!.receive();
      data = d!.data;
      // RawSocketEvent.write;
      // data = socketUDP!.read();

      listenInt++;
      print(listenInt);
      imageString += utf8.decode(data);
      void PrintImage() {
        sizeImageComplete2 = imageString.length;
        if (sizeImageInit2 == 0) {
          if (imageString.length >= 8) {
            sizeImageInit2 = pruebas(imageString.substring(0, 8)) + 8;
          }
        }
        print("gfgv: " + imageString.length.toString());
        print("sizeImageInit: " +
            sizeImageInit2.toString() +
            "  ==========  sizeImageComplete2: " +
            sizeImageComplete2.toString());
        if (sizeImageInit2 != 0) {
          if (sizeImageComplete2 == sizeImageInit2) {
            dadada = imageString.substring(8, sizeImageInit2);
            var send = Uint8List.fromList(base64Decode(dadada));
            datbytesSink.add(send);
            sizeImageInit2 = 0;
            imageString = '';
          } else if (sizeImageComplete2 > sizeImageInit2) {
            dadada = imageString.substring(8, sizeImageInit2);
            var send = Uint8List.fromList(base64Decode(dadada));
            datbytesSink.add(send);
            print("anterior: " + imageString.length.toString());
            imageString =
                imageString.substring(sizeImageInit2, imageString.length);
            print("imageString: " + imageString);
            sizeImageInit2 = 0;
            PrintImage();
          } else {
            if (dadada != '' && ((imageString.length - 8) < dadada.length)) {
              dadada = dadada.substring(imageString.length, dadada.length);
              dadada = imageString.substring(8, imageString.length) + dadada;
              var send = Uint8List.fromList(base64Decode(dadada));
              datbytesSink.add(send);
            }
            print("ENTRO");
          }
        }
      }

      PrintImage();
    });
  }

  void disconnect() {
    client.disconnectSocket();
    print("Disconnect");
  }

  Future<void> _playVideo(File file) async {
    if (file != null) {
      _controller = new VideoPlayerController.file(file);
      await _controller!.setVolume(1.0);
      await _controller!.initialize();
      await _controller!.setLooping(true);
      await _controller!.play();
      // setState(() {});
    }
  }

  void _chooseVideo() async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
      await _controller!.pause();
    }
    // final File pickedFile = await FilePicker.getFile(
    //   type: FileType.video,
    //   allowCompression: false,
    // );
    // if (pickedFile != null) {
    //   print(" ====================== chosen path ${pickedFile.path}");

    //   setState(() {
    //     _videoFile = pickedFile;
    //   });

    //   Future.delayed(Duration(milliseconds: 1000), () async {
    //     await _playVideo(_videoFile);
    //   });
    // }
  }
}
