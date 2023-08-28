
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/firebase_controller.dart';


class FirebasePage extends GetView<FirebaseController> {
  FirebaseController get self => controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FirebasePage'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text('FirebaseController'),
            TextButton(child: Text('Hello'), onPressed: () => self.getData(),)
          ],
        ),
      ),
    );
  }
}
  