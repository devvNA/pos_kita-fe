import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/printer_request_model.dart';
import 'package:pos_kita/data/models/responses/printer_response_model.dart';

import 'package:http/http.dart' as http;

class PrinterRemoteDatasource {
  Future<Either<String, String>> addPrinter(PrinterModel data) async {
    final authData = await AuthLocalDatasource().getUserData();
    final token = authData!.accessToken;
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/add-printer'),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: data.toJson(),
    );

    if (response.statusCode == 201) {
      return right('Success');
    } else {
      return left('Failed');
    }
  }

  //delete printer
  Future<Either<String, String>> deletePrinter(int id) async {
    final authData = await AuthLocalDatasource().getUserData();
    final token = authData!.accessToken;
    final response = await http.delete(
      Uri.parse('${Variables.baseUrl}/api/delete-printer/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return right('Success');
    } else {
      return left('Failed');
    }
  }

  Future<Either<String, PrinterResponseModel>> getPrinters() async {
    final authData = await AuthLocalDatasource().getUserData();
    final outletData = await AuthLocalDatasource().getOutletData();
    final token = authData!.accessToken;
    final response = await http.get(
      Uri.parse(
        '${Variables.baseUrl}/api/get-printers-by-outlet/${outletData.id}',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return right(PrinterResponseModel.fromJson(response.body));
    } else {
      return left('Failed');
    }
  }
}
