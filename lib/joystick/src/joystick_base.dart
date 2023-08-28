import 'package:flutter/material.dart';

import 'joystick.dart';

class JoystickBase extends StatelessWidget {
  final JoystickMode mode;

  const JoystickBase({
    this.mode = JoystickMode.all,
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

  final JoystickMode mode;

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
    final _lineWidth = 30.0;
    final _lineHeight = 50.0;
    final _linePosition = 70.0;

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows
      final arrowUp = Path();
      arrowUp.moveTo(center.dx - _lineWidth, center.dy - _lineHeight);
      arrowUp.lineTo(center.dx, center.dy - _linePosition);
      arrowUp.lineTo(center.dx + _lineWidth, center.dy - _lineHeight);
      canvas.drawPath(arrowUp, _linePaint);
      final arrowDown = Path();
      arrowDown.moveTo(center.dx - _lineWidth, center.dy + _lineHeight);
      arrowDown.lineTo(center.dx, center.dy + _linePosition);
      arrowDown.lineTo(center.dx + _lineWidth, center.dy + _lineHeight);
      canvas.drawPath(arrowDown, _linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      final arrowLeft = Path();
      arrowLeft.moveTo(center.dx - _lineHeight, center.dy - _lineWidth);
      arrowLeft.lineTo(center.dx - _linePosition, center.dy);
      arrowLeft.lineTo(center.dx - _lineHeight, center.dy + _lineWidth);
      canvas.drawPath(arrowLeft, _linePaint);
      final arrowRight = Path();
      arrowRight.moveTo(center.dx + _lineHeight, center.dy - _lineWidth);
      arrowRight.lineTo(center.dx + _linePosition, center.dy);
      arrowRight.lineTo(center.dx + _lineHeight, center.dy + _lineWidth);
      canvas.drawPath(arrowRight, _linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JoystickSquareBase extends StatelessWidget {
  final JoystickMode mode;

  const JoystickSquareBase({
    this.mode = JoystickMode.all,
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

  final JoystickMode mode;

  final _linePaint = Paint()
    ..color = const Color(0x50616161)
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    if (mode != JoystickMode.horizontal) {
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

    if (mode != JoystickMode.vertical) {
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

    if (mode == JoystickMode.all) {
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
