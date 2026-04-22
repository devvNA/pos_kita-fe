// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outlet_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OutletEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutletEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OutletEvent()';
}


}

/// @nodoc
class $OutletEventCopyWith<$Res>  {
$OutletEventCopyWith(OutletEvent _, $Res Function(OutletEvent) __);
}


/// Adds pattern-matching-related methods to [OutletEvent].
extension OutletEventPatterns on OutletEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _GetOutlets value)?  getOutlets,TResult Function( _AddOutlet value)?  addOutlet,TResult Function( _EditOutlet value)?  editOutlet,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _GetOutlets() when getOutlets != null:
return getOutlets(_that);case _AddOutlet() when addOutlet != null:
return addOutlet(_that);case _EditOutlet() when editOutlet != null:
return editOutlet(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _GetOutlets value)  getOutlets,required TResult Function( _AddOutlet value)  addOutlet,required TResult Function( _EditOutlet value)  editOutlet,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _GetOutlets():
return getOutlets(_that);case _AddOutlet():
return addOutlet(_that);case _EditOutlet():
return editOutlet(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _GetOutlets value)?  getOutlets,TResult? Function( _AddOutlet value)?  addOutlet,TResult? Function( _EditOutlet value)?  editOutlet,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _GetOutlets() when getOutlets != null:
return getOutlets(_that);case _AddOutlet() when addOutlet != null:
return addOutlet(_that);case _EditOutlet() when editOutlet != null:
return editOutlet(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  getOutlets,TResult Function( OutletRequestModel data)?  addOutlet,TResult Function( OutletRequestModel data,  int id)?  editOutlet,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _GetOutlets() when getOutlets != null:
return getOutlets();case _AddOutlet() when addOutlet != null:
return addOutlet(_that.data);case _EditOutlet() when editOutlet != null:
return editOutlet(_that.data,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  getOutlets,required TResult Function( OutletRequestModel data)  addOutlet,required TResult Function( OutletRequestModel data,  int id)  editOutlet,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _GetOutlets():
return getOutlets();case _AddOutlet():
return addOutlet(_that.data);case _EditOutlet():
return editOutlet(_that.data,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  getOutlets,TResult? Function( OutletRequestModel data)?  addOutlet,TResult? Function( OutletRequestModel data,  int id)?  editOutlet,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _GetOutlets() when getOutlets != null:
return getOutlets();case _AddOutlet() when addOutlet != null:
return addOutlet(_that.data);case _EditOutlet() when editOutlet != null:
return editOutlet(_that.data,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements OutletEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OutletEvent.started()';
}


}




/// @nodoc


class _GetOutlets implements OutletEvent {
  const _GetOutlets();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetOutlets);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OutletEvent.getOutlets()';
}


}




/// @nodoc


class _AddOutlet implements OutletEvent {
  const _AddOutlet(this.data);
  

 final  OutletRequestModel data;

/// Create a copy of OutletEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddOutletCopyWith<_AddOutlet> get copyWith => __$AddOutletCopyWithImpl<_AddOutlet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddOutlet&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'OutletEvent.addOutlet(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AddOutletCopyWith<$Res> implements $OutletEventCopyWith<$Res> {
  factory _$AddOutletCopyWith(_AddOutlet value, $Res Function(_AddOutlet) _then) = __$AddOutletCopyWithImpl;
@useResult
$Res call({
 OutletRequestModel data
});




}
/// @nodoc
class __$AddOutletCopyWithImpl<$Res>
    implements _$AddOutletCopyWith<$Res> {
  __$AddOutletCopyWithImpl(this._self, this._then);

  final _AddOutlet _self;
  final $Res Function(_AddOutlet) _then;

/// Create a copy of OutletEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_AddOutlet(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OutletRequestModel,
  ));
}


}

/// @nodoc


class _EditOutlet implements OutletEvent {
  const _EditOutlet(this.data, this.id);
  

 final  OutletRequestModel data;
 final  int id;

/// Create a copy of OutletEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditOutletCopyWith<_EditOutlet> get copyWith => __$EditOutletCopyWithImpl<_EditOutlet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditOutlet&&(identical(other.data, data) || other.data == data)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,data,id);

@override
String toString() {
  return 'OutletEvent.editOutlet(data: $data, id: $id)';
}


}

/// @nodoc
abstract mixin class _$EditOutletCopyWith<$Res> implements $OutletEventCopyWith<$Res> {
  factory _$EditOutletCopyWith(_EditOutlet value, $Res Function(_EditOutlet) _then) = __$EditOutletCopyWithImpl;
@useResult
$Res call({
 OutletRequestModel data, int id
});




}
/// @nodoc
class __$EditOutletCopyWithImpl<$Res>
    implements _$EditOutletCopyWith<$Res> {
  __$EditOutletCopyWithImpl(this._self, this._then);

  final _EditOutlet _self;
  final $Res Function(_EditOutlet) _then;

/// Create a copy of OutletEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? id = null,}) {
  return _then(_EditOutlet(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OutletRequestModel,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OutletState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutletState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OutletState()';
}


}

/// @nodoc
class $OutletStateCopyWith<$Res>  {
$OutletStateCopyWith(OutletState _, $Res Function(OutletState) __);
}


/// Adds pattern-matching-related methods to [OutletState].
extension OutletStatePatterns on OutletState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Outlet> outlets)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.outlets);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Outlet> outlets)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.outlets);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Outlet> outlets)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.outlets);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OutletState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OutletState.initial()';
}


}




/// @nodoc


class _Loading implements OutletState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OutletState.loading()';
}


}




/// @nodoc


class _Loaded implements OutletState {
  const _Loaded(final  List<Outlet> outlets): _outlets = outlets;
  

 final  List<Outlet> _outlets;
 List<Outlet> get outlets {
  if (_outlets is EqualUnmodifiableListView) return _outlets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outlets);
}


/// Create a copy of OutletState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._outlets, _outlets));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_outlets));

@override
String toString() {
  return 'OutletState.loaded(outlets: $outlets)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $OutletStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Outlet> outlets
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of OutletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? outlets = null,}) {
  return _then(_Loaded(
null == outlets ? _self._outlets : outlets // ignore: cast_nullable_to_non_nullable
as List<Outlet>,
  ));
}


}

/// @nodoc


class _Error implements OutletState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of OutletState
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
  return 'OutletState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OutletStateCopyWith<$Res> {
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

/// Create a copy of OutletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
