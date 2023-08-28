import 'package:gamepad/app/ui/pages/home_page/home_page.dart';
import 'package:gamepad/app/ui/pages/joystickconfigure_page/joystickconfigure_page.dart';
import 'package:get/get.dart';
import '../bindings/firebase_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/joystickconfigure_binding.dart';
import '../bindings/pruebavirtualgamepadlinux_binding.dart';
import '../bindings/videoframes_binding.dart';
import '../bindings/videopython_binding.dart';
import '../bindings/videortm_binding.dart';
import '../bindings/videostreaming_binding.dart';
import '../bindings/windowscreen_binding.dart';
import '../ui/pages/firebase_page/firebase_page.dart';
import '../ui/pages/pruebavirtualgamepadlinux_page/pruebavirtualgamepadlinux_page.dart';
import '../ui/pages/videoframes_page/videoframes_page.dart';
import '../ui/pages/videopython_page/videopython_page.dart';
import '../ui/pages/videortm_page/videortm_page.dart';
import '../ui/pages/videostreaming_page/videostreaming_page.dart';
import '../ui/pages/windowscreen_page/windowscreen_page.dart';
import '../ui/pages/webrtc_page/webrtc_page.dart';
import '../bindings/webrtc_binding.dart';
import '../ui/pages/client_screen_socket_page/client_screen_socket_page.dart';
import '../bindings/client_screen_socket_binding.dart';
// End imports

/// Names Routes
abstract class Routes {
  static const HOME = '/home';
  static const CONFIGURE_GAMEPAD = '/configure/control';
  static const VIDEO_STREAMING = '/videostreaming';
  static const VIDEO_FRAMES = '/videoframes';
  static const VIDEO_PYTHON = '/videopython';
  static const VIDEO_RTMP = '/videortmp';
  static const WINDOW = '/window';
  static const FIREBASE = '/firebase';
  static const VIRTUALGAMEPADLINUX = '/pruebaVirtualGamepadLinux';
  static const WEBRTC = '/webrtc';
  static const CLIENT_SCREEN_SOCKET = '/client_screen_socket';
}

/// Get Routes
class AppPages {
  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(
      name: INITIAL,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.CONFIGURE_GAMEPAD,
      page: () => JoystickConfigurePage(),
      binding: JoystickConfigureBinding(),
    ),
    GetPage(
      name: Routes.VIDEO_STREAMING,
      page: () => VideoStreamingPage(),
      binding: VideoStreamingBinding(),
    ),
    GetPage(
      name: Routes.VIDEO_FRAMES,
      page: () => VideoFramesPage(),
      binding: VideoFramesBinding(),
    ),
    GetPage(
      name: Routes.VIDEO_PYTHON,
      page: () => VideoPythonPage(),
      binding: VideoPythonBinding(),
    ),
    GetPage(
      name: Routes.VIDEO_RTMP,
      page: () => VideortmPage(),
      binding: VideortmBinding(),
    ),
    GetPage(
      name: Routes.WINDOW,
      page: () => WindowScreenPage(),
      binding: WindowScreenBinding(),
    ),
    GetPage(
      name: Routes.FIREBASE,
      page: () => FirebasePage(),
      binding: FirebaseBinding(),
    ),
    GetPage(
      name: Routes.VIRTUALGAMEPADLINUX,
      page: () => PruebaVirtualGamepadLinuxPage(),
      binding: PruebaVirtualGamepadLinuxBinding(),
    ),
    GetPage(
      name: Routes.WEBRTC,
      page: () => WebrtcPage(),
      binding: WebrtcBinding(),
    ),
    GetPage(
      name: Routes.CLIENT_SCREEN_SOCKET,
      page: () => ClientScreenSocketPage(),
      binding: ClientScreenSocketBinding(),
    ),
  ];
}
