import '../enums/usbgamepad.dart';

var jsondata = [
  {
    "usbgamepad": "USBGAMEPAD.LEFT_JOYSTICK",
    "typeGamepad": "TypeGamepad.leftJoy",
    "transformButton": {
      "yOffset": 93.0,
      "xOffset": -300.0,
      "scale": 1.0,
    },
    "color": 0xFFFF9E80,
    "nameButton": "left_joy",
  },
  {
    "usbgamepad": "USBGAMEPAD.A",
    "typeGamepad": "TypeGamepad.normal",
    "transformButton": {"yOffset": 170.0, "xOffset": 350.0, "scale": 1.0},
    "color": 0xFFFF9E80,
    "nameButton": "A",
  },
  {
    "usbgamepad": "USBGAMEPAD.B",
    "typeGamepad": "TypeGamepad.normal",
    "transformButton": {
      "yOffset": 100.0,
      "xOffset": 280.0,
      "scale": 1.0,
    },
    "color": 0xFFFF9E80,
    "nameButton": "B",
  },
  {
    "usbgamepad": "USBGAMEPAD.START",
    "typeGamepad": "TypeGamepad.high",
    "transformButton": {
      "yOffset": -175.0,
      "xOffset": -20.0,
      "scale": 1.0,
    },
    "color": 0x4715ff00,
    "nameButton": "START",
  },
  {
    "usbgamepad": "USBGAMEPAD.RIGHT_SHOULDER",
    "typeGamepad": "TypeGamepad.thumb",
    "transformButton": {
      "yOffset": 25.0,
      "xOffset": 380.0,
      "scale": 1.0,
    },
    "color": 0x46545454,
    "nameButton": "Z",
  },
  {
    "usbgamepad": "USBGAMEPAD.RIGHT_THUMB",
    "typeGamepad": "TypeGamepad.thumb",
    "transformButton": {
      "yOffset": -35.0,
      "xOffset": 375.0,
      "scale": 1.0,
    },
    "color": 0x46545454,
    "nameButton": "RB",
  },
  {
    "usbgamepad": "USBGAMEPAD.LEFT_THUMB",
    "typeGamepad": "TypeGamepad.thumb",
    "transformButton": {
      "yOffset": -35.0,
      "xOffset": 255.0,
      "scale": 1.0,
    },
    "color": 0x46545454,
    "nameButton": "LB",
  },
  {
    "usbgamepad": "USBGAMEPAD.DPAD_UP",
    "typeGamepad": "TypeGamepad.dpad",
    "transformButton": {
      "yOffset": -160.0,
      "xOffset": -340.0,
      "scale": 1.0,
    },
    "color": 0xffffeb3b,
    "nameButton": "1",
  },
  {
    "usbgamepad": "USBGAMEPAD.DPAD_DOWN",
    "typeGamepad": "TypeGamepad.dpad",
    "transformButton": {
      "yOffset": -60.0,
      "xOffset": -340.0,
      "scale": 1.0,
    },
    "color": 0xffffeb3b,
    "nameButton": "-1",
  },
  {
    "usbgamepad": "USBGAMEPAD.DPAD_LEFT",
    "typeGamepad": "TypeGamepad.dpad",
    "transformButton": {
      "yOffset": -110.0,
      "xOffset": -390.0,
      "scale": 1.0,
    },
    "color": 0xffffeb3b,
    "nameButton": "-1",
  },
  {
    "usbgamepad": "USBGAMEPAD.DPAD_RIGHT",
    "typeGamepad": "TypeGamepad.dpad",
    "transformButton": {
      "yOffset": -110.0,
      "xOffset": -290.0,
      "scale": 1.0,
    },
    "color": 0xffffeb3b,
    "nameButton": "1",
  }
];

class ListDataButtons {
  List<DataButtons>? list;
  double? opacity;
  ListDataButtons({this.list, this.opacity});
  ListDataButtons.fromJson(Map<String, dynamic> json) {
    List<DataButtons> newList = [];
    for (var v in json['list']) {
      newList.add(DataButtons.fromJson(v));
    }
    list = newList;
    opacity = json['opacity'];
  }
  Map<String, dynamic> toList() {
    final Map<String, dynamic> data = {};
    data['list'] = list!.map((v) => v.toJson()).toList();
    data['opacity'] = opacity;
    return data;
  }
}

class DataButtons {
  late USBGAMEPAD usbgamepad;
  late TypeGamepad typeGamepad;
  late TransformButton transformButton;
  late String nameButton;
  late int color;
  DataButtons(
      {required this.usbgamepad,
      required this.typeGamepad,
      required this.nameButton,
      required this.transformButton,
      required this.color});

  DataButtons.fromJson(Map<String, dynamic> json) {
    usbgamepad = USBGAMEPAD.values
        .firstWhere((element) => element.toString() == json['usbgamepad']);
    typeGamepad = TypeGamepad.values
        .firstWhere((element) => element.toString() == json['typeGamepad']);
    transformButton = TransformButton.fromJson(json['transformButton']);
    nameButton = json['nameButton'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['usbgamepad'] = usbgamepad.toString();
    data['typeGamepad'] = typeGamepad.toString();
    data['transformButton'] = transformButton.toJson();
    data['nameButton'] = nameButton;
    data['color'] = color;
    return data;
  }
}

class TransformButton {
  late double yOffset;
  late double xOffset;
  late double scale;

  TransformButton({this.yOffset = 0.0, this.xOffset = 0.0, this.scale = 1.0});

  TransformButton.fromJson(Map<String, dynamic> json) {
    yOffset = json['yOffset'];
    xOffset = json['xOffset'];
    scale = json['scale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['yOffset'] = yOffset;
    data['xOffset'] = xOffset;
    data['scale'] = scale;
    return data;
  }
}
