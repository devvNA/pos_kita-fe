// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StaffEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaffEvent()';
}


}

/// @nodoc
class $StaffEventCopyWith<$Res>  {
$StaffEventCopyWith(StaffEvent _, $Res Function(StaffEvent) __);
}


/// Adds pattern-matching-related methods to [StaffEvent].
extension StaffEventPatterns on StaffEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _GetStaffs value)?  getStaffs,TResult Function( _AddStaff value)?  addStaff,TResult Function( _EditStaff value)?  editStaff,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _GetStaffs() when getStaffs != null:
return getStaffs(_that);case _AddStaff() when addStaff != null:
return addStaff(_that);case _EditStaff() when editStaff != null:
return editStaff(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _GetStaffs value)  getStaffs,required TResult Function( _AddStaff value)  addStaff,required TResult Function( _EditStaff value)  editStaff,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _GetStaffs():
return getStaffs(_that);case _AddStaff():
return addStaff(_that);case _EditStaff():
return editStaff(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _GetStaffs value)?  getStaffs,TResult? Function( _AddStaff value)?  addStaff,TResult? Function( _EditStaff value)?  editStaff,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _GetStaffs() when getStaffs != null:
return getStaffs(_that);case _AddStaff() when addStaff != null:
return addStaff(_that);case _EditStaff() when editStaff != null:
return editStaff(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  getStaffs,TResult Function( StaffRequestModel data)?  addStaff,TResult Function( StaffRequestModel data,  int id)?  editStaff,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _GetStaffs() when getStaffs != null:
return getStaffs();case _AddStaff() when addStaff != null:
return addStaff(_that.data);case _EditStaff() when editStaff != null:
return editStaff(_that.data,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  getStaffs,required TResult Function( StaffRequestModel data)  addStaff,required TResult Function( StaffRequestModel data,  int id)  editStaff,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _GetStaffs():
return getStaffs();case _AddStaff():
return addStaff(_that.data);case _EditStaff():
return editStaff(_that.data,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  getStaffs,TResult? Function( StaffRequestModel data)?  addStaff,TResult? Function( StaffRequestModel data,  int id)?  editStaff,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _GetStaffs() when getStaffs != null:
return getStaffs();case _AddStaff() when addStaff != null:
return addStaff(_that.data);case _EditStaff() when editStaff != null:
return editStaff(_that.data,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements StaffEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaffEvent.started()';
}


}




/// @nodoc


class _GetStaffs implements StaffEvent {
  const _GetStaffs();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetStaffs);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaffEvent.getStaffs()';
}


}




/// @nodoc


class _AddStaff implements StaffEvent {
  const _AddStaff(this.data);
  

 final  StaffRequestModel data;

/// Create a copy of StaffEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddStaffCopyWith<_AddStaff> get copyWith => __$AddStaffCopyWithImpl<_AddStaff>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddStaff&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'StaffEvent.addStaff(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AddStaffCopyWith<$Res> implements $StaffEventCopyWith<$Res> {
  factory _$AddStaffCopyWith(_AddStaff value, $Res Function(_AddStaff) _then) = __$AddStaffCopyWithImpl;
@useResult
$Res call({
 StaffRequestModel data
});




}
/// @nodoc
class __$AddStaffCopyWithImpl<$Res>
    implements _$AddStaffCopyWith<$Res> {
  __$AddStaffCopyWithImpl(this._self, this._then);

  final _AddStaff _self;
  final $Res Function(_AddStaff) _then;

/// Create a copy of StaffEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_AddStaff(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StaffRequestModel,
  ));
}


}

/// @nodoc


class _EditStaff implements StaffEvent {
  const _EditStaff(this.data, this.id);
  

 final  StaffRequestModel data;
 final  int id;

/// Create a copy of StaffEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditStaffCopyWith<_EditStaff> get copyWith => __$EditStaffCopyWithImpl<_EditStaff>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditStaff&&(identical(other.data, data) || other.data == data)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,data,id);

@override
String toString() {
  return 'StaffEvent.editStaff(data: $data, id: $id)';
}


}

/// @nodoc
abstract mixin class _$EditStaffCopyWith<$Res> implements $StaffEventCopyWith<$Res> {
  factory _$EditStaffCopyWith(_EditStaff value, $Res Function(_EditStaff) _then) = __$EditStaffCopyWithImpl;
@useResult
$Res call({
 StaffRequestModel data, int id
});




}
/// @nodoc
class __$EditStaffCopyWithImpl<$Res>
    implements _$EditStaffCopyWith<$Res> {
  __$EditStaffCopyWithImpl(this._self, this._then);

  final _EditStaff _self;
  final $Res Function(_EditStaff) _then;

/// Create a copy of StaffEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? id = null,}) {
  return _then(_EditStaff(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as StaffRequestModel,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$StaffState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaffState()';
}


}

/// @nodoc
class $StaffStateCopyWith<$Res>  {
$StaffStateCopyWith(StaffState _, $Res Function(StaffState) __);
}


/// Adds pattern-matching-related methods to [StaffState].
extension StaffStatePatterns on StaffState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String message)?  error,TResult Function( List<UserModel> data)?  loaded,required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String message)  error,required TResult Function( List<UserModel> data)  loaded,}) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String message)?  error,TResult? Function( List<UserModel> data)?  loaded,}) {final _that = this;
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


class _Initial implements StaffState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaffState.initial()';
}


}




/// @nodoc


class _Loading implements StaffState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StaffState.loading()';
}


}




/// @nodoc


class _Error implements StaffState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of StaffState
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
  return 'StaffState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $StaffStateCopyWith<$Res> {
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

/// Create a copy of StaffState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Loaded implements StaffState {
  const _Loaded(final  List<UserModel> data): _data = data;
  

 final  List<UserModel> _data;
 List<UserModel> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of StaffState
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
  return 'StaffState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $StaffStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<UserModel> data
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of StaffState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_Loaded(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<UserModel>,
  ));
}


}

// dart format on
