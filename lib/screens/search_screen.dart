import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safechemicals/models/chemical_product.dart';
import 'package:safechemicals/services/database_service.dart';
import 'package:safechemicals/services/search_service.dart';
import 'package:safechemicals/screens/product_detail_screen.dart';
import 'package:safechemicals/widgets/chemical_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchService _searchService;
  final TextEditingController _searchController = TextEditingController();
  List<ChemicalProduct> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchService = SearchService(context.read<DatabaseService>());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    final results = await _searchService.search(query);
    
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search input
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar producto químico...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults = [];
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty) {
                _performSearch(value);
              } else {
                setState(() {
                  _searchResults = [];
                });
              }
            },
          ),
        ),
        // Search results
        Expanded(
          child: _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No se encontraron resultados'),
                        ],
                      ),
                    )
                  : _searchController.text.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search, size: 48, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text('Ingresa un nombre para buscar'),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: _searchResults[index],
                                    ),
                                  ),
                                );
                              },
                              child: ChemicalCard(product: _searchResults[index]),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
