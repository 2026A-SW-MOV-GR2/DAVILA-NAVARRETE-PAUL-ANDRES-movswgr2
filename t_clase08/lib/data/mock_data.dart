import 'dart:math';

import 'package:flutter/material.dart';

import '../models/benefit_item.dart';
import '../models/business.dart';
import '../models/contact.dart';
import '../models/promo.dart';
import '../models/quick_action.dart';
import '../models/transaction.dart';
import '../models/wallet_account.dart';
import '../theme/app_colors.dart';

/// Generador de datos simulados. Se generan listas extensas (100+ items)
/// para poder evaluar la fluidez del scroll (requisito de "Eficiencia de
/// Listas" del taller) sin depender de una API real.
abstract class MockData {
  static const quickActions = [
    QuickAction(label: 'Transferir', icon: Icons.attach_money_rounded, color: Color(0xFF1FA971)),
    QuickAction(label: 'Transferir a otro banco', icon: Icons.account_balance_rounded, color: AppColors.primary),
    QuickAction(label: 'Recargar', icon: Icons.add_card_rounded, color: Color(0xFF5A2D82)),
    QuickAction(label: 'Cobrar', icon: Icons.qr_code_2_rounded, color: Color(0xFFE58A3A)),
    QuickAction(label: 'Retirar', icon: Icons.storefront_rounded, color: Color(0xFF3B82C4)),
    QuickAction(label: 'Recarga celular', icon: Icons.smartphone_rounded, color: AppColors.accent),
    QuickAction(label: 'Pagar servicios', icon: Icons.receipt_long_rounded, color: Color(0xFF6BBF59)),
    QuickAction(label: 'Metro de Quito', icon: Icons.directions_subway_rounded, color: Color(0xFF5A2D82)),
    QuickAction(label: 'Deuna Jóvenes', icon: Icons.diversity_3_rounded, color: Color(0xFFD65C9E)),
    QuickAction(label: 'Invita y Gana', icon: Icons.card_giftcard_rounded, color: Color(0xFFE0A233)),
  ];

  static const promos = [
    WalletPromo(
      title: 'Gana premios diarios',
      subtitle: 'Participa solo por usar Deuna',
      gradient: [Color(0xFFEDE7F6), Color(0xFFD9CDEF)],
      icon: Icons.emoji_events_rounded,
    ),
    WalletPromo(
      title: 'El plan sushi que sí provoca',
      subtitle: '\$15,99 antes \$21,99',
      gradient: [Color(0xFFE6F7F1), Color(0xFFC7ECDF)],
      icon: Icons.set_meal_rounded,
    ),
    WalletPromo(
      title: 'Combos y promociones',
      subtitle: 'Descuentos en tus negocios favoritos',
      gradient: [Color(0xFFFFF2E1), Color(0xFFFBDFB4)],
      icon: Icons.local_offer_rounded,
    ),
  ];

  static const benefits = [
    BenefitItem(
      icon: Icons.percent_rounded,
      title: 'Combos y promociones',
      subtitle: 'Recibe descuentos, combos y promos únicas en tus negocios favoritos.',
    ),
    BenefitItem(
      icon: Icons.support_agent_rounded,
      title: 'Soporte 24 horas',
      subtitle: 'Te ayudamos a través de nuestros canales de atención.',
    ),
    BenefitItem(
      icon: Icons.savings_rounded,
      title: 'Reembolsos de hasta el 3%',
      subtitle: 'Completa más pagos y recibe reembolsos exclusivos.',
      locked: true,
    ),
    BenefitItem(
      icon: Icons.card_giftcard_rounded,
      title: 'Regalos e invitaciones',
      subtitle: 'Continúa subiendo de nivel y participa por más premios únicos.',
      locked: true,
    ),
  ];

  static const highlightPromos = [
    WalletPromo(
      title: 'Apoya a tu equipo favorito',
      subtitle: 'Hasta \$5 en transferencia interbancaria',
      gradient: [Color(0xFFE9F0FB), Color(0xFFCBDCF3)],
      icon: Icons.sports_soccer_rounded,
    ),
    WalletPromo(
      title: 'Encuentra a tu Deuna Veci',
      subtitle: 'Participa por premios',
      gradient: [Color(0xFFE6F7F1), Color(0xFFC7ECDF)],
      icon: Icons.storefront_rounded,
    ),
  ];

