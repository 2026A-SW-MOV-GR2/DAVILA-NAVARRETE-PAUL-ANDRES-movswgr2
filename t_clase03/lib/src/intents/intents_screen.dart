import 'package:flutter/material.dart';

import 'incoming_intents_tab.dart';
import 'outgoing_intents_tab.dart';

class IntentsScreen extends StatefulWidget {
  const IntentsScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<IntentsScreen> createState() => _IntentsScreenState();
}

class _IntentsScreenState extends State<IntentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T. Clase 05 — Intents'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.send_outlined), text: 'Salientes'),
            Tab(icon: Icon(Icons.inbox_outlined), text: 'Entrantes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OutgoingIntentsTab(),
          IncomingIntentsTab(),
        ],
      ),
    );
  }
}
