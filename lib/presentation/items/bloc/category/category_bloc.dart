import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_kita/data/datasources/category_remote_datasource.dart';
import 'package:pos_kita/data/models/responses/category_response_model.dart';

import '../../../../data/datasources/db_local_datasource.dart';

part 'category_bloc.freezed.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final DBLocalDatasource dbLocalDatasource;

  List<Category> categories = [];
  CategoryBloc(this.categoryRemoteDataSource, this.dbLocalDatasource)
    : super(_Initial()) {
    on<_GetCategories>((event, emit) async {
      emit(CategoryState.loading());
      final result = await categoryRemoteDataSource.getCategories();
      result.fold(
        (l) {
          emit(_Error(l));
        },
        (r) {
          categories = r.data ?? [];
          dbLocalDatasource.removeAllCategory();
          dbLocalDatasource.insertAllCategory(categories);
          emit(_Success(r.data ?? []));
        },
      );
    });

    //add
    on<_AddCategory>((event, emit) async {
      emit(CategoryState.loading());
      final result = await categoryRemoteDataSource.addCategory(event.name);
      result.fold((l) => emit(_Error(l)), (r) {
        add(_GetCategories());
      });
    });

    //update
    on<_UpdateCategory>((event, emit) async {
      emit(CategoryState.loading());
      final result = await categoryRemoteDataSource.updateCategory(
        event.id,
        event.name,
      );
      result.fold((l) => emit(_Error(l)), (r) {
        add(_GetCategories());
      });
    });

    // on<_FetchLocal>((event, emit) async {
    //   emit(const _Loading());
    //   log("🔥 Fetching local categories...");
    //   // reset global state agar tidak numpuk
    //   categories = [];
    //   final localCategories = await DBLocalDatasource.instance.getAllCategory();
    //   log("Local categories fetched: ${localCategories.length}");
    //   categories = localCategories;

    //   emit(_Success(categories));
    // });

    // on<_FetchLocal>((event, emit) async {
    //   emit(const _Loading());

    //   log("🔥 Fetching local categories...");
    //   categories = [];

    //   try {
    //     final localCategories = await dbLocalDatasource.getAllCategory();
    //     log("Local categories fetched: ${localCategories.length}");

    //     categories = localCategories;
    //     emit(_Success(categories));
    //   } catch (e) {
    //     log("Error fetching local categories: $e");
    //     emit(_Error("Gagal mengambil kategori dari lokal"));
    //   }
    // });
  }
}
