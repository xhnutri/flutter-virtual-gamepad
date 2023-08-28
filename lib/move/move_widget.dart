import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gamepad/neumorphic/flutter_neumorphic.dart';
import 'package:gamepad/joystick/flutter_joystick.dart';
// import 'package:get/get.dart';

enum SelectMode { play, move, scale }

class MoveWidget extends StatefulWidget {
  @override
  _MoveWidgetState createState() => _MoveWidgetState();
}

class _MoveWidgetState extends State<MoveWidget> {
  double _yOffset = 0;
  double _xOffset = 0;
  double _yOffsetRT = 0;
  double _xOffsetRT = 0;
  double _scaleJoy = 1;
  int _selectedIndex = 0;
  bool neumorphicSwitch = false;
  double _scale = 1;
  double _opacityButtons = 5;
  SelectMode _selectMode = SelectMode.move;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: NeumorphicColors.gradientShaderWhiteColor(intensity: .8),
      endDrawer: SafeArea(
        child: Drawer(
          surfaceTintColor:
              NeumorphicColors.gradientShaderWhiteColor(intensity: 1),
          width: 300,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(15),
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
              ListTile(
                title: NeumorphicText(
                  "Save",
                  style: NeumorphicStyle(
                    depth: 5,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onTap: () {},
              ),
              Center(
                child: Column(
                  children: [
                    // Column(children: [
                    Text(
                      "Zoom / Move",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // ]),
                    NeumorphicSwitch(
                      onChanged: (value) => {
                        setState(() => neumorphicSwitch = value),
                        print(neumorphicSwitch)
                      },
                      value: neumorphicSwitch,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Align(
                  child: NeumorphicText(
                    "Mode",
                    style: NeumorphicStyle(
                      intensity: 1,
                      depth: 5, //customize depth here
                      color: NeumorphicColors
                          .decorationMaxDarkColor, //customize color here
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, //customize size here
                      // AND others usual text style properties (fontFamily, fontWeight, ...)
                    ),
                  ),
                ),
              ),
              Center(
                child: NeumorphicToggle(
                  height: 30,
                  width: 250,
                  selectedIndex: _selectedIndex,
                  displayForegroundOnlyIfSelected: true,
                  style: NeumorphicToggleStyle(
                      lightSource: LightSource.topLeft,
                      backgroundColor: Colors.white,
                      depth: 10,
                      border: NeumorphicBorder(
                          color: Color.fromARGB(81, 54, 105, 244))),
                  children: [
                    ToggleElement(
                      background: Center(
                          child: Text(
                        "Play",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      foreground: Center(
                          child: Text(
                        "Play",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    ),
                    ToggleElement(
                      background: Center(
                          child: Text(
                        "Move",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      foreground: Center(
                          child: Text(
                        "Move",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    ),
                    ToggleElement(
                      background: Center(
                          child: Text(
                        "Scale",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      foreground: Center(
                          child: Text(
                        "Scale",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                    )
                  ],
                  thumb: Neumorphic(),
                  onChanged: (value) {
                    SelectMode selectNewMode;
                    switch (value) {
                      case 0:
                        selectNewMode = SelectMode.play;
                        break;
                      case 1:
                        selectNewMode = SelectMode.move;
                        break;
                      case 2:
                        selectNewMode = SelectMode.scale;
                        break;
                      default:
                        selectNewMode = SelectMode.play;
                        break;
                    }
                    setState(() {
                      _selectMode = selectNewMode;
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Align(
                  child: NeumorphicText(
                    "Opacity Buttons",
                    style: NeumorphicStyle(
                      intensity: 1,
                      depth: 5, //customize depth here
                      color: NeumorphicColors
                          .decorationMaxDarkColor, //customize color here
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18, //customize size here
                      // AND others usual text style properties (fontFamily, fontWeight, ...)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, left: 14, right: 14),
                    child: NeumorphicSlider(
                      height: 15,
                      value: _opacityButtons,
                      min: 0,
                      max: 255,
                    ),
                  ),
                  Slider(
                    overlayColor: MaterialStatePropertyAll(
                        const Color.fromARGB(0, 244, 67, 54)),
                    activeColor: Color.fromARGB(0, 0, 0, 0),
                    inactiveColor: const Color.fromARGB(0, 0, 0, 0),
                    secondaryActiveColor: const Color.fromARGB(0, 0, 0, 0),
                    thumbColor: const Color.fromARGB(0, 0, 0, 0),
                    value: _opacityButtons,
                    min: 0,
                    max: 255,
                    onChanged: (double value) {
                      setState(() {
                        _opacityButtons = value;
                      });
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        _selectMode == SelectMode.move
            ? GestureDetector(
                onPanUpdate: (details) => {
                      setState(() {
                        _yOffset += details.delta.dy;
                        _xOffset += details.delta.dx;
                      })
                    },
                child: getJoystick())
            : GestureDetector(
                onScaleUpdate: (details) {
                  double velocity = 0.001;
                  if (details.scale < 1) {
                    velocity = velocity * -1;
                  }
                  _scaleJoy += velocity;
                  if (_scaleJoy < .5) {
                    _scaleJoy = .5;
                  }
                  if (_scaleJoy > 2) {
                    _scaleJoy = 2;
                  }
                  setState(() {
                    _scaleJoy = _scaleJoy;
                  });
                },
                child: getJoystick()),
        Align(
          widthFactor: 2,
          heightFactor: 20,
          child: NeumorphicButton(
            onPressed: () {
              print("onClick");
            },
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
              color: Color.fromARGB(_opacityButtons.toInt(), 253, 39, 39),
              shadowLightColor: Color.fromARGB(200, 255, 255, 255),
            ),
            padding: const EdgeInsets.all(15.0),
            child: NeumorphicText(
              "A",
              style: NeumorphicStyle(
                depth: 5, //customize depth here
                color: Color.fromARGB(_opacityButtons.toInt(), 255, 255,
                    255), //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40, //customize size here
                // AND others usual text style properties (fontFamily, fontWeight, ...)
              ),
            ),
          ),
        ),
        Align(
          widthFactor: 5,
          heightFactor: 20,
          child: NeumorphicButton(
            margin: EdgeInsets.only(top: 12),
            onPressed: () {},
            style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
              color: Color.fromARGB(71, 21, 255, 0),
              shadowLightColor: Color.fromARGB(200, 255, 255, 255),
              intensity: 5,
              depth: 2,
            ),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Start",
              style: TextStyle(
                  color: Color.fromARGB(188, 255, 255, 255),
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) => {
            setState(() {
              _yOffsetRT += details.delta.dy;
              _xOffsetRT += details.delta.dx;
            })
          },
          child: Align(
            child: Transform.translate(
              offset: Offset(_xOffsetRT, _yOffsetRT),
              child: NeumorphicButton(
                margin: EdgeInsets.only(top: 12),
                onPressed: () {},
                style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  color: Color.fromARGB(70, 84, 84, 84),
                  shadowLightColor: Color.fromARGB(200, 255, 255, 255),
                  intensity: 5,
                  depth: 2,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: const Text(
                  "RT",
                  style: TextStyle(
                      color: Color.fromARGB(188, 255, 255, 255),
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: NeumorphicButton(
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            child: Icon(
              Icons.more_vert,
              size: 30,
            ),
          ),
        ),
      ]),
    ); //     ),
  }

  Widget getJoystick() {
    return Center(
      child: Transform.scale(
          scale: _scaleJoy,
          child: Transform.translate(
            offset: Offset(_xOffset, _yOffset),
            child: Joystick(
              listener: (percentage) {},
              isMoveOrZoom: _selectMode == SelectMode.play ? false : true,
            ),
          )),
    );
  }
}
