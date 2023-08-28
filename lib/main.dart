import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamepad/app/ui/utils/enum_typebutton.dart';
import 'package:gamepad/screens/connect_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/bindings/joystickconfigure_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/ui/pages/joystickconfigure_page/joystickconfigure_page.dart';
import 'app/ui/pages/joystickconfigure_page/widgets/bubble_gamepad.dart';
import 'app/ui/pages/joystickconfigure_page/widgets/listnew.dart';
import 'app/ui/pages/windowscreen_page/truecalleroverlay.dart';
import 'app/ui/utils/listgamepad.dart';
import 'firebase/firebase_options.dart';
import 'move/move_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initialStorage();
  // await Firebase.initializeApp();
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

@pragma("vm:entry-point")
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: JoystickConfigureBinding(),
      home: BubbleGamepad(),
    ),
    //     const GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   initialRoute: Routes.CONFIGURE_GAMEPAD,
    //   // getPages: AppPages.routes,
    // )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     // home: const MyHomePage(title: 'Flutter Demo Home Page'),
  //     debugShowCheckedModeBanner: false,
  //     home: MoveWidget(),
  //   );
  // }
}

initialStorage() {
  final box = GetStorage();
  box.read("listGamepads");
  print("object");
  print(box.read('listGamepads'));
  var gamepad = GamepadType(
      name: ListGamepad.GAMEPAD_BUTTON_A,
      typeButton: TypeButton.button,
      data: {"gamepad": "A"});
  print(gamepad.toJson());
  // if (box.read('listGamepads') == null) {
  //   final listGamepad = [
  //     GamepadType(
  //         name: ListGamepad.GAMEPAD_BUTTON_A,
  //         typeButton: TypeButton.button,
  //         data: {"gamepad": "A"}),
  //     GamepadType(
  //         name: ListGamepad.GAMEPAD_BUTTON_B,
  //         typeButton: TypeButton.button,
  //         data: {"gamepad": "B"}),
  //     GamepadType(
  //         name: ListGamepad.GAMEPAD_BUTTON_X,
  //         typeButton: TypeButton.button,
  //         data: {"gamepad": "X"}),
  //     GamepadType(
  //         name: ListGamepad.GAMEPAD_BUTTON_Y,
  //         typeButton: TypeButton.button,
  //         data: {"gamepad": "D"}),
  //   ];
  //   box.write('listGamepads', listGamepad);
  // }
}
