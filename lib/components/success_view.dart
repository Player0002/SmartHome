import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class SuccessView extends StatefulWidget {
  final Function callback;
  SuccessView({this.callback});
  @override
  State<StatefulWidget> createState() {
    return new SuccessViewState();
  }
}

class SuccessViewState extends State<SuccessView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    int factor = 50;
    animationController = new AnimationController(vsync: this);
    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            animatable: new Tween(begin: 0.0, end: 0.70),
            from: new Duration(milliseconds: 3 * factor),
            to: new Duration(milliseconds: 10 * factor),
            tag: "start")
        .addAnimatable(
            animatable: new Tween(begin: 0.0, end: 1.0),
            from: new Duration(milliseconds: 0),
            to: new Duration(milliseconds: 10 * factor),
            tag: "end",
            curve: Curves.easeOut)
        .animate(animationController);

    new Future.delayed(new Duration(milliseconds: 500)).then((_) {
      animationController.forward().whenComplete(() {
        Future.delayed(Duration(milliseconds: 500), widget.callback);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      animation: animationController,
      builder: (c, w) {
        return new CustomPaint(
          painter: new _CustomPainter(
            strokeStart: sequenceAnimation['start'].value,
            strokeEnd: sequenceAnimation['end'].value,
          ),
        );
      },
    );
  }
}

class _CustomPainter extends CustomPainter {
  Paint _paint = new Paint();

  double _r = 32.0;
  double factor = 0.96;

  double strokeStart;
  double strokeEnd;
  double total = 0;

  double _strokeStart;
  double _strokeEnd;

  _CustomPainter({this.strokeEnd, this.strokeStart}) {
    _paint.strokeCap = StrokeCap.round;
    _paint.style = PaintingStyle.stroke;

    _paint.strokeWidth = 4.0;

    Path path = createPath();
    PathMetrics metrics = path.computeMetrics();
    for (PathMetric pathMetric in metrics) {
      total += pathMetric.length;
    }

    _strokeStart = strokeStart * total;
    _strokeEnd = strokeEnd * total;
  }
  radians(val) {
    return (math.pi / 180.0) * val;
  }

  Path createPath() {
    Path path = new Path();

    path.addArc(
      new Rect.fromCircle(center: new Offset(0, _r), radius: _r),
      radians(90.0 - 30.0),
      radians(-200.0),
    );
    path.lineTo(_r * -0.1, _r * 1.4);
    path.lineTo(_r * 0.5, _r / 2);

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    path.addArc(new Rect.fromCircle(center: new Offset(0, _r), radius: _r), 0.0,
        radians(360.0));
    _paint.color = Colors.green.withOpacity(0.6);
    canvas.drawPath(path, _paint);

    _paint.color = Colors.green.withOpacity(0.8);
    path = createPath();
    PathMetrics metrics = path.computeMetrics();
    for (PathMetric pathMetric in metrics) {
      canvas.drawPath(pathMetric.extractPath(_strokeStart, _strokeEnd), _paint);
    }
  }

  @override
  bool shouldRepaint(_CustomPainter oldDelegate) {
    return strokeStart != oldDelegate.strokeStart ||
        strokeEnd != oldDelegate.strokeEnd;
  }
}
