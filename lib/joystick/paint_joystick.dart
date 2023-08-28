import 'package:flutter/material.dart';

// import 'joystick.dart';
/// Possible directions of the joystick stick.
enum JoystickModePaint{
  /// allow move the stick in any direction: vertical, horizontal and diagonal.
  all,

  /// allow move the stick only in vertical direction.
  vertical,

  /// allow move the stick only in horizontal direction.
  horizontal,

  /// allow move the stick only in horizontal and vertical directions, not diagonal.
  horizontalAndVertical,
}

class PaintJoystick extends StatelessWidget {
  final JoystickModePaint mode;

  const PaintJoystick({
    this.mode = JoystickModePaint.all,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _JoystickBasePainter(mode),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  _JoystickBasePainter(this.mode);

  final JoystickModePaint mode;

  final _borderPaint = Paint()
    ..color = const Color(0x50616161)
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
  final _centerPaint = Paint()
    ..color = const Color(0x50616161)
    ..style = PaintingStyle.fill;
  final _linePaint = Paint()
    ..color = const Color(0x50616161)
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, _borderPaint);
    canvas.drawCircle(center, radius - 12, _centerPaint);
    canvas.drawCircle(center, radius - 60, _centerPaint);

    if (mode != JoystickModePaint.horizontal) {
      // draw vertical arrows
      canvas.drawLine(Offset(center.dx - 30, center.dy - 50),
          Offset(center.dx, center.dy - 70), _linePaint);
      canvas.drawLine(Offset(center.dx + 30, center.dy - 50),
          Offset(center.dx, center.dy - 70), _linePaint);
      canvas.drawLine(Offset(center.dx - 30, center.dy + 50),
          Offset(center.dx, center.dy + 70), _linePaint);
      canvas.drawLine(Offset(center.dx + 30, center.dy + 50),
          Offset(center.dx, center.dy + 70), _linePaint);
    }

    if (mode != JoystickModePaint.vertical) {
      // draw horizontal arrows
      canvas.drawLine(Offset(center.dx - 50, center.dy - 30),
          Offset(center.dx - 70, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx - 50, center.dy + 30),
          Offset(center.dx - 70, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx + 50, center.dy - 30),
          Offset(center.dx + 70, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx + 50, center.dy + 30),
          Offset(center.dx + 70, center.dy), _linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JoystickSquareBase extends StatelessWidget {
  final JoystickModePaint mode;

  const JoystickSquareBase({
    this.mode = JoystickModePaint.all,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
          // color: Colors.red,
          border: Border.all(color: const Color(0x50616161), width: 10)
          // shape: BoxShape.circle,
          ),
      // child: CustomPaint(
      //   painter: _JoystickBasePainter(mode),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 180,
          height: 180,
          // padding: const EdgeInsets.all(10),
          color: const Color(0x50616161),
          child: CustomPaint(
            painter: _JoystickSquareBasePainter(mode),
          ),
        ),
      ),
    );
  }
}

class _JoystickSquareBasePainter extends CustomPainter {
  _JoystickSquareBasePainter(this.mode);

  final _lineWidth = 20.0;
  final _lineHeight = 40.0;
  final _linePosition = 30.0;

  final JoystickModePaint mode;

  final _linePaint = Paint()
    ..color = const Color(0x50616161)
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (mode != JoystickModePaint.horizontal) {
      // draw vertical arrows
      canvas.drawLine(
          Offset(center.dx - _lineWidth, center.dy - _linePosition),
          Offset(center.dx, center.dy - _linePosition - _lineHeight),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _lineWidth, center.dy - _linePosition),
          Offset(center.dx, center.dy - _linePosition - _lineHeight),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx - _lineWidth, center.dy + _linePosition),
          Offset(center.dx, center.dy + _linePosition + _lineHeight),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _lineWidth, center.dy + _linePosition),
          Offset(center.dx, center.dy + _linePosition + _lineHeight),
          _linePaint);
    }

    if (mode != JoystickModePaint.vertical) {
      // draw horizontal arrows
      canvas.drawLine(
          Offset(center.dx - _linePosition, center.dy - _lineWidth),
          Offset(center.dx - _linePosition - _lineHeight, center.dy),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx - _linePosition, center.dy + _lineWidth),
          Offset(center.dx - _linePosition - _lineHeight, center.dy),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _linePosition, center.dy - _lineWidth),
          Offset(center.dx + _linePosition + _lineHeight, center.dy),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _linePosition, center.dy + _lineWidth),
          Offset(center.dx + _linePosition + _lineHeight, center.dy),
          _linePaint);
    }

    if (mode == JoystickModePaint.all) {
      canvas.drawLine(
          Offset(center.dx + _lineWidth, center.dy - _linePosition),
          Offset(center.dx + _lineWidth + 15, center.dy - _linePosition - 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _linePosition, center.dy - _lineWidth),
          Offset(center.dx + _lineWidth + 15, center.dy - _linePosition - 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _lineWidth, center.dy + _linePosition),
          Offset(center.dx + _lineWidth + 15, center.dy + _linePosition + 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx + _linePosition, center.dy + _lineWidth),
          Offset(center.dx + _lineWidth + 15, center.dy + _linePosition + 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx - _lineWidth, center.dy - _linePosition),
          Offset(center.dx - _lineWidth - 15, center.dy - _linePosition - 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx - _linePosition, center.dy - _lineWidth),
          Offset(center.dx - _lineWidth - 15, center.dy - _linePosition - 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx - _lineWidth, center.dy + _linePosition),
          Offset(center.dx - _lineWidth - 15, center.dy + _linePosition + 5),
          _linePaint);
      canvas.drawLine(
          Offset(center.dx - _linePosition, center.dy + _lineWidth),
          Offset(center.dx - _lineWidth - 15, center.dy + _linePosition + 5),
          _linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
