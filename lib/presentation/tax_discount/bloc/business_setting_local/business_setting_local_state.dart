part of 'business_setting_local_bloc.dart';

@freezed
class BusinessSettingLocalState with _$BusinessSettingLocalState {
  const factory BusinessSettingLocalState.initial() = _Initial;
  const factory BusinessSettingLocalState.loading() = _Loading;
  const factory BusinessSettingLocalState.error(String message) = _Error;
  const factory BusinessSettingLocalState.loaded(List<TaxDiscountModel> data) =
      _Loaded;
}
