// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutEvent()';
}


}

/// @nodoc
class $CheckoutEventCopyWith<$Res>  {
$CheckoutEventCopyWith(CheckoutEvent _, $Res Function(CheckoutEvent) __);
}


/// Adds pattern-matching-related methods to [CheckoutEvent].
extension CheckoutEventPatterns on CheckoutEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _AddToCart value)?  addToCart,TResult Function( _RemoveFromCart value)?  removeFromCart,TResult Function( _AddDiscount value)?  addDiscount,TResult Function( _RemoveDiscount value)?  removeDiscount,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AddToCart() when addToCart != null:
return addToCart(_that);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that);case _AddDiscount() when addDiscount != null:
return addDiscount(_that);case _RemoveDiscount() when removeDiscount != null:
return removeDiscount(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _AddToCart value)  addToCart,required TResult Function( _RemoveFromCart value)  removeFromCart,required TResult Function( _AddDiscount value)  addDiscount,required TResult Function( _RemoveDiscount value)  removeDiscount,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _AddToCart():
return addToCart(_that);case _RemoveFromCart():
return removeFromCart(_that);case _AddDiscount():
return addDiscount(_that);case _RemoveDiscount():
return removeDiscount(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _AddToCart value)?  addToCart,TResult? Function( _RemoveFromCart value)?  removeFromCart,TResult? Function( _AddDiscount value)?  addDiscount,TResult? Function( _RemoveDiscount value)?  removeDiscount,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _AddToCart() when addToCart != null:
return addToCart(_that);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that);case _AddDiscount() when addDiscount != null:
return addDiscount(_that);case _RemoveDiscount() when removeDiscount != null:
return removeDiscount(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( Product product,  List<BusinessSettingRequestModel> businessSetting)?  addToCart,TResult Function( Product product,  List<BusinessSettingRequestModel> businessSetting)?  removeFromCart,TResult Function( BusinessSettingRequestModel discount)?  addDiscount,TResult Function( BusinessSettingRequestModel discount)?  removeDiscount,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _AddToCart() when addToCart != null:
return addToCart(_that.product,_that.businessSetting);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that.product,_that.businessSetting);case _AddDiscount() when addDiscount != null:
return addDiscount(_that.discount);case _RemoveDiscount() when removeDiscount != null:
return removeDiscount(_that.discount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( Product product,  List<BusinessSettingRequestModel> businessSetting)  addToCart,required TResult Function( Product product,  List<BusinessSettingRequestModel> businessSetting)  removeFromCart,required TResult Function( BusinessSettingRequestModel discount)  addDiscount,required TResult Function( BusinessSettingRequestModel discount)  removeDiscount,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _AddToCart():
return addToCart(_that.product,_that.businessSetting);case _RemoveFromCart():
return removeFromCart(_that.product,_that.businessSetting);case _AddDiscount():
return addDiscount(_that.discount);case _RemoveDiscount():
return removeDiscount(_that.discount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( Product product,  List<BusinessSettingRequestModel> businessSetting)?  addToCart,TResult? Function( Product product,  List<BusinessSettingRequestModel> businessSetting)?  removeFromCart,TResult? Function( BusinessSettingRequestModel discount)?  addDiscount,TResult? Function( BusinessSettingRequestModel discount)?  removeDiscount,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _AddToCart() when addToCart != null:
return addToCart(_that.product,_that.businessSetting);case _RemoveFromCart() when removeFromCart != null:
return removeFromCart(_that.product,_that.businessSetting);case _AddDiscount() when addDiscount != null:
return addDiscount(_that.discount);case _RemoveDiscount() when removeDiscount != null:
return removeDiscount(_that.discount);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements CheckoutEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutEvent.started()';
}


}




/// @nodoc


class _AddToCart implements CheckoutEvent {
  const _AddToCart({required this.product, required final  List<BusinessSettingRequestModel> businessSetting}): _businessSetting = businessSetting;
  

