class ChemicalProduct {
  final String id;
  final String name;
  final List<String> commonNames;
  final String manufacturer;
  final String chemicalFormula;
  final String hazardLevel; // Crítico, Alto, Medio, Bajo
  final List<String> hazards;
  final List<String> safetyMeasures;
  final List<String> firstAidMeasures;
  final String storageRequirements;
  final String spillRemediation;
  final String physicalState; // Líquido, Gas, Sólido
  final String color;
  final String odor;
  final DateTime createdAt;

  ChemicalProduct({
    required this.id,
    required this.name,
    required this.commonNames,
    required this.manufacturer,
    required this.chemicalFormula,
    required this.hazardLevel,
    required this.hazards,
    required this.safetyMeasures,
    required this.firstAidMeasures,
    required this.storageRequirements,
    required this.spillRemediation,
    required this.physicalState,
    required this.color,
    required this.odor,
    required this.createdAt,
  });

  factory ChemicalProduct.fromJson(Map<String, dynamic> json) {
    return ChemicalProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      commonNames: List<String>.from(json['commonNames'] ?? []),
      manufacturer: json['manufacturer'] ?? '',
      chemicalFormula: json['chemicalFormula'] ?? '',
      hazardLevel: json['hazardLevel'] ?? 'Bajo',
      hazards: List<String>.from(json['hazards'] ?? []),
      safetyMeasures: List<String>.from(json['safetyMeasures'] ?? []),
      firstAidMeasures: List<String>.from(json['firstAidMeasures'] ?? []),
      storageRequirements: json['storageRequirements'] ?? '',
      spillRemediation: json['spillRemediation'] ?? '',
      physicalState: json['physicalState'] ?? '',
      color: json['color'] ?? '',
      odor: json['odor'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'commonNames': commonNames,
      'manufacturer': manufacturer,
      'chemicalFormula': chemicalFormula,
      'hazardLevel': hazardLevel,
      'hazards': hazards,
      'safetyMeasures': safetyMeasures,
      'firstAidMeasures': firstAidMeasures,
      'storageRequirements': storageRequirements,
      'spillRemediation': spillRemediation,
      'physicalState': physicalState,
      'color': color,
      'odor': odor,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory ChemicalProduct.fromMap(Map<String, dynamic> map) {
    return ChemicalProduct.fromJson(map);
  }
}
