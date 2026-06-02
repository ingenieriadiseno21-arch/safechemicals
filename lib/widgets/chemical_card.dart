import 'package:flutter/material.dart';
import 'package:safechemicals/models/chemical_product.dart';
import 'package:safechemicals/utils/theme.dart';

class ChemicalCard extends StatelessWidget {
  final ChemicalProduct product;

  const ChemicalCard({Key? key, required this.product}) : super(key: key);

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

  IconData _getHazardIcon(String hazardLevel) {
    switch (hazardLevel) {
      case 'Crítico':
        return Icons.dangerous;
      case 'Alto':
        return Icons.warning;
      case 'Medio':
        return Icons.info;
      case 'Bajo':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and hazard level
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.commonNames.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            product.commonNames.first,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Hazard badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getHazardColor(product.hazardLevel),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getHazardIcon(product.hazardLevel),
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.hazardLevel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Manufacturer
            Text(
              'Fabricante: ${product.manufacturer}',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Hazards tags
            if (product.hazards.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: product.hazards
                    .take(3)
                    .map((hazard) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getHazardColor(product.hazardLevel).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            hazard,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getHazardColor(product.hazardLevel),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            if (product.hazards.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${product.hazards.length - 3} más',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
            const SizedBox(height: 12),
            // Arrow indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ver detalles',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
