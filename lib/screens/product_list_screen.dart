import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safechemicals/models/chemical_product.dart';
import 'package:safechemicals/services/database_service.dart';
import 'package:safechemicals/screens/product_detail_screen.dart';
import 'package:safechemicals/widgets/chemical_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ChemicalProduct>> _productsFuture;
  String _selectedHazardFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final dbService = context.read<DatabaseService>();
    _productsFuture = dbService.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos', 'Todos'),
                const SizedBox(width: 8),
                _buildFilterChip('Crítico', 'Crítico'),
                const SizedBox(width: 8),
                _buildFilterChip('Alto', 'Alto'),
                const SizedBox(width: 8),
                _buildFilterChip('Medio', 'Medio'),
                const SizedBox(width: 8),
                _buildFilterChip('Bajo', 'Bajo'),
              ],
            ),
          ),
        ),
        // Products list
        Expanded(
          child: FutureBuilder<List<ChemicalProduct>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                );
              }

              List<ChemicalProduct> products = snapshot.data ?? [];
              
              // Apply filter
              if (_selectedHazardFilter != 'Todos') {
                products = products
                    .where((p) => p.hazardLevel == _selectedHazardFilter)
                    .toList();
              }

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No hay productos disponibles'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: products[index],
                          ),
                        ),
                      );
                    },
                    child: ChemicalCard(product: products[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedHazardFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedHazardFilter = value;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
