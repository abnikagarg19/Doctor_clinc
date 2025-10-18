class PatientGridItem {
  final String name;
  final String symptom;
  final int messageCount; // <-- ADDED
  final String progressLevel;
  final String condition;

  PatientGridItem(
      {required this.name,
      required this.symptom,
      this.messageCount = 0, // Default to 0
      this.progressLevel = 'stable',
      required this.condition});
}
