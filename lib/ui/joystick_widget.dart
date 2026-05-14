import 'package:flutter/material.dart';

class JoystickWidget extends StatefulWidget {
  final double size;
  final Color color;
  final Color knobColor;
  final ValueChanged<Offset> onDirectionChanged;
  final VoidCallback onDirectionEnd;

  const JoystickWidget({
    super.key,
    this.size = 120,
    this.color = const Color(0x4D2196F3),
    this.knobColor = const Color(0xFF64B5F6),
    required this.onDirectionChanged,
    required this.onDirectionEnd,
  });

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  Offset _knobPosition = Offset.zero;
  bool _isDragging = false;

  double get _radius => widget.size / 2;
  double get _knobRadius => widget.size * 0.2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: _JoystickPainter(
            baseColor: widget.color,
            knobColor: widget.knobColor,
            knobPosition: _knobPosition,
            radius: _radius,
            knobRadius: _knobRadius,
            isDragging: _isDragging,
          ),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _updateKnobPosition(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateKnobPosition(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _knobPosition = Offset.zero;
    });
    widget.onDirectionEnd();
  }

  void _updateKnobPosition(Offset localPosition) {
    final center = Offset(_radius, _radius);
    var delta = localPosition - center;
    final distance = delta.distance;
    final maxDistance = _radius - _knobRadius;

    if (distance > maxDistance) {
      delta = delta / distance * maxDistance;
    }

    setState(() {
      _knobPosition = delta;
    });

    // Normalize direction (-1 to 1)
    final normalizedDirection = Offset(
      delta.dx / maxDistance,
      delta.dy / maxDistance,
    );
    widget.onDirectionChanged(normalizedDirection);
  }
}

class _JoystickPainter extends CustomPainter {
  final Color baseColor;
  final Color knobColor;
  final Offset knobPosition;
  final double radius;
  final double knobRadius;
  final bool isDragging;

  _JoystickPainter({
    required this.baseColor,
    required this.knobColor,
    required this.knobPosition,
    required this.radius,
    required this.knobRadius,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);

    // Base circle
    final basePaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, basePaint);

    // Base border
    final borderPaint = Paint()
      ..color = knobColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    // Knob
    final knobCenter = center + knobPosition;
    final knobPaint = Paint()
      ..color = isDragging ? knobColor : knobColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(knobCenter, knobRadius, knobPaint);
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) {
    return oldDelegate.knobPosition != knobPosition ||
        oldDelegate.isDragging != isDragging;
  }
}
