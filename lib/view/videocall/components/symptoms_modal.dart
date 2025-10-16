import 'dart:ui';

// in symptoms_modal.dart
enum PainSeverity { mild, moderate, high }

class SymptomsModal {
  final Offset relativePosition;
  final PainSeverity painSeverity;
  final String description;

  SymptomsModal({
    required this.relativePosition,
    required this.painSeverity,
    required this.description,
  });
}
