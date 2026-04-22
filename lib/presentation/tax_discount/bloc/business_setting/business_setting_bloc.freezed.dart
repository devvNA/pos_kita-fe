// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_setting_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BusinessSettingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessSettingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BusinessSettingEvent()';
}


}

/// @nodoc
class $BusinessSettingEventCopyWith<$Res>  {
$BusinessSettingEventCopyWith(BusinessSettingEvent _, $Res Function(BusinessSettingEvent) __);
}


/// Adds pattern-matching-related methods to [BusinessSettingEvent].
extension BusinessSettingEventPatterns on BusinessSettingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _AddBusinessSetting value)?  addBusinessSetting,TResult Function( _GetBusinessSetting value)?  getBusinessSetting,TResult Function( _EditBusinessSetting value)?  editBusinessSetting,TResult Function( _DeleteBusinessSetting value)?  deleteBusinessSetting,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AddBusinessSetting() when addBusinessSetting != null:
return addBusinessSetting(_that);case _GetBusinessSetting() when getBusinessSetting != null:
return getBusinessSetting(_that);case _EditBusinessSetting() when editBusinessSetting != null:
return editBusinessSetting(_that);case _DeleteBusinessSetting() when deleteBusinessSetting != null:
return deleteBusinessSetting(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _AddBusinessSetting value)  addBusinessSetting,required TResult Function( _GetBusinessSetting value)  getBusinessSetting,required TResult Function( _EditBusinessSetting value)  editBusinessSetting,required TResult Function( _DeleteBusinessSetting value)  deleteBusinessSetting,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _AddBusinessSetting():
return addBusinessSetting(_that);case _GetBusinessSetting():
return getBusinessSetting(_that);case _EditBusinessSetting():
return editBusinessSetting(_that);case _DeleteBusinessSetting():
return deleteBusinessSetting(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _AddBusinessSetting value)?  addBusinessSetting,TResult? Function( _GetBusinessSetting value)?  getBusinessSetting,TResult? Function( _EditBusinessSetting value)?  editBusinessSetting,TResult? Function( _DeleteBusinessSetting value)?  deleteBusinessSetting,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AddBusinessSetting() when addBusinessSetting != null:
return addBusinessSetting(_that);case _GetBusinessSetting() when getBusinessSetting != null:
return getBusinessSetting(_that);case _EditBusinessSetting() when editBusinessSetting != null:
return editBusinessSetting(_that);case _DeleteBusinessSetting() when deleteBusinessSetting != null:
return deleteBusinessSetting(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( BusinessSettingRequestModel data)?  addBusinessSetting,TResult Function()?  getBusinessSetting,TResult Function( BusinessSettingRequestModel data,  int id)?  editBusinessSetting,TResult Function( int id)?  deleteBusinessSetting,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _AddBusinessSetting() when addBusinessSetting != null:
return addBusinessSetting(_that.data);case _GetBusinessSetting() when getBusinessSetting != null:
return getBusinessSetting();case _EditBusinessSetting() when editBusinessSetting != null:
return editBusinessSetting(_that.data,_that.id);case _DeleteBusinessSetting() when deleteBusinessSetting != null:
return deleteBusinessSetting(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( BusinessSettingRequestModel data)  addBusinessSetting,required TResult Function()  getBusinessSetting,required TResult Function( BusinessSettingRequestModel data,  int id)  editBusinessSetting,required TResult Function( int id)  deleteBusinessSetting,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _AddBusinessSetting():
return addBusinessSetting(_that.data);case _GetBusinessSetting():
return getBusinessSetting();case _EditBusinessSetting():
return editBusinessSetting(_that.data,_that.id);case _DeleteBusinessSetting():
return deleteBusinessSetting(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( BusinessSettingRequestModel data)?  addBusinessSetting,TResult? Function()?  getBusinessSetting,TResult? Function( BusinessSettingRequestModel data,  int id)?  editBusinessSetting,TResult? Function( int id)?  deleteBusinessSetting,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _AddBusinessSetting() when addBusinessSetting != null:
return addBusinessSetting(_that.data);case _GetBusinessSetting() when getBusinessSetting != null:
return getBusinessSetting();case _EditBusinessSetting() when editBusinessSetting != null:
return editBusinessSetting(_that.data,_that.id);case _DeleteBusinessSetting() when deleteBusinessSetting != null:
return deleteBusinessSetting(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements BusinessSettingEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BusinessSettingEvent.started()';
}


}




/// @nodoc


class _AddBusinessSetting implements BusinessSettingEvent {
  const _AddBusinessSetting(this.data);
  

 final  BusinessSettingRequestModel data;

/// Create a copy of BusinessSettingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddBusinessSettingCopyWith<_AddBusinessSetting> get copyWith => __$AddBusinessSettingCopyWithImpl<_AddBusinessSetting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddBusinessSetting&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'BusinessSettingEvent.addBusinessSetting(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AddBusinessSettingCopyWith<$Res> implements $BusinessSettingEventCopyWith<$Res> {
  factory _$AddBusinessSettingCopyWith(_AddBusinessSetting value, $Res Function(_AddBusinessSetting) _then) = __$AddBusinessSettingCopyWithImpl;
@useResult
$Res call({
 BusinessSettingRequestModel data
});




}
/// @nodoc
class __$AddBusinessSettingCopyWithImpl<$Res>
    implements _$AddBusinessSettingCopyWith<$Res> {
  __$AddBusinessSettingCopyWithImpl(this._self, this._then);

  final _AddBusinessSetting _self;
  final $Res Function(_AddBusinessSetting) _then;

/// Create a copy of BusinessSettingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_AddBusinessSetting(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BusinessSettingRequestModel,
  ));
}


}

