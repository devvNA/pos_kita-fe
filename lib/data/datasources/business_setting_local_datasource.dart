import 'package:pos_kita/data/datasources/db_local_datasource.dart';

import '../models/responses/tax_discount_model.dart';

class BusinessSettingLocalDatasource {
  final DBLocalDatasource _db = DBLocalDatasource.instance;

  Future<List<TaxDiscountModel>> getBusinessSetting() =>
      _db.getAllTaxDiscount();

  Future<void> addBusinessSetting(TaxDiscountModel data) =>
      _db.saveTaxDiscount(data);

  Future<void> updateBusinessSetting(TaxDiscountModel data) =>
      _db.updateTaxDiscount(data);

  Future<void> deleteBusinessSetting(int id) => _db.deleteTaxDiscount(id);
}
