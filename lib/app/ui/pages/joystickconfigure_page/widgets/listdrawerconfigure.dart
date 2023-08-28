import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:gamepad/app/data/mixin/prueba_mixin.dart';
import 'package:gamepad/app/ui/pages/joystickconfigure_page/widgets/select_form_field.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart' as neu;
import 'package:get/get.dart';
import '../../../../controllers/joystickconfigure_controller.dart';
import '../../../utils/listgamepad.dart';

class ListDrawerConfigure extends StatelessWidget {
  final JoystickConfigureController self;
  final bool showDialogBool;
  const ListDrawerConfigure({required this.self, this.showDialogBool = false});
  List<ToggleElement> toggleElementList() {
    final selectMode =
        SelectMode.values.map((e) => e.toString().inCaps).toList();
    return selectMode
        .map(
          (e) => ToggleElement(
            background: Center(
                child: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            foreground: Center(
                child: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
          ),
        )
        .toList();
  }

  List<ToggleElement> toggleElementbyList(List<String> list) {
    return list
        .map(
          (e) => ToggleElement(
            background: Center(
                child: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            foreground: Center(
                child: Text(
              e,
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
          ),
        )
        .toList();
  }

  void connectByDialog(BuildContext context) {
    // tcp: //7.tcp.eu.ngrok.io:12176
    var host = '192.168.1.95';
    var port = 8080;
    // 5.tcp.eu.ngrok.io:13312
    // var host = '5.tcp.eu.ngrok.io';
    // var port = 13312;
    var gamepad = 'gamepad1';
    final List<Map<String, dynamic>> _items = [
      {
        'value': 'gamepad1',
        'label': 'Gamepad 1',
      },
      {
        'value': 'gamepad2',
        'label': 'Gamepad 2',
      },
      {
        'value': 'gamepad3',
        'label': 'Gamepad 3',
      },
    ];
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        width: 400,
                        height: 100,
                        child: neu.TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Host',
                          ),
                          onChanged: (text) => host = text,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: neu.TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Port',
                          ),
                          onChanged: (text) => port = int.parse(text),
                        ),
                      ),
                    ]),
                    SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        initialValue: 'gamepad1',
                        icon: Icon(Icons.gamepad_sharp),
                        labelText: 'Control',
                        items: _items,
                        onChanged: (val) => gamepad = val)
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Connect'),
                  onPressed: () {
                    print(host);
                    print(port);
                    print(gamepad);
                    self.connectSockect(host, port, gamepad);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: <Widget>[
      Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(5),
        child: NeumorphicText(
          "Options",
          style: NeumorphicStyle(
            depth: 3,
            color: NeumorphicColors.decorationMaxWhiteColor,
          ),
          textStyle: NeumorphicTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        decoration: BoxDecoration(
          color: NeumorphicColors.accent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: self.connectSocket.obx(
          (val) => SocketState(
            "Disconnect",
            color: Color.fromARGB(255, 255, 89, 89),
            colorIcon: const Color.fromARGB(255, 129, 235, 80),
            icon: Icons.check_circle,
            onPressed: () => self.disconnectSocket(),
          ),
          onLoading: const SocketState(
            "Loading...",
            color: Color.fromARGB(255, 0, 174, 255),
            colorIcon: Color.fromARGB(255, 0, 115, 255),
          ),
          onError: (e) => SocketState(
            "Reconnect",
            color: Color.fromARGB(255, 255, 149, 117),
            colorIcon: Color.fromARGB(255, 236, 51, 0),
            icon: Icons.error,
            onPressed: () => connectByDialog(context),
          ),
          onEmpty: SocketState(
            "Connect",
            color: const Color.fromARGB(255, 129, 235, 80),
            colorIcon: const Color.fromARGB(255, 255, 200, 0),
            icon: Icons.pending,
            onPressed: () => connectByDialog(context),
          ),
        ),
      ),
      Center(
          child: NeumorphicToggle(
        height: 30,
        width: 250,
        selectedIndex: self.gamepadState.index,
        displayForegroundOnlyIfSelected: true,
        style: const NeumorphicToggleStyle(
            lightSource: LightSource.topLeft,
            backgroundColor: Colors.white,
            depth: 10,
            border: NeumorphicBorder(color: Color.fromARGB(81, 54, 105, 244))),
        children: toggleElementbyList(['dialog', 'bubble', 'inApp']),
        thumb: Neumorphic(),
        onChanged: self.ChangeGamepadState,
      )),
      buttonDialog(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          tileColor: Color.fromARGB(255, 0, 0, 0),
          title: NeumorphicText(
            "Connect",
            style: NeumorphicStyle(
              depth: 2,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          onTap: () => self.getDataGamepads(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => ListTile(
              tileColor: self.isSave.value
                  ? Color.fromARGB(255, 43, 255, 0)
                  : Color.fromARGB(255, 178, 232, 167),
              title: NeumorphicText(
                "Save" + (self.isSave.value ? "" : " *"),
                style: NeumorphicStyle(
                  depth: 2,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onTap: self.saveGamepad,
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          child: NeumorphicText(
            "Buttons",
            style: NeumorphicStyle(
              intensity: 1,
              depth: 5,
              color: NeumorphicColors.decorationMaxDarkColor,
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicButton(
                  onPressed: () => Get.dialog(widgetDialogue()),
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                      color: Color.fromARGB(255, 129, 235, 80),
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicIcon(
                        style: NeumorphicStyle(color: Colors.white),
                        Icons.add_circle,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(
                width: 10,
              ),
              NeumorphicButton(
                  onPressed: () => Get.dialog(widgetDialogue()),
                  padding: EdgeInsets.all(10),
                  style: NeumorphicStyle(
                      color: Color.fromARGB(255, 235, 80, 80),
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicIcon(
                        style: NeumorphicStyle(color: Colors.white),
                        Icons.remove_circle,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Remove",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ],
          )),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Align(
          child: NeumorphicText(
            "Mode",
            style: NeumorphicStyle(
              intensity: 1,
              depth: 5,
              color: NeumorphicColors.decorationMaxDarkColor,
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      Center(
          child: NeumorphicToggle(
        height: 30,
        width: 250,
        selectedIndex: self.selectMode.index,
        displayForegroundOnlyIfSelected: true,
        style: const NeumorphicToggleStyle(
            lightSource: LightSource.topLeft,
            backgroundColor: Colors.white,
            depth: 10,
            border: NeumorphicBorder(color: Color.fromARGB(81, 54, 105, 244))),
        children: toggleElementList(),
        thumb: Neumorphic(),
        onChanged: self.NeumorphicToggle_OnChanged,
      )),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Align(
          child: NeumorphicText(
            "Opacity Buttons",
            style: const NeumorphicStyle(
              intensity: 1,
              depth: 5, //customize depth here
              color: NeumorphicColors.decorationMaxDarkColor,
            ),
            textStyle: NeumorphicTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
              child: NeumorphicSlider(
                height: 15,
                value: self.opacityButtons,
                min: 0,
                max: 1,
              ),
            ),
            Slider(
              overlayColor: const MaterialStatePropertyAll(
                  Color.fromARGB(0, 244, 67, 54)),
              activeColor: const Color.fromARGB(0, 0, 0, 0),
              inactiveColor: const Color.fromARGB(0, 0, 0, 0),
              secondaryActiveColor: const Color.fromARGB(0, 0, 0, 0),
              thumbColor: const Color.fromARGB(0, 0, 0, 0),
              value: self.opacityButtons,
              min: 0,
              max: 1,
              onChanged: self.Slider_OnChangeOpacity,
            ),
          ])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: NeumorphicButton(
            onPressed: () async {
              await FlutterOverlayWindow.closeOverlay();
              self.closeGamepad = false;
              self.update(['selectmode']);
            },
            padding: const EdgeInsets.all(10),
            style: NeumorphicStyle(
                color: const Color.fromARGB(255, 7, 102, 255),
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft),
            child: const Row(children: [
              Icon(Icons.featured_video, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                "Close Dialog",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ])),
      ),
    ]);
  }

  Widget buttonDialog() {
    return self.closeGamepad == true
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: NeumorphicButton(
                onPressed: () {
                  FlutterOverlayWindow.closeOverlay().then((value) {
                    FlutterOverlayWindow.shareData('close');
                  });
                  self.closeGamepad = false;
                  self.update(['selectmode']);
                },
                padding: const EdgeInsets.all(10),
                style: NeumorphicStyle(
                    color: const Color.fromARGB(255, 7, 102, 255),
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    lightSource: LightSource.topLeft),
                child: const Row(children: [
                  Icon(Icons.featured_video, color: Colors.white),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Close Dialog",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ])),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: NeumorphicButton(
                onPressed: () {
                  FlutterOverlayWindow.showOverlay(
                          height: 250,
                          width: 250,
                          alignment: OverlayAlignment.centerLeft,
                          positionGravity: PositionGravity.auto,
                          enableDrag: true,
                          flag: OverlayFlag.defaultFlag)
                      .then((val) {
                    FlutterOverlayWindow.shareData('bubble');
                  });
                  self.closeGamepad = true;
                  self.update(['selectmode']);
                },
                padding: const EdgeInsets.all(10),
                style: NeumorphicStyle(
                    color: const Color.fromARGB(255, 7, 102, 255),
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 8,
                    lightSource: LightSource.topLeft),
                child: const Row(children: [
                  Icon(Icons.featured_video, color: Colors.white),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Show Dialog",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ])),
          );
  }

  Widget widgetDialogue() {
    List<Widget> listButtons = [];
    ListGamepad.values.forEach((element) {
      listButtons.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Neumorphic(
            padding: EdgeInsets.all(20),
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,
                color: const Color.fromARGB(255, 255, 255, 255)),
            child: Text(
              element.toString().substring(20, element.toString().length),
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
      ));
    });
    return Center(
        child: Container(
      width: 200,
      height: Get.height,
      child: SingleChildScrollView(child: Column(children: listButtons)),
    ));
  }
}

class SocketState extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color color;
  final Color colorIcon;
  final IconData? icon;

  const SocketState(this.text,
      {Key? key,
      this.onPressed,
      required this.color,
      required this.colorIcon,
      this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      NeumorphicButton(
          onPressed: onPressed,
          padding: const EdgeInsets.all(10),
          style: NeumorphicStyle(
              color: color,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
              depth: 8,
              lightSource: LightSource.topLeft),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
      const SizedBox(
        width: 10,
      ),
      const Text("States: ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      icon == null
          ? const CircularProgressIndicator()
          : Icon(
              size: 35,
              color: colorIcon,
              icon,
            ),
    ]);
  }
}
