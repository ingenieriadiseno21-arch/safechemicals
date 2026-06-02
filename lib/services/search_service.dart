import 'package:safechemicals/models/chemical_product.dart';
import 'package:safechemicals/services/database_service.dart';

class SearchService {
  final DatabaseService databaseService;

  SearchService(this.databaseService);

  Future<List<ChemicalProduct>> search(String query) async {
    if (query.isEmpty) {
      return databaseService.getAllProducts();
    }

    final results = await databaseService.searchProducts(query.toLowerCase());
    return _rankResults(results, query);
  }

  List<ChemicalProduct> _rankResults(List<ChemicalProduct> results, String query) {
    // Ordena los resultados por relevancia
    final queryLower = query.toLowerCase();
    
    results.sort((a, b) {
      // Exact name match gets highest priority
      if (a.name.toLowerCase() == queryLower) return -1;
      if (b.name.toLowerCase() == queryLower) return 1;
      
      // Name contains query
      final aContains = a.name.toLowerCase().contains(queryLower);
      final bContains = b.name.toLowerCase().contains(queryLower);
      
      if (aContains && !bContains) return -1;
      if (!aContains && bContains) return 1;
      
      // Common names
      final aCommonMatch = a.commonNames.any((name) => name.toLowerCase().contains(queryLower));
      final bCommonMatch = b.commonNames.any((name) => name.toLowerCase().contains(queryLower));
      
      if (aCommonMatch && !bCommonMatch) return -1;
      if (!aCommonMatch && bCommonMatch) return 1;
      
      return a.name.compareTo(b.name);
    });
    
    return results;
  }

  Future<List<ChemicalProduct>> filterByHazard(String hazardLevel) async {
    return databaseService.getProductsByHazardLevel(hazardLevel);
  }

  Future<List<ChemicalProduct>> filterByHazardType(String hazardType) async {
    final all = await databaseService.getAllProducts();
    return all.where((product) => product.hazards.contains(hazardType)).toList();
  }
}
