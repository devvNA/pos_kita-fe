import 'package:dartz/dartz.dart';
import 'package:pos_kita/core/constants/variables.dart';
import 'package:pos_kita/data/datasources/auth_local_datasource.dart';
import 'package:pos_kita/data/models/requests/staff_request_model.dart';
import 'package:pos_kita/data/models/responses/staff_response_model.dart';
import 'package:http/http.dart' as http;

class StaffRemoteDatasource {
  Future<Either<String, String>> addStaff(StaffRequestModel data) async {
    final authData = await AuthLocalDatasource().getUserData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/add-staff'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData?.accessToken}',
      },
      body: data.toJson(),
    );

    if (response.statusCode == 201) {
      return Right('Success');
    } else {
      return Left('Failed');
    }
  }

  Future<Either<String, String>> updateStaff(
    StaffRequestModel data,
    int id,
  ) async {
    final authData = await AuthLocalDatasource().getUserData();
    final response = await http.put(
      Uri.parse('${Variables.baseUrl}/api/edit-staff/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData?.accessToken}',
      },
      body: data.toJson(),
    );

    if (response.statusCode == 200) {
      return Right('Success');
    } else {
      return Left('Failed');
    }
  }

  Future<Either<String, StaffResponseModel>> getStaffs() async {
    final authData = await AuthLocalDatasource().getUserData();
    final response = await http.get(
      Uri.parse(
        '${Variables.baseUrl}/api/get-staff/${authData?.data!.businessId}',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData?.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      return Right(StaffResponseModel.fromJson(response.body));
    } else {
      return Left('Failed');
    }
  }
}
