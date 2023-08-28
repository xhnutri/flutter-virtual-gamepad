import 'enum_typebutton.dart';

enum ListGamepad {
  // GAMEPAD_DPAD_UP,
  // GAMEPAD_DPAD_DOWN,
  // GAMEPAD_DPAD_LEFT,
  // GAMEPAD_DPAD_RIGHT,
  // GAMEPAD_START,
  // GAMEPAD_BACK,
  // GAMEPAD_LEFT_THUMB,
  // GAMEPAD_RIGHT_THUMB,
  // GAMEPAD_LEFT_SHOULDER,
  // GAMEPAD_RIGHT_SHOULDER,
  // GAMEPAD_GUIDE,
  // GAMEPAD_A,
  // GAMEPAD_B,
  // GAMEPAD_X,
  // GAMEPAD_Y,

  GAMEPAD_BUTTON_UP,
  GAMEPAD_BUTTON_DOWN,

  GAMEPAD_DPAD_UP,
  GAMEPAD_DPAD_DOWN,
  GAMEPAD_DPAD_LEFT,
  GAMEPAD_DPAD_RIGHT,

  GAMEPAD_BUTTON_A,
  GAMEPAD_BUTTON_B,
  GAMEPAD_BUTTON_X,
  GAMEPAD_BUTTON_Y,

  GAMEPAD_BUTTON_L1,
  GAMEPAD_BUTTON_L2,

  GAMEPAD_BUTTON_R1,
  GAMEPAD_BUTTON_R2,

  GAMEPAD_BUTTON_START,
  GAMEPAD_BUTTON_SELECT,
}

class GamepadType {
  ListGamepad name;
  Map<String, dynamic> data;
  TypeButton typeButton;
  bool IsUsed;
  GamepadType(
      {required this.name,
      required this.data,
      required this.typeButton,
      this.IsUsed = false});

  factory GamepadType.fromJson(Map<String, dynamic> json) {
    int indexListGamepad =
        ListGamepad.values.indexWhere((e) => e.toString() == json['name']);
    ListGamepad name = ListGamepad.values[indexListGamepad];
    int indexTypeButton =
        TypeButton.values.indexWhere((e) => e.toString() == json['name']);
    TypeButton typeButton = TypeButton.values[indexTypeButton];
    return GamepadType(name: name, data: json['data'], typeButton: typeButton);
  }

  Map<String, dynamic> toJson() => {
        'name': name.toString(),
        'data': data,
        'typeButton': typeButton.toString()
      };
}
