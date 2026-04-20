import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/business_setting_local_datasource.dart';
import '../../../../data/models/responses/tax_discount_model.dart';

part 'business_setting_local_bloc.freezed.dart';
part 'business_setting_local_event.dart';
part 'business_setting_local_state.dart';

class BusinessSettingLocalBloc
    extends Bloc<BusinessSettingLocalEvent, BusinessSettingLocalState> {
  final BusinessSettingLocalDatasource datasource;
  BusinessSettingLocalBloc(
    this.datasource,
  ) : super(_Initial()) {
    // Ambil semua data
    on<_GetBusinessSetting>((event, emit) async {
      emit(const _Loading());
      try {
        final data = await datasource.getBusinessSetting();
        emit(_Loaded(data));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    // // Tambah
    // on<_AddBusinessSetting>((event, emit) async {
    //   emit(const _Loading());
    //   try {
    //     await datasource.addBusinessSetting(event.data);
    //     add(const BusinessSettingLocalEvent.getBusinessSetting());
    //   } catch (e) {
    //     emit(_Error(e.toString()));
    //   }
    // });

    // // Edit
    // on<_EditBusinessSetting>((event, emit) async {
    //   emit(const _Loading());
    //   try {
    //     await datasource.updateBusinessSetting(event.data);
    //     add(const BusinessSettingLocalEvent.getBusinessSetting());
    //   } catch (e) {
    //     emit(_Error(e.toString()));
    //   }
    // });

    // // Hapus
    // on<_DeleteBusinessSetting>((event, emit) async {
    //   emit(const _Loading());
    //   try {
    //     await datasource.deleteBusinessSetting(event.id);
    //     add(const BusinessSettingLocalEvent.getBusinessSetting());
    //   } catch (e) {
    //     emit(_Error(e.toString()));
    //   }
    // });
  }
}