  static const walletAccounts = [
    WalletAccount(
      label: 'Deuna',
      maskedNumber: '******1537',
      balance: 1.70,
      color: AppColors.primary,
      icon: Icons.bolt_rounded,
    ),
    WalletAccount(
      label: 'Cuenta de ahorros',
      maskedNumber: '******5661',
      balance: 131.67,
      color: Color(0xFFE0A233),
      icon: Icons.account_balance_wallet_rounded,
    ),
  ];

  static const businesses = [
    Business(name: 'Servientrega', dx: 0.62, dy: 0.28),
    Business(name: 'Santa María', dx: 0.16, dy: 0.62),
    Business(name: 'Deuna Veci Central', dx: 0.32, dy: 0.5),
    Business(name: 'TIA', dx: 0.42, dy: 0.78),
  ];

  static final List<WalletContact> contacts = _buildContacts();
  static final List<WalletTransaction> transactions = _buildTransactions();

  static List<WalletContact> _buildContacts() {
    const names = [
      'María José Vera', 'Carlos Andrade', 'Ana Lucía Salas',
      'Diego Ramírez', 'Fernanda Solís', 'Pablo Cevallos',
      'Gabriela Ortiz', 'Luis Chávez', 'Camila Rojas',
      'Andrés Paredes', 'Valentina Moreno', 'Jorge Salazar',
      'Nicole Guerrero', 'Iván Torres', 'Paola Jiménez',
      'Esteban Vaca', 'Mishell Peña', 'Bryan Núñez',
      'Katherine Loor', 'Christian Yépez',
    ];
    final rnd = Random(7);
    return List.generate(names.length, (i) {
      return WalletContact(
        name: names[i],
        phone: '09${_pad(rnd.nextInt(90000000) + 10000000, 8)}',
        color: AppColors.categoryPalette[i % AppColors.categoryPalette.length],
        isFavorite: i < 4,
      );
    });
  }

  static List<WalletTransaction> _buildTransactions() {
    const merchants = [
      ('Farmacias Fybeca', Icons.medical_services_rounded, TransactionType.payment),
      ('Supermaxi', Icons.local_grocery_store_rounded, TransactionType.payment),
      ('Netflix', Icons.movie_rounded, TransactionType.payment),
      ('CNEL - Luz eléctrica', Icons.bolt_rounded, TransactionType.payment),
      ('Claro recarga', Icons.phone_android_rounded, TransactionType.recharge),
      ('Movistar recarga', Icons.sim_card_rounded, TransactionType.recharge),
      ('Uber', Icons.local_taxi_rounded, TransactionType.payment),
      ('Pedidos Ya', Icons.delivery_dining_rounded, TransactionType.payment),
    ];
    final rnd = Random(42);
    final list = <WalletTransaction>[];

    for (var i = 0; i < 40; i++) {
      final contact = contacts[rnd.nextInt(contacts.length)];
      final isReceived = rnd.nextBool();
      list.add(WalletTransaction(
        id: 'p2p-$i',
        title: isReceived ? contact.name : 'Envío a ${contact.name}',
        subtitle: isReceived ? 'Te transfirió dinero' : 'Transferencia',
        amount: (rnd.nextInt(15000) + 100) / 100,
        date: DateTime.now().subtract(Duration(hours: rnd.nextInt(24 * 30))),
        type: isReceived ? TransactionType.received : TransactionType.sent,
        icon: isReceived ? Icons.south_west_rounded : Icons.north_east_rounded,
        accentColor: contact.color,
      ));
    }

    for (var i = 0; i < 60; i++) {
      final m = merchants[rnd.nextInt(merchants.length)];
      list.add(WalletTransaction(
        id: 'merch-$i',
        title: m.$1,
        subtitle: m.$3 == TransactionType.recharge ? 'Recarga' : 'Pago de servicio',
        amount: (rnd.nextInt(8000) + 150) / 100,
        date: DateTime.now().subtract(Duration(hours: rnd.nextInt(24 * 45))),
        type: m.$3,
        icon: m.$2,
        accentColor: AppColors.categoryPalette[rnd.nextInt(AppColors.categoryPalette.length)],
      ));
    }

    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static String _pad(int n, int width) => n.toString().padLeft(width, '0');
}
