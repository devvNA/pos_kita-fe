import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/design_system/design_system.dart';
import 'package:pos_kita/core/extensions/int_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/core/utils/helper_pdf_service.dart';
import 'package:pos_kita/core/utils/permission.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/responses/sales_report_response_model.dart';
import 'package:pos_kita/presentation/home/widgets/drawer_widget.dart';
import 'package:pos_kita/presentation/sales_report/bloc/sales_report/sales_report_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/sales_invoice_widget.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime selectedDate = DateTime.now();
  SalesReportResponseModel? salesReport;

  @override
  void initState() {
    final now = DateFormat('yyyy-MM-dd').format(selectedDate);
    context.read<SalesReportBloc>().add(SalesReportEvent.getSalesReport(now));
    PermessionHelper().checkPermissionStorege();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text(
          'Laporan Penjualan',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: AppColors.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2010),
                lastDate: DateTime.now(),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    selectedDate = value;
                  });
                  final date = DateFormat('yyyy-MM-dd').format(value);
                  context.read<SalesReportBloc>().add(
                    SalesReportEvent.getSalesReport(date),
                  );
                }
              });
            },
            icon: const Icon(Icons.calendar_month, color: AppColors.onPrimary),
          ),
        ],
      ),
      body: Padding(
        padding: AppSpacing.allMd,
        child: Column(
          children: [
            // Summary Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadows.sm,
              ),
              child: Padding(
                padding: AppSpacing.allMd,
                child: Column(
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Column(
                          children: [
                            Text(
                              'Ringkasan Penjualan',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AppSpacing.vGapXxs,
                            Text(
                              DateFormat('dd MMMM yyyy').format(selectedDate),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                          child: GestureDetector(
                            onTap: () async {
                              final outlet =
                                  await AuthLocalDatasource().getOutletData();
                              if (salesReport != null) {
                                final date = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(selectedDate);
                                final status = await PermessionHelper()
                                    .checkPermissionStorege();
                                if (status.isGranted) {
                                  final pdfFile =
                                      await SalesInvoiceWidget.generate(
                                        date,
                                        salesReport!,
                                        outlet,
                                      );
                                  HelperPdfService.openFile(pdfFile);
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary50,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                              child: const Icon(
                                Icons.download,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.vGapSm,
                    const Divider(color: AppColors.divider),
                    AppSpacing.vGapSm,

                    // Indicators
                    BlocBuilder<SalesReportBloc, SalesReportState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loaded: (data) {
                            salesReport = data;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _salesIndicator(
                                      'Struk',
                                      data.totalRecipts.toString(),
                                      AppColors.primary,
                                    ),
                                    _salesIndicator(
                                      'Penjualan Bersih',
                                      data.totalSales.currencyFormatRpV2,
                                      AppColors.success500,
                                    ),
                                    _salesIndicator(
                                      'Rata-rata',
                                      data.averageSales.currencyFormatRpV2,
                                      AppColors.info500,
                                    ),
                                  ],
                                ),
                                AppSpacing.vGapMd,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _salesIndicator(
                                      'Total Penjualan',
                                      data.totalPrice.currencyFormatRpV2,
                                      AppColors.info500,
                                    ),
                                    _salesIndicator(
                                      'Total Biaya',
                                      data.totalCost.currencyFormatRpV2,
                                      AppColors.warning500,
                                    ),
                                    _salesIndicator(
                                      'Keuntungan',
                                      data.totalProfit.currencyFormatRpV2,
                                      AppColors.success500,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          loading: () {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                          orElse: () {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _salesIndicator(
                                  'Struk',
                                  '0',
                                  AppColors.primary,
                                ),
                                _salesIndicator(
                                  'Penjualan Bersih',
                                  'Rp0',
                                  AppColors.success500,
                                ),
                                _salesIndicator(
                                  'Rata-rata',
                                  'Rp0',
                                  AppColors.info500,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.vGapMd,

            // Transaction list
            Expanded(
              child: BlocBuilder<SalesReportBloc, SalesReportState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loaded: (data) {
                      if (data.sales.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 56,
                                color: AppColors.neutral400,
                              ),
                              AppSpacing.vGapSm,
                              Text(
                                'Belum ada transaksi',
                                style: AppTypography.bodyLarge.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: data.sales.length,
                        separatorBuilder: (_, _) => AppSpacing.vGapXs,
                        itemBuilder: (context, index) {
                          final item = data.sales[index];
                          return Container(
                            padding: AppSpacing.allMd,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppRadius.lg,
                              ),
                              boxShadow: AppShadows.sm,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary50,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                AppSpacing.hGapMd,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.orderNumber}',
                                        style:
                                            AppTypography.titleSmall.copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      AppSpacing.vGapXxs,
                                      Text(
                                        'Total Penjualan',
                                        style:
                                            AppTypography.bodySmall.copyWith(
                                              color: AppColors.textTertiary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.totalPrice!.currencyFormatRpV3,
                                  style: AppTypography.priceSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    },
                    orElse: () {
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _salesIndicator(String title, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 40,
            lineWidth: 5.0,
            percent: 0.0,
            center: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  value,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
            progressColor: color,
            backgroundColor: color.withValues(alpha: 0.15),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          AppSpacing.vGapXs,
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget salesChart() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: AppSpacing.allMd,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'Rp${value.toInt()}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}:00',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: [FlSpot(0, 0), FlSpot(10, 0), FlSpot(20, 0)],
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