 final  Product product;
 final  List<BusinessSettingRequestModel> _businessSetting;
 List<BusinessSettingRequestModel> get businessSetting {
  if (_businessSetting is EqualUnmodifiableListView) return _businessSetting;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_businessSetting);
}


/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddToCartCopyWith<_AddToCart> get copyWith => __$AddToCartCopyWithImpl<_AddToCart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddToCart&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._businessSetting, _businessSetting));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_businessSetting));

@override
String toString() {
  return 'CheckoutEvent.addToCart(product: $product, businessSetting: $businessSetting)';
}


}

/// @nodoc
abstract mixin class _$AddToCartCopyWith<$Res> implements $CheckoutEventCopyWith<$Res> {
  factory _$AddToCartCopyWith(_AddToCart value, $Res Function(_AddToCart) _then) = __$AddToCartCopyWithImpl;
@useResult
$Res call({
 Product product, List<BusinessSettingRequestModel> businessSetting
});




}
/// @nodoc
class __$AddToCartCopyWithImpl<$Res>
    implements _$AddToCartCopyWith<$Res> {
  __$AddToCartCopyWithImpl(this._self, this._then);

  final _AddToCart _self;
  final $Res Function(_AddToCart) _then;

/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,Object? businessSetting = null,}) {
  return _then(_AddToCart(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,businessSetting: null == businessSetting ? _self._businessSetting : businessSetting // ignore: cast_nullable_to_non_nullable
as List<BusinessSettingRequestModel>,
  ));
}


}

/// @nodoc


class _RemoveFromCart implements CheckoutEvent {
  const _RemoveFromCart({required this.product, required final  List<BusinessSettingRequestModel> businessSetting}): _businessSetting = businessSetting;
  

 final  Product product;
 final  List<BusinessSettingRequestModel> _businessSetting;
 List<BusinessSettingRequestModel> get businessSetting {
  if (_businessSetting is EqualUnmodifiableListView) return _businessSetting;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_businessSetting);
}


/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveFromCartCopyWith<_RemoveFromCart> get copyWith => __$RemoveFromCartCopyWithImpl<_RemoveFromCart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveFromCart&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._businessSetting, _businessSetting));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_businessSetting));

@override
String toString() {
  return 'CheckoutEvent.removeFromCart(product: $product, businessSetting: $businessSetting)';
}


}

/// @nodoc
abstract mixin class _$RemoveFromCartCopyWith<$Res> implements $CheckoutEventCopyWith<$Res> {
  factory _$RemoveFromCartCopyWith(_RemoveFromCart value, $Res Function(_RemoveFromCart) _then) = __$RemoveFromCartCopyWithImpl;
@useResult
$Res call({
 Product product, List<BusinessSettingRequestModel> businessSetting
});




}
/// @nodoc
class __$RemoveFromCartCopyWithImpl<$Res>
    implements _$RemoveFromCartCopyWith<$Res> {
  __$RemoveFromCartCopyWithImpl(this._self, this._then);

  final _RemoveFromCart _self;
  final $Res Function(_RemoveFromCart) _then;

/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,Object? businessSetting = null,}) {
  return _then(_RemoveFromCart(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,businessSetting: null == businessSetting ? _self._businessSetting : businessSetting // ignore: cast_nullable_to_non_nullable
as List<BusinessSettingRequestModel>,
  ));
}


}

/// @nodoc


class _AddDiscount implements CheckoutEvent {
  const _AddDiscount({required this.discount});
  

 final  BusinessSettingRequestModel discount;

/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddDiscountCopyWith<_AddDiscount> get copyWith => __$AddDiscountCopyWithImpl<_AddDiscount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddDiscount&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,discount);

