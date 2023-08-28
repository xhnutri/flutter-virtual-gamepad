
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/joystick_controller.dart';


class JoystickPage extends GetView<JoystickController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JoystickPage'),
      ),
      body: SafeArea(
        child: Text('JoystickController'),
      ),
    );
  }
}
  