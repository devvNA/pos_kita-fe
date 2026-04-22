// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrinterEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrinterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrinterEvent()';
}


}

/// @nodoc
class $PrinterEventCopyWith<$Res>  {
$PrinterEventCopyWith(PrinterEvent _, $Res Function(PrinterEvent) __);
}


/// Adds pattern-matching-related methods to [PrinterEvent].
extension PrinterEventPatterns on PrinterEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _GetPrinters value)?  getPrinters,TResult Function( _AddPrinter value)?  addPrinter,TResult Function( _DeletePrinter value)?  deletePrinter,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _GetPrinters() when getPrinters != null:
return getPrinters(_that);case _AddPrinter() when addPrinter != null:
return addPrinter(_that);case _DeletePrinter() when deletePrinter != null:
return deletePrinter(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _GetPrinters value)  getPrinters,required TResult Function( _AddPrinter value)  addPrinter,required TResult Function( _DeletePrinter value)  deletePrinter,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _GetPrinters():
return getPrinters(_that);case _AddPrinter():
return addPrinter(_that);case _DeletePrinter():
return deletePrinter(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _GetPrinters value)?  getPrinters,TResult? Function( _AddPrinter value)?  addPrinter,TResult? Function( _DeletePrinter value)?  deletePrinter,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _GetPrinters() when getPrinters != null:
return getPrinters(_that);case _AddPrinter() when addPrinter != null:
return addPrinter(_that);case _DeletePrinter() when deletePrinter != null:
return deletePrinter(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  getPrinters,TResult Function( PrinterModel data)?  addPrinter,TResult Function( int id)?  deletePrinter,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _GetPrinters() when getPrinters != null:
return getPrinters();case _AddPrinter() when addPrinter != null:
return addPrinter(_that.data);case _DeletePrinter() when deletePrinter != null:
return deletePrinter(_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  getPrinters,required TResult Function( PrinterModel data)  addPrinter,required TResult Function( int id)  deletePrinter,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _GetPrinters():
return getPrinters();case _AddPrinter():
return addPrinter(_that.data);case _DeletePrinter():
return deletePrinter(_that.id);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  getPrinters,TResult? Function( PrinterModel data)?  addPrinter,TResult? Function( int id)?  deletePrinter,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _GetPrinters() when getPrinters != null:
return getPrinters();case _AddPrinter() when addPrinter != null:
return addPrinter(_that.data);case _DeletePrinter() when deletePrinter != null:
return deletePrinter(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements PrinterEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrinterEvent.started()';
}


}




/// @nodoc


class _GetPrinters implements PrinterEvent {
  const _GetPrinters();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetPrinters);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrinterEvent.getPrinters()';
}


}




/// @nodoc


class _AddPrinter implements PrinterEvent {
  const _AddPrinter(this.data);
  

 final  PrinterModel data;

/// Create a copy of PrinterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddPrinterCopyWith<_AddPrinter> get copyWith => __$AddPrinterCopyWithImpl<_AddPrinter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddPrinter&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PrinterEvent.addPrinter(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AddPrinterCopyWith<$Res> implements $PrinterEventCopyWith<$Res> {
  factory _$AddPrinterCopyWith(_AddPrinter value, $Res Function(_AddPrinter) _then) = __$AddPrinterCopyWithImpl;
@useResult
$Res call({
 PrinterModel data
});




}
/// @nodoc
class __$AddPrinterCopyWithImpl<$Res>
    implements _$AddPrinterCopyWith<$Res> {
  __$AddPrinterCopyWithImpl(this._self, this._then);

  final _AddPrinter _self;
  final $Res Function(_AddPrinter) _then;

/// Create a copy of PrinterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_AddPrinter(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PrinterModel,
  ));
}


}

/// @nodoc


class _DeletePrinter implements PrinterEvent {
  const _DeletePrinter(this.id);
  

 final  int id;

/// Create a copy of PrinterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletePrinterCopyWith<_DeletePrinter> get copyWith => __$DeletePrinterCopyWithImpl<_DeletePrinter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletePrinter&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'PrinterEvent.deletePrinter(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeletePrinterCopyWith<$Res> implements $PrinterEventCopyWith<$Res> {
  factory _$DeletePrinterCopyWith(_DeletePrinter value, $Res Function(_DeletePrinter) _then) = __$DeletePrinterCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$DeletePrinterCopyWithImpl<$Res>
    implements _$DeletePrinterCopyWith<$Res> {
  __$DeletePrinterCopyWithImpl(this._self, this._then);

  final _DeletePrinter _self;
  final $Res Function(_DeletePrinter) _then;

/// Create a copy of PrinterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DeletePrinter(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PrinterState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrinterState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrinterState()';
}


}

/// @nodoc
class $PrinterStateCopyWith<$Res>  {
$PrinterStateCopyWith(PrinterState _, $Res Function(PrinterState) __);
}


/// Adds pattern-matching-related methods to [PrinterState].
extension PrinterStatePatterns on PrinterState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PrinterModel> data)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.data);case _Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PrinterModel> data)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.data);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PrinterModel> data)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.data);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements PrinterState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrinterState.initial()';
}


}




/// @nodoc


class _Loading implements PrinterState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PrinterState.loading()';
}


}




/// @nodoc


class _Loaded implements PrinterState {
  const _Loaded(final  List<PrinterModel> data): _data = data;
  

 final  List<PrinterModel> _data;
 List<PrinterModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of PrinterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'PrinterState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $PrinterStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<PrinterModel> data
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of PrinterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_Loaded(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<PrinterModel>,
  ));
}


}

/// @nodoc


class _Error implements PrinterState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of PrinterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PrinterState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $PrinterStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of PrinterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
