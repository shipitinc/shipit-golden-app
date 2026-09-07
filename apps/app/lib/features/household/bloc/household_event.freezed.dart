// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HouseholdEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HouseholdEvent()';
}


}

/// @nodoc
class $HouseholdEventCopyWith<$Res>  {
$HouseholdEventCopyWith(HouseholdEvent _, $Res Function(HouseholdEvent) __);
}


/// Adds pattern-matching-related methods to [HouseholdEvent].
extension HouseholdEventPatterns on HouseholdEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HouseholdStarted value)?  started,TResult Function( HouseholdRefreshRequested value)?  refreshRequested,TResult Function( HouseholdMemberAdded value)?  memberAdded,TResult Function( HouseholdMemberRemoved value)?  memberRemoved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HouseholdStarted() when started != null:
return started(_that);case HouseholdRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case HouseholdMemberAdded() when memberAdded != null:
return memberAdded(_that);case HouseholdMemberRemoved() when memberRemoved != null:
return memberRemoved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HouseholdStarted value)  started,required TResult Function( HouseholdRefreshRequested value)  refreshRequested,required TResult Function( HouseholdMemberAdded value)  memberAdded,required TResult Function( HouseholdMemberRemoved value)  memberRemoved,}){
final _that = this;
switch (_that) {
case HouseholdStarted():
return started(_that);case HouseholdRefreshRequested():
return refreshRequested(_that);case HouseholdMemberAdded():
return memberAdded(_that);case HouseholdMemberRemoved():
return memberRemoved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HouseholdStarted value)?  started,TResult? Function( HouseholdRefreshRequested value)?  refreshRequested,TResult? Function( HouseholdMemberAdded value)?  memberAdded,TResult? Function( HouseholdMemberRemoved value)?  memberRemoved,}){
final _that = this;
switch (_that) {
case HouseholdStarted() when started != null:
return started(_that);case HouseholdRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case HouseholdMemberAdded() when memberAdded != null:
return memberAdded(_that);case HouseholdMemberRemoved() when memberRemoved != null:
return memberRemoved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  refreshRequested,TResult Function( String name,  String email)?  memberAdded,TResult Function( String memberId)?  memberRemoved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HouseholdStarted() when started != null:
return started();case HouseholdRefreshRequested() when refreshRequested != null:
return refreshRequested();case HouseholdMemberAdded() when memberAdded != null:
return memberAdded(_that.name,_that.email);case HouseholdMemberRemoved() when memberRemoved != null:
return memberRemoved(_that.memberId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  refreshRequested,required TResult Function( String name,  String email)  memberAdded,required TResult Function( String memberId)  memberRemoved,}) {final _that = this;
switch (_that) {
case HouseholdStarted():
return started();case HouseholdRefreshRequested():
return refreshRequested();case HouseholdMemberAdded():
return memberAdded(_that.name,_that.email);case HouseholdMemberRemoved():
return memberRemoved(_that.memberId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  refreshRequested,TResult? Function( String name,  String email)?  memberAdded,TResult? Function( String memberId)?  memberRemoved,}) {final _that = this;
switch (_that) {
case HouseholdStarted() when started != null:
return started();case HouseholdRefreshRequested() when refreshRequested != null:
return refreshRequested();case HouseholdMemberAdded() when memberAdded != null:
return memberAdded(_that.name,_that.email);case HouseholdMemberRemoved() when memberRemoved != null:
return memberRemoved(_that.memberId);case _:
  return null;

}
}

}

/// @nodoc


class HouseholdStarted implements HouseholdEvent {
  const HouseholdStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HouseholdEvent.started()';
}


}




/// @nodoc


class HouseholdRefreshRequested implements HouseholdEvent {
  const HouseholdRefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdRefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HouseholdEvent.refreshRequested()';
}


}




/// @nodoc


class HouseholdMemberAdded implements HouseholdEvent {
  const HouseholdMemberAdded({required this.name, required this.email});
  

 final  String name;
 final  String email;

/// Create a copy of HouseholdEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdMemberAddedCopyWith<HouseholdMemberAdded> get copyWith => _$HouseholdMemberAddedCopyWithImpl<HouseholdMemberAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdMemberAdded&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,name,email);

@override
String toString() {
  return 'HouseholdEvent.memberAdded(name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $HouseholdMemberAddedCopyWith<$Res> implements $HouseholdEventCopyWith<$Res> {
  factory $HouseholdMemberAddedCopyWith(HouseholdMemberAdded value, $Res Function(HouseholdMemberAdded) _then) = _$HouseholdMemberAddedCopyWithImpl;
@useResult
$Res call({
 String name, String email
});




}
/// @nodoc
class _$HouseholdMemberAddedCopyWithImpl<$Res>
    implements $HouseholdMemberAddedCopyWith<$Res> {
  _$HouseholdMemberAddedCopyWithImpl(this._self, this._then);

  final HouseholdMemberAdded _self;
  final $Res Function(HouseholdMemberAdded) _then;

/// Create a copy of HouseholdEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,}) {
  return _then(HouseholdMemberAdded(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HouseholdMemberRemoved implements HouseholdEvent {
  const HouseholdMemberRemoved({required this.memberId});
  

 final  String memberId;

/// Create a copy of HouseholdEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdMemberRemovedCopyWith<HouseholdMemberRemoved> get copyWith => _$HouseholdMemberRemovedCopyWithImpl<HouseholdMemberRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdMemberRemoved&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode => Object.hash(runtimeType,memberId);

@override
String toString() {
  return 'HouseholdEvent.memberRemoved(memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class $HouseholdMemberRemovedCopyWith<$Res> implements $HouseholdEventCopyWith<$Res> {
  factory $HouseholdMemberRemovedCopyWith(HouseholdMemberRemoved value, $Res Function(HouseholdMemberRemoved) _then) = _$HouseholdMemberRemovedCopyWithImpl;
@useResult
$Res call({
 String memberId
});




}
/// @nodoc
class _$HouseholdMemberRemovedCopyWithImpl<$Res>
    implements $HouseholdMemberRemovedCopyWith<$Res> {
  _$HouseholdMemberRemovedCopyWithImpl(this._self, this._then);

  final HouseholdMemberRemoved _self;
  final $Res Function(HouseholdMemberRemoved) _then;

/// Create a copy of HouseholdEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,}) {
  return _then(HouseholdMemberRemoved(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
