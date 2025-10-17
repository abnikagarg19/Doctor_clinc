import 'dart:ui' as ui;

import 'package:chatbot/view/videocall/components/symptoms_modal.dart';
import 'package:flutter/material.dart';

class SymptomBodyMap extends StatelessWidget {
  final List<SymptomsModal> modal;
  final ui.Image bodyImage;

  const SymptomBodyMap(this.modal, this.bodyImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: bodyImage.width.toDouble(),
        height: bodyImage.height.toDouble(),
        child: Stack(children: [
          Image.asset(
            'assets/images/fullBody.png',
            fit: BoxFit.contain,
          ),
          // The symptom markers
          CustomPaint(
            size: Size.infinite,
            painter: SymptomPainter(symptoms: modal),
          ),
        ]),
      ),
    );
  }
}

class SymptomPainter extends CustomPainter {
  final List<SymptomsModal> symptoms;

  const SymptomPainter({required this.symptoms});

  @override
  void paint(Canvas canvas, Size size) {
    for (var symptom in symptoms) {
      final paint = Paint()
        ..color = _getColorForSeverity(symptom.painSeverity)
        ..style = PaintingStyle.fill;
      final absoluteX = symptom.relativePosition.dx * size.width;
      final absoluteY = symptom.relativePosition.dy * size.height;

      final absolutePosition = Offset(absoluteX, absoluteY);

      canvas.drawCircle(absolutePosition, 15.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Color _getColorForSeverity(PainSeverity severity) {
    switch (severity) {
      case PainSeverity.mild:
        return Colors.green.withValues(alpha: 0.7);
      case PainSeverity.moderate:
        return Colors.yellow.withValues(alpha: 0.7);
      case PainSeverity.high:
        return Colors.red.withValues(alpha: 0.7);
    }
  }
}
