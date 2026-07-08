import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/transaction.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/transaction_tile.dart';

/// Historial completo de movimientos con filtro por tipo. Usa
/// [ListView.builder] para mantener el desplazamiento fluido incluso con
/// el listado extenso simulado en [MockData.transactions].
class MovementsScreen extends StatefulWidget {
  const MovementsScreen({super.key});

  @override
  State<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  TransactionType? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = MockData.transactions.where((t) {
      final matchesType = _filter == null || t.type == _filter;
      final matchesQuery =
          _query.isEmpty || t.title.toLowerCase().contains(_query.toLowerCase());
      return matchesType && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      body: Column(
        children: [
          // Mejora de UX (Fase C): buscador siempre visible en vez de un
          // ícono que exige un tap extra para desplegarlo.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Buscar movimiento (ej. Netflix, María...)',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'Todos',
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                _FilterChip(
                  label: 'Recibido',
                  selected: _filter == TransactionType.received,
                  onTap: () => setState(() => _filter = TransactionType.received),
                ),
                _FilterChip(
                  label: 'Enviado',
                  selected: _filter == TransactionType.sent,
                  onTap: () => setState(() => _filter = TransactionType.sent),
                ),
                _FilterChip(
                  label: 'Pagos',
                  selected: _filter == TransactionType.payment,
                  onTap: () => setState(() => _filter = TransactionType.payment),
                ),
                _FilterChip(
                  label: 'Recargas',
                  selected: _filter == TransactionType.recharge,
                  onTap: () => setState(() => _filter = TransactionType.recharge),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text('Sin movimientos', style: TextStyle(color: AppColors.textMuted)),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final tile = TransactionTile(transaction: items[index]);
                      return index < 12 ? FadeSlideIn(index: index, child: tile) : tile;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
