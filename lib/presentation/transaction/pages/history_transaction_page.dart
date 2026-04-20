import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/presentation/home/bloc/online_checker/online_checker_bloc.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/transaction/pages/transaction_offline_page.dart';
import 'package:pos_kita/presentation/transaction/pages/transaction_page.dart';

import '../blocs/sync_order/sync_order_bloc.dart';

class HistoryTransactionPage extends StatefulWidget {
  const HistoryTransactionPage({super.key});

  @override
  State<HistoryTransactionPage> createState() => _HistoryTransactionPageState();
}

class _HistoryTransactionPageState extends State<HistoryTransactionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _triggerInitialSync() {
    final isOnline = context.read<OnlineCheckerBloc>().state.maybeWhen(
      online: () => true,
      orElse: () => false,
    );

    if (isOnline) {
      context.read<SyncOrderBloc>().add(const SyncOrderEvent.syncAll());
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerInitialSync());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnlineCheckerBloc, OnlineCheckerState>(
          listener: (context, state) {
            state.maybeWhen(
              online: () => context.read<SyncOrderBloc>().add(
                const SyncOrderEvent.syncAll(),
              ),
              orElse: () {},
            );
          },
        ),
        BlocListener<SyncOrderBloc, SyncOrderState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sinkronisasi selesai')),
              ),
              error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColors.error),
              ),
              orElse: () {},
            );
          },
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: const DrawerWidget(),
        appBar: AppBar(
          title: const Text('Riwayat Transaksi'),
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryDark.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md - 2),
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.white,
                labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'OFFLINE'),
                  Tab(text: 'ONLINE'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            TransactionOfflinePage(),
            TransactionPage(),
          ],
        ),
        floatingActionButton: BlocBuilder<SyncOrderBloc, SyncOrderState>(
          builder: (context, state) => state.maybeWhen(
            loading: () => const _SyncIndicator(text: 'Mempersiapkan…'),
            progress: (synced, total) =>
                _SyncIndicator(text: 'Sinkron $synced / $total'),
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _SyncIndicator extends StatelessWidget {
  final String text;
  const _SyncIndicator({required this.text});

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
    heroTag: 'syncIndicator',
    onPressed: null,
    backgroundColor: AppColors.primary,
    elevation: AppShadows.md.first.blurRadius,
    label: Row(
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        AppSpacing.hGapSm,
        Text(
          text, 
          style: AppTypography.labelMedium.copyWith(color: AppColors.white),
        ),
      ],
    ),
  );
}
