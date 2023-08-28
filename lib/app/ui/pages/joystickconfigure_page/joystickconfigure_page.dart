import 'package:flutter/material.dart';
import 'package:gamepad/app/ui/pages/joystickconfigure_page/widgets/listnew.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import '../../../controllers/joystickconfigure_controller.dart';

class JoystickConfigurePage extends GetView<JoystickConfigureController> {
  JoystickConfigureController get self => controller;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);
    return Container(color: Colors.white, child: ListNew());
  }
}
