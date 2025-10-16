// Make sure this is inside your State class, e.g., _OfflineConsultationState

// VARIABLE #1: The Coordinate Dictionary
// This map translates a body part name into a visual coordinate.
import 'dart:ui';

final Map<String, Offset> bodyPartCoordinates = {
  /// Head and Neck
  'head': Offset(0.5, 0.10),
  'forehead': Offset(0.5, 0.09),
  'left eye': Offset(0.45, 0.13),
  'right eye': Offset(0.55, 0.13),
  'neck': Offset(0.5, 0.2),

  /// Torso
  'chest': Offset(0.55, 0.26),
  'abdomen': Offset(0.5, 0.35),
  'stomach': Offset(0.5, 0.45), // Synonym for abdomen
  'left shoulder': Offset(0.36, 0.23),
  'right shoulder': Offset(0.64, 0.23),
  'upper back': Offset(0.5, 0.3), // Approximate
  'lower back': Offset(0.5, 0.5), // Approximate

  /// Arms and Hands
  'left arm': Offset(0.30, 0.4),
  'right arm': Offset(0.70, 0.4),
  'left hand': Offset(0.25, 0.54),
  'right hand': Offset(0.75, 0.54),
  'left wrist': Offset(0.27, 0.49),
  'right wrist': Offset(0.73, 0.49),

  /// Legs and Feet
  'left leg': Offset(0.42, 0.80),
  'right leg': Offset(0.58, 0.80),
  'left knee': Offset(0.42, 0.7),
  'right knee': Offset(0.58, 0.7),
  'left foot': Offset(0.4, 0.93),
  'right foot': Offset(0.6, 0.93),

  /// Hip
  'left hip': Offset(0.4, 0.50),
  'right hip': Offset(0.6, 0.50),

  ///thigh
  'left thigh': Offset(0.4, 0.60),
  'right thigh': Offset(0.6, 0.60),
};

// VARIABLE #2: The Mock API Data
// This is a separate string that simulates the data from your WebSocket.
final String mockSymptomJsonPayload = """
[
  {
    "body_part": "left hip",
    "severity": "moderate",
    "description": "Patient reports a persistent, moderate left hip."
  },
  {
    "body_part": "left thigh",
    "severity": "moderate",
    "description": "Patient reports a persistent, moderate left thigh."
  },
  {
    "body_part": "head",
    "severity": "moderate",
    "description": "Patient reports a persistent, moderate headache."
  },
  {
    "body_part": "chest",
    "severity": "high",
    "description": "Patient reports high pressure in the chest area."
  },
  {
    "body_part": "stomach",
    "severity": "moderate",
    "description": "Moderate cramping sensation in the stomach."
  },
  {
    "body_part": "left wrist",
    "severity": "high",
    "description": "Severe swelling in the left wrist."
  }
]
""";

// You can place this in your state or controller
final List<Map<String, dynamic>> medicines = [
  {
    "name": "Paracetamol",
    "dosage": "500mg",
    "frequency": "1-1-1",
    "duration": "5 days",
    "side_effects": ["Nausea", "Headache", "Vomiting", "Allergy"],
  },
  {
    "name": "Amoxicillin",
    "dosage": "250mg",
    "frequency": "1-0-1",
    "duration": "7 days",
    "side_effects": ["Diarrhea", "Rash"],
  },
  {
    "name": "Ibuprofen",
    "dosage": "200mg",
    "frequency": "As needed",
    "duration": "3 days",
    "side_effects": ["Stomach pain", "Heartburn"],
  },
];
