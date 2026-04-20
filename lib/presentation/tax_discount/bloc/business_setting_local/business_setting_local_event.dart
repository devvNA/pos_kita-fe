part of 'business_setting_local_bloc.dart';

@freezed
class BusinessSettingLocalEvent with _$BusinessSettingLocalEvent {
  const factory BusinessSettingLocalEvent.started() = _Started;
  const factory BusinessSettingLocalEvent.getBusinessSetting() =
      _GetBusinessSetting;

  // const factory BusinessSettingLocalEvent.addBusinessSetting(
  //     TaxDiscountModel data) = _AddBusinessSetting;

  // const factory BusinessSettingLocalEvent.editBusinessSetting(
  //     TaxDiscountModel data) = _EditBusinessSetting;

  // const factory BusinessSettingLocalEvent.deleteBusinessSetting(int id) =
  //     _DeleteBusinessSetting;
}
