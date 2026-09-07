// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'household_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HouseholdState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HouseholdState()';
}


}

/// @nodoc
class $HouseholdStateCopyWith<$Res>  {
$HouseholdStateCopyWith(HouseholdState _, $Res Function(HouseholdState) __);
}


/// Adds pattern-matching-related methods to [HouseholdState].
extension HouseholdStatePatterns on HouseholdState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HouseholdInitial value)?  initial,TResult Function( HouseholdLoading value)?  loading,TResult Function( HouseholdLoaded value)?  loaded,TResult Function( HouseholdFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HouseholdInitial() when initial != null:
return initial(_that);case HouseholdLoading() when loading != null:
return loading(_that);case HouseholdLoaded() when loaded != null:
return loaded(_that);case HouseholdFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HouseholdInitial value)  initial,required TResult Function( HouseholdLoading value)  loading,required TResult Function( HouseholdLoaded value)  loaded,required TResult Function( HouseholdFailure value)  failure,}){
final _that = this;
switch (_that) {
case HouseholdInitial():
return initial(_that);case HouseholdLoading():
return loading(_that);case HouseholdLoaded():
return loaded(_that);case HouseholdFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HouseholdInitial value)?  initial,TResult? Function( HouseholdLoading value)?  loading,TResult? Function( HouseholdLoaded value)?  loaded,TResult? Function( HouseholdFailure value)?  failure,}){
final _that = this;
switch (_that) {
case HouseholdInitial() when initial != null:
return initial(_that);case HouseholdLoading() when loading != null:
return loading(_that);case HouseholdLoaded() when loaded != null:
return loaded(_that);case HouseholdFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Household household,  List<HouseholdMember> members)?  loaded,TResult Function( AppFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HouseholdInitial() when initial != null:
return initial();case HouseholdLoading() when loading != null:
return loading();case HouseholdLoaded() when loaded != null:
return loaded(_that.household,_that.members);case HouseholdFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Household household,  List<HouseholdMember> members)  loaded,required TResult Function( AppFailure failure)  failure,}) {final _that = this;
switch (_that) {
case HouseholdInitial():
return initial();case HouseholdLoading():
return loading();case HouseholdLoaded():
return loaded(_that.household,_that.members);case HouseholdFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Household household,  List<HouseholdMember> members)?  loaded,TResult? Function( AppFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case HouseholdInitial() when initial != null:
return initial();case HouseholdLoading() when loading != null:
return loading();case HouseholdLoaded() when loaded != null:
return loaded(_that.household,_that.members);case HouseholdFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class HouseholdInitial implements HouseholdState {
  const HouseholdInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HouseholdState.initial()';
}


}




/// @nodoc


class HouseholdLoading implements HouseholdState {
  const HouseholdLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HouseholdState.loading()';
}


}




/// @nodoc


class HouseholdLoaded implements HouseholdState {
  const HouseholdLoaded({required this.household, required final  List<HouseholdMember> members}): _members = members;
  

 final  Household household;
 final  List<HouseholdMember> _members;
 List<HouseholdMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdLoadedCopyWith<HouseholdLoaded> get copyWith => _$HouseholdLoadedCopyWithImpl<HouseholdLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdLoaded&&(identical(other.household, household) || other.household == household)&&const DeepCollectionEquality().equals(other._members, _members));
}


@override
int get hashCode => Object.hash(runtimeType,household,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'HouseholdState.loaded(household: $household, members: $members)';
}


}

/// @nodoc
abstract mixin class $HouseholdLoadedCopyWith<$Res> implements $HouseholdStateCopyWith<$Res> {
  factory $HouseholdLoadedCopyWith(HouseholdLoaded value, $Res Function(HouseholdLoaded) _then) = _$HouseholdLoadedCopyWithImpl;
@useResult
$Res call({
 Household household, List<HouseholdMember> members
});


$HouseholdCopyWith<$Res> get household;

}
/// @nodoc
class _$HouseholdLoadedCopyWithImpl<$Res>
    implements $HouseholdLoadedCopyWith<$Res> {
  _$HouseholdLoadedCopyWithImpl(this._self, this._then);

  final HouseholdLoaded _self;
  final $Res Function(HouseholdLoaded) _then;

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? household = null,Object? members = null,}) {
  return _then(HouseholdLoaded(
household: null == household ? _self.household : household // ignore: cast_nullable_to_non_nullable
as Household,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<HouseholdMember>,
  ));
}

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HouseholdCopyWith<$Res> get household {
  
  return $HouseholdCopyWith<$Res>(_self.household, (value) {
    return _then(_self.copyWith(household: value));
  });
}
}

/// @nodoc


class HouseholdFailure implements HouseholdState {
  const HouseholdFailure({required this.failure});
  

 final  AppFailure failure;

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HouseholdFailureCopyWith<HouseholdFailure> get copyWith => _$HouseholdFailureCopyWithImpl<HouseholdFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HouseholdFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'HouseholdState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HouseholdFailureCopyWith<$Res> implements $HouseholdStateCopyWith<$Res> {
  factory $HouseholdFailureCopyWith(HouseholdFailure value, $Res Function(HouseholdFailure) _then) = _$HouseholdFailureCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$HouseholdFailureCopyWithImpl<$Res>
    implements $HouseholdFailureCopyWith<$Res> {
  _$HouseholdFailureCopyWithImpl(this._self, this._then);

  final HouseholdFailure _self;
  final $Res Function(HouseholdFailure) _then;

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(HouseholdFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of HouseholdState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
