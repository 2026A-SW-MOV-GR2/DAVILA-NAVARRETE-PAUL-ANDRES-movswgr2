import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/promo.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/promo_banner.dart';

class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beneficios'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Club Deuna'),
            Tab(text: 'Promociones'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ClubDeunaTab(),
          _PromotionsTab(),
        ],
      ),
    );
  }
}

class _ClubDeunaTab extends StatelessWidget {
  const _ClubDeunaTab();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: MockData.benefits.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 20, endIndent: 20),
      itemBuilder: (context, index) {
        final item = MockData.benefits[index];
        return FadeSlideIn(
          index: index,
          child: ListTile(
            leading: Icon(item.icon, color: AppColors.primary),
            title: Text(item.title,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14.5)),
            subtitle: Text(item.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
            trailing: Icon(
              item.locked ? Icons.lock_outline_rounded : Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
          ),
        );
      },
    );
  }
}

class _PromotionsTab extends StatelessWidget {
  const _PromotionsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        SizedBox(
          height: 150,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            scrollDirection: Axis.horizontal,
            itemCount: MockData.promos.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FadeSlideIn(index: index, child: PromoBanner(promo: MockData.promos[index])),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
          child: Text('Destacadas del mes',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: MockData.highlightPromos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final WalletPromo promo = MockData.highlightPromos[index];
            return FadeSlideIn(index: index, child: PromoBanner(promo: promo));
          },
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: Text('Códigos promocionales',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Aún no tienes códigos disponibles.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        ),
      ],
    );
  }
}