@override
String toString() {
  return 'CheckoutEvent.addDiscount(discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$AddDiscountCopyWith<$Res> implements $CheckoutEventCopyWith<$Res> {
  factory _$AddDiscountCopyWith(_AddDiscount value, $Res Function(_AddDiscount) _then) = __$AddDiscountCopyWithImpl;
@useResult
$Res call({
 BusinessSettingRequestModel discount
});




}
/// @nodoc
class __$AddDiscountCopyWithImpl<$Res>
    implements _$AddDiscountCopyWith<$Res> {
  __$AddDiscountCopyWithImpl(this._self, this._then);

  final _AddDiscount _self;
  final $Res Function(_AddDiscount) _then;

/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discount = null,}) {
  return _then(_AddDiscount(
discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as BusinessSettingRequestModel,
  ));
}


}

/// @nodoc


class _RemoveDiscount implements CheckoutEvent {
  const _RemoveDiscount({required this.discount});
  

 final  BusinessSettingRequestModel discount;

/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveDiscountCopyWith<_RemoveDiscount> get copyWith => __$RemoveDiscountCopyWithImpl<_RemoveDiscount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveDiscount&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,discount);

@override
String toString() {
  return 'CheckoutEvent.removeDiscount(discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$RemoveDiscountCopyWith<$Res> implements $CheckoutEventCopyWith<$Res> {
  factory _$RemoveDiscountCopyWith(_RemoveDiscount value, $Res Function(_RemoveDiscount) _then) = __$RemoveDiscountCopyWithImpl;
@useResult
$Res call({
 BusinessSettingRequestModel discount
});




}
/// @nodoc
class __$RemoveDiscountCopyWithImpl<$Res>
    implements _$RemoveDiscountCopyWith<$Res> {
  __$RemoveDiscountCopyWithImpl(this._self, this._then);

  final _RemoveDiscount _self;
  final $Res Function(_RemoveDiscount) _then;

/// Create a copy of CheckoutEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discount = null,}) {
  return _then(_RemoveDiscount(
discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as BusinessSettingRequestModel,
  ));
}


}

/// @nodoc
mixin _$CheckoutState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState()';
}


}

/// @nodoc
class $CheckoutStateCopyWith<$Res>  {
$CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ProductQuantity> cart,  double discount,  double tax,  double subtotal,  double total,  int totalItems)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.cart,_that.discount,_that.tax,_that.subtotal,_that.total,_that.totalItems);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ProductQuantity> cart,  double discount,  double tax,  double subtotal,  double total,  int totalItems)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success(_that.cart,_that.discount,_that.tax,_that.subtotal,_that.total,_that.totalItems);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ProductQuantity> cart,  double discount,  double tax,  double subtotal,  double total,  int totalItems)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success(_that.cart,_that.discount,_that.tax,_that.subtotal,_that.total,_that.totalItems);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CheckoutState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState.initial()';
}


}




/// @nodoc


class _Loading implements CheckoutState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState.loading()';
}


}




/// @nodoc


class _Success implements CheckoutState {
  const _Success(final  List<ProductQuantity> cart, this.discount, this.tax, this.subtotal, this.total, this.totalItems): _cart = cart;
  

 final  List<ProductQuantity> _cart;
 List<ProductQuantity> get cart {
  if (_cart is EqualUnmodifiableListView) return _cart;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cart);
}

 final  double discount;
 final  double tax;
 final  double subtotal;
 final  double total;
 final  int totalItems;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&const DeepCollectionEquality().equals(other._cart, _cart)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.tax, tax) || other.tax == tax)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cart),discount,tax,subtotal,total,totalItems);

@override
String toString() {
  return 'CheckoutState.success(cart: $cart, discount: $discount, tax: $tax, subtotal: $subtotal, total: $total, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 List<ProductQuantity> cart, double discount, double tax, double subtotal, double total, int totalItems
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cart = null,Object? discount = null,Object? tax = null,Object? subtotal = null,Object? total = null,Object? totalItems = null,}) {
  return _then(_Success(
null == cart ? _self._cart : cart // ignore: cast_nullable_to_non_nullable
as List<ProductQuantity>,null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,null == tax ? _self.tax : tax // ignore: cast_nullable_to_non_nullable
as double,null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Error implements CheckoutState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of CheckoutState
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
  return 'CheckoutState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
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

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
