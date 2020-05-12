import 'package:chainmore/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PercentIndicator extends StatelessWidget {
  static List<Color> colors = [
    HexColor("#2196f3"),
    HexColor("#43c33c"),
    HexColor("#f1d34b"),
    HexColor("#ff7676"),
  ];

  final List<double> percents;

  PercentIndicator(this.percents);

  @override
  Widget build(BuildContext context) {
    List<Widget> circles = List<Widget>();

    double degree = 0;

    for (int i = 0; i < percents.length; i++) {
      degree += percents[i] * 360;

      circles.add(Padding(
        padding: const EdgeInsets.all(4.0),
        child: CustomPaint(
          painter: CurvePainter(colors: [
            colors[i],
            colors[i],
          ], angle: degree),
          child: SizedBox(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(150),
          ),
        ),
      ));
    }

    return Stack(children: circles.reversed.toList());
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

//    final shdowPaint = new Paint()
//      ..color = Colors.black.withOpacity(0.4)
//      ..strokeCap = StrokeCap.round
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 14;
//    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
//    final shdowPaintRadius =
//        math.min(size.width / 2, size.height / 2) - (14 / 2);
//    canvas.drawArc(
//        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
//        degreeToRadians(278),
//        degreeToRadians(360 - (365 - angle)),
//        false,
//        shdowPaint);
//
//    shdowPaint.color = Colors.grey.withOpacity(0.3);
//    shdowPaint.strokeWidth = 16;
//    canvas.drawArc(
//        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
//        degreeToRadians(278),
//        degreeToRadians(360 - (365 - angle)),
//        false,
//        shdowPaint);
//
//    shdowPaint.color = Colors.grey.withOpacity(0.2);
//    shdowPaint.strokeWidth = 20;
//    canvas.drawArc(
//        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
//        degreeToRadians(278),
//        degreeToRadians(360 - (365 - angle)),
//        false,
//        shdowPaint);
//
//    shdowPaint.color = Colors.grey.withOpacity(0.1);
//    shdowPaint.strokeWidth = 22;
//    canvas.drawArc(
//        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
//        degreeToRadians(278),
//        degreeToRadians(360 - (365 - angle)),
//        false,
//        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(270),
        degreeToRadians(360 - (360 - angle)),
        false,
        paint);

//    final gradient1 = new SweepGradient(
//      tileMode: TileMode.repeated,
//      colors: [Colors.white, Colors.white],
//    );

//    var cPaint = new Paint();
//    cPaint..shader = gradient1.createShader(rect);
//    cPaint..color = Colors.white;
//    cPaint..strokeWidth = 14 / 2;
    canvas.save();

//    final centerToCircle = size.width / 2;
//    canvas.save();

//    canvas.translate(centerToCircle, centerToCircle);
//    canvas.rotate(degreeToRadians(angle + 2));

//    canvas.save();
//    canvas.translate(0.0, -centerToCircle + 14 / 2);
//    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
//    canvas.restore();
//    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
