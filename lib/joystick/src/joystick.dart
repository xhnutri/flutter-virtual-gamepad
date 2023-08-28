import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'joystick_base.dart';
import 'joystick_controller.dart';
import 'joystick_stick.dart';
import 'joystick_stick_offset_calculator.dart';

/// Joystick widget
class Joystick extends StatefulWidget {
  /// Callback, which is called with [period] frequency when the stick is dragged.
  final StickDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final bool isMoveOrZoom;

  /// Widget that renders joystick base, by default [JoystickBase].
  final Widget? base;

  /// Widget that renders joystick stick, it places in the center of [base] widget, by default [JoystickStick].
  final Widget stick;

  /// Controller allows to control joystick events outside the widget.
  final JoystickController? controller;

  /// Possible directions mode of the joystick stick, by default [JoystickMode.all]
  final JoystickMode mode;

  /// Calculate offset of the stick based on the stick drag start position and the current stick position.
  final StickOffsetCalculator stickOffsetCalculator;

  /// Callback, which is called when the stick starts dragging.
  final Function? onStickDragStart;

  /// Callback, which is called when the stick released.
  final Function? onStickDragEnd;

  const Joystick({
    Key? key,
    required this.listener,
    this.isMoveOrZoom = false,
    this.period = const Duration(milliseconds: 100),
    this.base,
    this.stick = const JoystickStick(),
    this.mode = JoystickMode.all,
    this.stickOffsetCalculator = const CircleStickOffsetCalculator(),
    this.controller,
    this.onStickDragStart,
    this.onStickDragEnd,
  }) : super(key: key);

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  final GlobalKey _baseKey = GlobalKey();
  final GlobalKey _baseBall = GlobalKey();
  Offset _stickOffset = Offset.zero;
  Timer? _callbackTimer;
  double _sizeWidgetSquare = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart =
        (globalPosition) => _stickDragStart(globalPosition);
    widget.controller?.onStickDragEnd = () => _stickDragEnd();
  }

  double exitsSizeWidgetSquare() {
    if (_sizeWidgetSquare == 0) {
      final baseRenderBox =
          _baseKey.currentContext!.findRenderObject()! as RenderBox;
      _sizeWidgetSquare = baseRenderBox.size.width;
      return _sizeWidgetSquare;
    }
    return _sizeWidgetSquare;
  }

  void calculateCircle(Offset localPosition) {
    final double sizeWidgetSquare = exitsSizeWidgetSquare();
    final double radius = sizeWidgetSquare / 2;
    double x = localPosition.dx;
    double y = localPosition.dy;
    if (x != 100) {
      x = x - 40;
    }
    if (y != 100) {
      y = y - 40;
    }
    x = (x * 2) - sizeWidgetSquare;
    y = (y * 2) - sizeWidgetSquare;
    final isPointInCircle = x * x + y * y < radius * radius;
    if (!isPointInCircle) {
      final mult = sqrt(radius * radius / (y * y + x * x));
      x *= mult;
      y *= mult;
    }
    final xOffset = x / radius;
    final yOffset = y / radius;
    setState(() {
      _stickOffset = Offset(xOffset, yOffset);
    });
    _runCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.isMoveOrZoom
          ? Container(
              width: 280,
              height: 280,
              color: Color.fromARGB(0, 0, 0, 0),
            )
          : GestureDetector(
              onTapDown: (details) => _stickDragStart(details.localPosition),
              onTapUp: (details) => _stickDragEnd(),
              onPanStart: (details) => _stickDragStart(details.localPosition),
              onPanEnd: (details) => _stickDragEnd(),
              onPanUpdate: (details) => calculateCircle(details.localPosition),
              child: Container(
                width: 280,
                height: 280,
                color: Color.fromARGB(0, 0, 0, 0),
              ),
            ),
      Positioned(
        left: 40,
        top: 40,
        child: IgnorePointer(
          child: Stack(
            alignment: Alignment(_stickOffset.dx, _stickOffset.dy),
            children: [
              Container(
                  key: _baseKey,
                  child: widget.base ?? JoystickBase(mode: widget.mode)),
              Container(
                key: _baseBall,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.lightBlue.shade900,
                      Colors.lightBlue.shade400,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  void _stickDragStart(Offset localPosition) {
    calculateCircle(localPosition);
    _runCallback();
    widget.onStickDragStart?.call();
  }

  void _stickDragEnd() {
    final double sizeWidgetSquare = exitsSizeWidgetSquare() / 2;
    calculateCircle(Offset(sizeWidgetSquare, sizeWidgetSquare));
    widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
  }

  void _runCallback() {
    widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
  }

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }
}

typedef StickDragCallback = void Function(StickDragDetails details);

/// Contains the stick offset from the center of the base.
class StickDragDetails {
  /// x - the stick offset in the horizontal direction. Can be from -1.0 to +1.0.
  final double x;

  /// y - the stick offset in the vertical direction. Can be from -1.0 to +1.0.
  final double y;

  StickDragDetails(this.x, this.y);
}

/// Possible directions of the joystick stick.
enum JoystickMode {
  /// allow move the stick in any direction: vertical, horizontal and diagonal.
  all,

  /// allow move the stick only in vertical direction.
  vertical,

  /// allow move the stick only in horizontal direction.
  horizontal,

  /// allow move the stick only in horizontal and vertical directions, not diagonal.
  horizontalAndVertical,
}
