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
    "body_part": "abdomen",
    "severity": "moderate",
    "description": "Patient reports a persistent, moderate abdomen."
  },
  {
    "body_part": "right hip",
    "severity": "moderate",
    "description": "Patient reports a persistent, moderate right hip."
  },
  {
    "body_part": "right thigh",
    "severity": "moderate",
    "description": "Patient reports a persistent, moderate right thigh."
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
    "body_part": "left eye",
    "severity": "high",
    "description": "Severe irritation and redness in the left eye."
  },
  {
    "body_part": "right eye",
    "severity": "mild",
    "description": "Slight blurriness in the right eye."
  },
  {
    "body_part": "neck",
    "severity": "moderate",
    "description": "Moderate stiffness in the neck."
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
    "body_part": "left shoulder",
    "severity": "high",
    "description": "Severe pain in the left shoulder."
  },
  {
    "body_part": "right shoulder",
    "severity": "moderate",
    "description": "Aching pain in the right shoulder."
  },

  {
    "body_part": "left arm",
    "severity": "mild",
    "description": "Tingling sensation down the left arm."
  },
  {
    "body_part": "right arm",
    "severity": "high",
    "description": "Moderate muscle ache in the right arm."
  },
  {
    "body_part": "left hand",
    "severity": "high",
    "description": "Numbness in the fingers of the left hand."
  },
  {
    "body_part": "right hand",
    "severity": "high",
    "description": "Difficulty gripping with the right hand."
  },
  {
    "body_part": "left wrist",
    "severity": "high",
    "description": "Severe swelling in the left wrist."
  },
  {
    "body_part": "right wrist",
    "severity": "mild",
    "description": "A mild sprain in the right wrist."
  },
  {
    "body_part": "left leg",
    "severity": "moderate",
    "description": "Moderate throbbing pain in the left leg."
  },
  {
    "body_part": "right leg",
    "severity": "mild",
    "description": "Mild weakness felt in the right leg."
  },
  {
    "body_part": "left knee",
    "severity": "high",
    "description": "Severe, sharp pain in the left knee when bending."
  },
  {
    "body_part": "right knee",
    "severity": "moderate",
    "description": "A dull ache in the right knee."
  },
  {
    "body_part": "left foot",
    "severity": "mild",
    "description": "Soreness on the sole of the left foot."
  },
  {
    "body_part": "right foot",
    "severity": "moderate",
    "description": "Swelling around the ankle of the right foot."
  }
  
]
""";