/// @nodoc


class _GetBusinessSetting implements BusinessSettingEvent {
  const _GetBusinessSetting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetBusinessSetting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BusinessSettingEvent.getBusinessSetting()';
}


}




/// @nodoc


class _EditBusinessSetting implements BusinessSettingEvent {
  const _EditBusinessSetting(this.data, this.id);
  

 final  BusinessSettingRequestModel data;
 final  int id;

/// Create a copy of BusinessSettingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditBusinessSettingCopyWith<_EditBusinessSetting> get copyWith => __$EditBusinessSettingCopyWithImpl<_EditBusinessSetting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditBusinessSetting&&(identical(other.data, data) || other.data == data)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,data,id);

@override
String toString() {
  return 'BusinessSettingEvent.editBusinessSetting(data: $data, id: $id)';
}


}

/// @nodoc
abstract mixin class _$EditBusinessSettingCopyWith<$Res> implements $BusinessSettingEventCopyWith<$Res> {
  factory _$EditBusinessSettingCopyWith(_EditBusinessSetting value, $Res Function(_EditBusinessSetting) _then) = __$EditBusinessSettingCopyWithImpl;
@useResult
$Res call({
 BusinessSettingRequestModel data, int id
});




}
/// @nodoc
class __$EditBusinessSettingCopyWithImpl<$Res>
    implements _$EditBusinessSettingCopyWith<$Res> {
  __$EditBusinessSettingCopyWithImpl(this._self, this._then);

  final _EditBusinessSetting _self;
  final $Res Function(_EditBusinessSetting) _then;

/// Create a copy of BusinessSettingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? id = null,}) {
  return _then(_EditBusinessSetting(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BusinessSettingRequestModel,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _DeleteBusinessSetting implements BusinessSettingEvent {
  const _DeleteBusinessSetting(this.id);
  

 final  int id;

/// Create a copy of BusinessSettingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteBusinessSettingCopyWith<_DeleteBusinessSetting> get copyWith => __$DeleteBusinessSettingCopyWithImpl<_DeleteBusinessSetting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteBusinessSetting&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'BusinessSettingEvent.deleteBusinessSetting(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeleteBusinessSettingCopyWith<$Res> implements $BusinessSettingEventCopyWith<$Res> {
  factory _$DeleteBusinessSettingCopyWith(_DeleteBusinessSetting value, $Res Function(_DeleteBusinessSetting) _then) = __$DeleteBusinessSettingCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$DeleteBusinessSettingCopyWithImpl<$Res>
    implements _$DeleteBusinessSettingCopyWith<$Res> {
  __$DeleteBusinessSettingCopyWithImpl(this._self, this._then);

  final _DeleteBusinessSetting _self;
  final $Res Function(_DeleteBusinessSetting) _then;

/// Create a copy of BusinessSettingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DeleteBusinessSetting(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BusinessSettingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessSettingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BusinessSettingState()';
}


}

/// @nodoc
class $BusinessSettingStateCopyWith<$Res>  {
$BusinessSettingStateCopyWith(BusinessSettingState _, $Res Function(BusinessSettingState) __);
}


/// Adds pattern-matching-related methods to [BusinessSettingState].
extension BusinessSettingStatePatterns on BusinessSettingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Error value)?  error,TResult Function( _Loaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _Loaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Error value)  error,required TResult Function( _Loaded value)  loaded,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Error():
return error(_that);case _Loaded():
return loaded(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Error value)?  error,TResult? Function( _Loaded value)?  loaded,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Error() when error != null:
return error(_that);case _Loaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<BusinessSettingRequestModel> data)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<BusinessSettingRequestModel> data)  loaded,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Error():
return error(_that.message);case _Loaded():
return loaded(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<BusinessSettingRequestModel> data)?  loaded,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Error() when error != null:
return error(_that.message);case _Loaded() when loaded != null:
return loaded(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements BusinessSettingState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BusinessSettingState.initial()';
}


}




/// @nodoc


class _Loading implements BusinessSettingState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BusinessSettingState.loading()';
}


}




/// @nodoc


class _Error implements BusinessSettingState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of BusinessSettingState
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
  return 'BusinessSettingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $BusinessSettingStateCopyWith<$Res> {
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

/// Create a copy of BusinessSettingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements BusinessSettingState {
  const _Loaded(final  List<BusinessSettingRequestModel> data): _data = data;
  

 final  List<BusinessSettingRequestModel> _data;
 List<BusinessSettingRequestModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of BusinessSettingState
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
  return 'BusinessSettingState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $BusinessSettingStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<BusinessSettingRequestModel> data
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of BusinessSettingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_Loaded(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<BusinessSettingRequestModel>,
  ));
}


}

// dart format on
