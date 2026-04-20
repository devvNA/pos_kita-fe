import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_kita/core/extensions/int_ext.dart';
import 'package:pos_kita/core/extensions/string_ext.dart';
import 'package:pos_kita/core/utils/business_setting_mapper.dart';
import 'package:pos_kita/data/models/requests/business_setting_request_model.dart';
import 'package:pos_kita/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:pos_kita/presentation/home/pages/payment_page.dart';
import 'package:pos_kita/presentation/tax_discount/bloc/business_setting/business_setting_bloc.dart';

import '../../../core/components/spaces.dart';
import '../../../core/design_system/design_system.dart';
import '../../tax_discount/bloc/business_setting_local/business_setting_local_bloc.dart';
import '../bloc/online_checker/online_checker_bloc.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  BusinessSettingRequestModel? _selectedDiscount;

  void _toggleDiscount(
    BusinessSettingRequestModel? disc,
    List<BusinessSettingRequestModel> taxs,
  ) {
    setState(() => _selectedDiscount = disc);
    if (disc != null) {
      context.read<CheckoutBloc>().add(
        CheckoutEvent.addDiscount(discount: disc),
      );
    } else {
      context.read<CheckoutBloc>().add(
        CheckoutEvent.removeDiscount(discount: _selectedDiscount!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          const SpaceHeight(16),
          Expanded(child: _buildOrderList()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDiscountSection(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSummarySection(),
          ),
          _buildPayButton(context),
        ],
      ),
    );
  }

  /* ────────────────────── APP BAR ───────────────────── */

  AppBar _appBar(BuildContext ctx) => AppBar(
    title: const Text(
      'Detail Pesanan',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ),
  );

  /* ───────────── ORDER LIST (produk di cart) ─────────── */

  Widget _buildOrderList() {
    return _withBusinessSetting(
      builder: (taxs) {
        return BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (_, state) => state.maybeWhen(
            success: (orders, _, _, _, _, x) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SpaceHeight(16),
              itemBuilder: (_, i) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      '${orders[i].quantity} x ${orders[i].product.name}',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SpaceWidth(8),
                  Text(
                    (orders[i].product.price!.toDouble * orders[i].quantity)
                        .currencyFormatRp,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SpaceWidth(8),
                  InkWell(
                    onTap: () {
                      context.read<CheckoutBloc>().add(
                        CheckoutEvent.removeFromCart(
                          product: orders[i].product,
                          businessSetting: taxs,
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.delete,
                      color: AppColors.error500,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            orElse: () => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  /* ──────────── DISCOUNT (checkbox list) ───────────── */

  Widget _buildDiscountSection() {
    return _withBusinessSetting(
      builder: (taxs) {
        final discounts = taxs
            .where((e) => e.chargeType == 'discount')
            .toList();

        if (discounts.isEmpty) return const SizedBox();

        return Wrap(
          children: discounts
              .map(
                (e) => CheckboxListTile(
                  title: Text(e.name),
                  value: _selectedDiscount == e,
                  onChanged: (v) => _toggleDiscount(v! ? e : null, taxs),
                ),
              )
              .toList(),
        );
      },
    );
  }

  /* ──────────────── SUMMARY (subtotal, tax, dst.) ───────────── */

  Widget _buildSummarySection() {
    return _withBusinessSetting(
      builder: (taxs) {
        final taxList = taxs.where((e) => e.chargeType == 'tax').toList();

        return BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (_, st) => st.maybeWhen(
            success: (_, discount, __, subtotal, totalPayment, qty) => Column(
              children: [
                const Divider(thickness: 1),
                _line('Jumlah Item', qty.toString()),
                const SpaceHeight(8),
                _line('Subtotal', subtotal.currencyFormatRp),
                ...taxList.map(
                  (t) => _line(
                    t.name,
                    (subtotal * (t.value.toIntegerFromText / 100).toDouble())
                        .currencyFormatRp,
                  ),
                ),
                const SpaceHeight(8),
                _line('Diskon', discount.currencyFormatRp),
                const SpaceHeight(8),
                _line('Total', totalPayment.currencyFormatRp, bold: true),
              ],
            ),
            orElse: () => const SizedBox(),
          ),
        );
      },
    );
  }

  Widget _line(String label, String value, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: bold ? 18 : 16,
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
          color: AppColors.black,
        ),
      ),
    ],
  );

  /* ───────────────────── BUTTON BAYAR ─────────────────── */

  Widget _buildPayButton(BuildContext ctx) => Container(
    height: 120,
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    alignment: Alignment.center,
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const PaymentPage()),
          );
        },
        child: const Text(
          'Bayar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );

  /* ──────────── HELPER: pilih BusinessSetting online/offline ───────── */

  Widget _withBusinessSetting({
    required Widget Function(List<BusinessSettingRequestModel>) builder,
  }) {
    return BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
      builder: (context, conn) {
        final bool isOnline = conn.maybeWhen(
          online: () => true,
          orElse: () => false,
        );

        return isOnline
            ? BlocBuilder<BusinessSettingBloc, BusinessSettingState>(
                builder: (_, bs) => builder(_extractTaxDiscount(bs)),
              )
            : BlocBuilder<BusinessSettingLocalBloc, BusinessSettingLocalState>(
                builder: (_, bs) => builder(_extractLocalTaxDiscount(bs)),
              );
      },
    );
  }

  List<BusinessSettingRequestModel> _extractTaxDiscount(
    BusinessSettingState bs,
  ) {
    return bs.maybeWhen(
      loaded: (data) => data,
      orElse: () => <BusinessSettingRequestModel>[],
    );
  }

  List<BusinessSettingRequestModel> _extractLocalTaxDiscount(
    BusinessSettingLocalState bs,
  ) {
    return bs.maybeWhen(
      loaded: (data) => data.map((e) => e.toRequestModel()).toList(),
      orElse: () => <BusinessSettingRequestModel>[],
    );
  }
}

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({
//     super.key,
//   });

//   @override
//   State<CheckoutPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<CheckoutPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   // bool isDiscount = false;
//   BusinessSettingRequestModel? discount;
//   void _onDiscount(discount) {
//     setState(() {
//       // isDiscount = !isDiscount;
//       this.discount = discount;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Detail Pesanan',
//           style: TextStyle(
//             color: AppColors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           const SpaceHeight(16.0),
//           Expanded(
//             child: BlocBuilder<BusinessSettingBloc, BusinessSettingState>(
//               builder: (context, state) {
//                 List<BusinessSettingRequestModel> taxs = state.maybeWhen(
//                   orElse: () => [],
//                   loaded: (data) => data
//                       .where((element) => element.chargeType == 'tax')
//                       .toList(),
//                 );
//                 return BlocBuilder<CheckoutBloc, CheckoutState>(
//                   builder: (context, state) {
//                     return state.maybeWhen(orElse: () {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }, success:
//                         (orders, total, tax, subtotal, totalPayment, qty) {
//                       return ListView.separated(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         shrinkWrap: true,
//                         itemCount: orders.length,
//                         itemBuilder: (context, index) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 flex: 4,
//                                 child: Text(
//                                   '${orders[index].quantity} x ${orders[index].product.name}',
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   maxLines: 2,
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 (orders[index].product.price!.toDouble *
//                                         orders[index].quantity)
//                                     .currencyFormatRp,
//                                 style: TextStyle(
//                                   color: AppColors.black,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               InkWell(
//                                 onTap: () {
//                                   context.read<CheckoutBloc>().add(
//                                         CheckoutEvent.removeFromCart(
//                                           product: orders[index].product,
//                                           businessSetting: taxs,
//                                         ),
//                                       );
//                                 },
//                                 child: Icon(
//                                   Icons.delete,
//                                   color: AppColors.red,
//                                   size: 18,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                         separatorBuilder: (context, index) {
//                           return const SpaceHeight(16.0);
//                         },
//                       );
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: BlocBuilder<BusinessSettingBloc, BusinessSettingState>(
//               builder: (context, state) {
//                 return state.maybeWhen(orElse: () {
//                   return SizedBox();
//                 }, loaded: (data) {
//                   List<BusinessSettingRequestModel> taxs = data
//                       .where((element) => element.chargeType == 'discount')
//                       .toList();

//                   return Wrap(
//                     children: [
//                       ...taxs.map((e) {
//                         return CheckboxListTile(
//                           title: Text(e.name),
//                           value: discount == e,
//                           onChanged: (value) {
//                             _onDiscount(value! ? e : null);
//                             value
//                                 ? context.read<CheckoutBloc>().add(
//                                       CheckoutEvent.addDiscount(
//                                         discount: e,
//                                       ),
//                                     )
//                                 : context.read<CheckoutBloc>().add(
//                                       CheckoutEvent.removeDiscount(
//                                         discount: e,
//                                       ),
//                                     );
//                           },
//                         );
//                       }),
//                     ],
//                   );
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: BlocBuilder<BusinessSettingBloc, BusinessSettingState>(
//               builder: (context, state) {
//                 List<BusinessSettingRequestModel> taxs = state.maybeWhen(
//                   orElse: () => [],
//                   loaded: (data) => data
//                       .where((element) => element.chargeType == 'tax')
//                       .toList(),
//                 );
//                 return BlocBuilder<CheckoutBloc, CheckoutState>(
//                   builder: (context, state) {
//                     return state.maybeWhen(
//                       orElse: () => Container(),
//                       success:
//                           (orders, discount, tax, subtotal, totalPayment, qty) {
//                         return Column(
//                           children: [
//                             Divider(
//                               color: AppColors.grey,
//                               thickness: 1,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Jumlah Item',
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Text(
//                                   qty.toString(),
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SpaceHeight(8.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Subtotal',
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Text(
//                                   subtotal.currencyFormatRp,
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             ...taxs.map((e) => Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       e.name,
//                                       style: const TextStyle(
//                                         color: AppColors.black,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                     Text(
//                                       (subtotal *
//                                               (e.value.toIntegerFromText / 100)
//                                                   .toDouble())
//                                           .currencyFormatRp,
//                                       style: const TextStyle(
//                                         color: AppColors.black,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                   ],
//                                 )),
//                             const SpaceHeight(8.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Diskon',
//                                   style: const TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 Text(
//                                   discount.currencyFormatRp,
//                                   style: const TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SpaceHeight(8.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Total',
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   totalPayment.currencyFormatRp,
//                                   style: TextStyle(
//                                     color: AppColors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Container(
//             height: 120,
//             width: double.infinity,
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return PaymentPage();
//                           }));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: Text(
//                           'Bayar',
//                           style: TextStyle(
//                             color: AppColors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
