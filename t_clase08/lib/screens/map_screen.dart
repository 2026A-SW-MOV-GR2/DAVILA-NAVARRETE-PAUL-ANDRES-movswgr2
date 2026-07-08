import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/fake_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final businesses = MockData.businesses
        .where((b) => b.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Directorio de negocios')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Buscar un Deuna Veci',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                suffixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FakeMap(businesses: businesses),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final b = businesses[index];
                return FadeSlideIn(
                  index: index,
                  child: ListTile(
                    leading: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                    title: Text(b.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Deuna Veci', style: TextStyle(color: AppColors.textMuted)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
