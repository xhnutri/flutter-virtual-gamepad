import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class SteerClient {
  late Socket socket;
  String? serverAddress;
  late StreamSubscription<UserAccelerometerEvent> sensorSubscription;
  int range = 32767;
  double y = 0;
  Uint8List bytes = new Uint8List(0);
  StreamSocket streamSocket = StreamSocket();

  SteerClient(String serverAddress) {
    // print(serverAddress);
    socket = io(
        'http://$serverAddress:8080',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()
            .build());

    socket.onConnect((data) {
      // socket.on('image', (data) => streamSocket.addResponse(data));
      print('connected');
    });

    socket.on('vibrate', (data) {
      print('vibrate');
      Vibration.vibrate(duration: 2000000);
    });

    socket.on('cancel-vibrate', (data) {
      print('vibrate');
      Vibration.cancel();
    });
    socket.connect();
  }

  disconnectSocket() {
    socket.disconnect();
  }

  initializeMotionSensor() {
    magnetometerEvents.listen(
      (MagnetometerEvent event) {
        // print(event);
        var gyroscope_sensor_value = event.z;
        // var gradesX = ((gyroscope_sensor_value * 180) / math.pi);

        // Future.delayed(const Duration(milliseconds: 1000), () {
        // print("MagnetometerEvent Z: $event");
        // });
      },
      onError: (error) {},
      cancelOnError: true,
    );
    gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        // getData(int num1, int num2) async {
        // try {
        //   final int result =
        //       await platform.invokeMethod('add', {'num1': num1, 'num2': num2});
        //     print('$result');
        //   } on PlatformException catch (e) {
        //     print(e);
        //   }
        // }
        var gyroscope_sensor_value = event.z;
        var gradesX = ((gyroscope_sensor_value * 180) / math.pi);
        // print("gyroscope Z: $gradesX");
        // var y = event.z;
        // var x = ((y*3400)>range)?range:((y*3400)<(-1*range))?(-1*range):(y*3400).toInt();
      },
      onError: (error) {},
      cancelOnError: true,
    );
    sensorSubscription = userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        var gyroscope_sensor_value = event.z;
        var gradesX = ((gyroscope_sensor_value * 180) / math.pi);
        // print("UserAccelerometerEvent Z: $gradesX");
        // print(event);
        // (event){
        //  print("----------------");
        // event[0].
        // if((y-event.y).abs()>0.2){
        //   y=event.y;
        //   Map data={
        //     'x':((y*3400)>range)?range:((y*3400)<(-1*range))?(-1*range):(y*3400).toInt()
        //   };
        // socket.emit('steer',event.x);
        // }
        // };
      },
      onError: (error) {},
      cancelOnError: true,
    );
  }

  moveLeftJoystick(StickDragDetails details) {
    print("Move Left  ");
    print(details.x);
    print("details.y: ${details.y}");
    final moveY = details.y * -1;
    socket.emit('leftjoystick', {"x": details.x, "y": moveY});
  }

  pressAccelerate() {
    socket.emit('press-accelerate', {});
  }

  releaseAccelerate() {
    socket.emit('release-accelerate', {});
  }

  pressBrake() {
    socket.emit('press-brake', {});
  }

  releaseBrake() {
    socket.emit('release-brake', {});
  }

  press(String buttonID) {
    socket.emit('press', {'id': buttonID});
  }

  release(String buttonID) {
    socket.emit('release', {'id': buttonID});
  }

  dispose() {
    socket.dispose();
    sensorSubscription.cancel();
  }
}
