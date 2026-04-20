import '../../data/models/requests/business_setting_request_model.dart';
import '../../data/models/responses/tax_discount_model.dart';

extension BusinessSettingMapper on BusinessSettingRequestModel {
  /// Ubah respon server menjadi model lokal
  TaxDiscountModel toTaxDiscount() {
    return TaxDiscountModel(
      id: id, // id dari server – bebas mau disimpan atau tidak
      name: name,
      type: type,
      value: int.tryParse(value) ?? 0,
      status: 'active', // server tidak punya field ini, bebas di‑hardcode
      chargeType: chargeType,
    );
  }
}

extension TdMapper on TaxDiscountModel {
  BusinessSettingRequestModel toRequestModel() => BusinessSettingRequestModel(
        name,
        chargeType,
        type,
        value.toString(),
        0, // businessId tidak dipakai di sisi client
        id,
      );
}
