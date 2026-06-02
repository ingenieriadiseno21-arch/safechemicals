class SafetyMeasure {
  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final String? precaution;

  SafetyMeasure({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    this.precaution,
  });

  factory SafetyMeasure.fromJson(Map<String, dynamic> json) {
    return SafetyMeasure(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
      precaution: json['precaution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'steps': steps,
      'precaution': precaution,
    };
  }
}
