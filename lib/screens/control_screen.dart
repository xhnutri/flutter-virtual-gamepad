import 'package:flutter/material.dart';
// import 'package:galli_motion_sensors/galli_motion_sensors.dart';
import 'package:gamepad/utils/client_service.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({Key? key, required this.serverAddress}) : super(key: key);


  final String serverAddress;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  
  late SteerClient client;
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;
  @override
  void initState() {
    client=SteerClient(widget.serverAddress);
    client.initializeMotionSensor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTapDown: (details) => client.pressBrake(),
                      onTapUp: (details)=>client.releaseBrake(),
                      onTapCancel: ()=>client.releaseBrake(),
                      child: Container(
                        padding: EdgeInsets.all(40),
                        child: Icon(Icons.pause, color: Colors.white, size: 50,)
                      ),
                    ),
                  ),
                  Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTapDown: (details) => client.press('Y'),
                    onTapUp: (details)=>client.release('Y'),
                    onTapCancel: ()=>client.release('Y'),
                    child: Container(
                      padding: EdgeInsets.all(40),
                      child: Icon(Icons.car_rental, color: Colors.white, size: 50,)
                    ),
                 ),
                )
                ],
              ),
        //        Transform(
        //         transform: new Matrix4.identity()
        // ..rotateZ(15 * 3.1415927 / 0),
                //  child: 
                 Joystick(
                  listener: client.moveLeftJoystick
                  ),
              //  ),
              Expanded(child: Container(),),
              Expanded(child: Container(),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTapDown: (details) => client.pressAccelerate(),
                      onTapUp: (details)=>client.releaseAccelerate(),
                      onTapCancel: ()=>client.releaseAccelerate(),
                      child: Container(
                        padding: EdgeInsets.all(40),
                        child: Icon(Icons.speed, color: Colors.white, size: 50,)
                      ),
                    ),
                  ),
                  Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTapDown: (details) => client.press('A'),
                    onTapUp: (details)=>client.release('A'),
                    onTapCancel: ()=>client.release('A'),
                    child: Container(
                      padding: EdgeInsets.all(40),
                      child: Icon(Icons.fire_extinguisher, color: Colors.white, size: 50,)
                    ),
                 ),
                )
                ],
              )
            ]
          ),
        ),
      ),  
    );
  }


  @override
  void dispose() {
    client.dispose();
    super.dispose();
  }
}