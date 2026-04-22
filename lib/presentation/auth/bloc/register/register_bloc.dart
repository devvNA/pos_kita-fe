import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_kita/data/datasources/auth_remote_datasource.dart';
part 'register_bloc.freezed.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDataSource authRemoteDataSource;
  RegisterBloc(this.authRemoteDataSource) : super(_Initial()) {
    on<_Register>((event, emit) async {
      emit(RegisterState.loading());
      final result = await authRemoteDataSource.register(
        event.name,
        event.businessName,
        event.businessAddress,
        event.email,
        event.password,
      );
      result.fold((l) => emit(_Error(l)), (r) => emit(_Success()));
    });
  }
}
