import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/balance_card.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/promo_banner.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/transaction_tile.dart';
import 'contacts_screen.dart';
import 'movements_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: Text('PD',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                  const SizedBox(width: 10),
                  const Text('Hola Paul',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: Color(0xFFF4A25C), shape: BoxShape.circle),
                    child: const Text('d!',
                        style: TextStyle(
                            color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                  ),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(color: AppColors.negative, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.headset_mic_outlined, color: AppColors.textPrimary),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: const BalanceCard(balance: 1.70),
            ),
          ),

          // Lista 1: acciones rápidas (grid)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.quickActions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final action = MockData.quickActions[index];
                  return FadeSlideIn(
                    index: index,
                    child: QuickActionButton(
                      action: action,
                      onTap: () {
                        if (action.label == 'Transferir') {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ContactsScreen()),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Lista 2: promociones (carrusel horizontal)
          _SectionHeader(
            title: 'Mis promociones',
            onSeeAll: () {},
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: MockData.promos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: FadeSlideIn(
                      index: index,
                      child: PromoBanner(promo: MockData.promos[index]),
                    ),
                  );
                },
              ),
            ),
          ),

          // Lista 3: movimientos recientes
          _SectionHeader(
            title: 'Movimientos recientes',
            onSeeAll: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MovementsScreen()),
            ),
          ),
          SliverList.builder(
            itemCount: MockData.transactions.take(6).length,
            itemBuilder: (context, index) {
              final tx = MockData.transactions[index];
              return FadeSlideIn(index: index, child: TransactionTile(transaction: tx));
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Ver más',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
