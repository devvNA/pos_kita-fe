import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/db_local_datasource.dart';
import '../../../../data/models/responses/category_response_model.dart';

part 'category_local_event.dart';
part 'category_local_state.dart';
part 'category_local_bloc.freezed.dart';

class CategoryLocalBloc extends Bloc<CategoryLocalEvent, CategoryLocalState> {
  final DBLocalDatasource dbLocalDatasource;
  CategoryLocalBloc(this.dbLocalDatasource) : super(_Initial()) {
    on<_FetchLocal>((event, emit) async {
      emit(_Loading());
      try {
        final categories = await dbLocalDatasource.getAllCategory();
        emit(_Success(categories));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
