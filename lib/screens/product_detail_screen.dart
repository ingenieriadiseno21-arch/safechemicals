import 'package:flutter/material.dart';
import 'package:safechemicals/models/chemical_product.dart';
import 'package:safechemicals/utils/theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final ChemicalProduct product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  Color _getHazardColor(String hazardLevel) {
    switch (hazardLevel) {
      case 'Crítico':
        return dangerColor;
      case 'Alto':
        return warningColor;
      case 'Medio':
        return const Color(0xFFFF9800);
      case 'Bajo':
        return successColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hazard Level Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getHazardColor(product.hazardLevel),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'NIVEL DE PELIGRO',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.hazardLevel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Basic Information
            _buildSection(context, 'Información Básica', [
              _buildInfoRow('Nombre Químico:', product.name),
              if (product.commonNames.isNotEmpty)
                _buildInfoRow('Nombres Comunes:', product.commonNames.join(', ')),
              _buildInfoRow('Fabricante:', product.manufacturer),
              _buildInfoRow('Fórmula:', product.chemicalFormula),
              if (product.physicalState != null)
                _buildInfoRow('Estado Físico:', product.physicalState!),
              if (product.color != null) _buildInfoRow('Color:', product.color!),
              if (product.odor != null) _buildInfoRow('Olor:', product.odor!),
            ]),
            const SizedBox(height: 16),
            // Hazards
            if (product.hazards.isNotEmpty)
              _buildSection(context, 'Peligros', [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: product.hazards
                      .map((hazard) => Chip(
                            label: Text(hazard),
                            backgroundColor: _getHazardColor(product.hazardLevel),
                            labelStyle: const TextStyle(color: Colors.white),
                          ))
                      .toList(),
                ),
              ]),
            const SizedBox(height: 16),
            // Safety Measures
            if (product.safetyMeasures.isNotEmpty)
              _buildSection(context, 'Medidas de Seguridad', [
                Column(
                  children: product.safetyMeasures
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(entry.value),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ]),
            const SizedBox(height: 16),
            // First Aid
            if (product.firstAidMeasures.isNotEmpty)
              _buildSection(context, 'Primeros Auxilios', [
                Column(
                  children: product.firstAidMeasures
                      .asMap()
                      .entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: dangerColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(entry.value),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ]),
            const SizedBox(height: 16),
            // Storage
            _buildSection(context, 'Almacenamiento', [
              _buildInfoRow('Requisitos:', product.storageRequirements),
            ]),
            const SizedBox(height: 16),
            // Spill Remediation
            _buildSection(context, 'Procedimiento en caso de Derrame', [
              _buildInfoRow('Instrucciones:', product.spillRemediation),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
