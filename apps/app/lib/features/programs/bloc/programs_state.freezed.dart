// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'programs_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgramsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProgramsState()';
}


}

/// @nodoc
class $ProgramsStateCopyWith<$Res>  {
$ProgramsStateCopyWith(ProgramsState _, $Res Function(ProgramsState) __);
}


/// Adds pattern-matching-related methods to [ProgramsState].
extension ProgramsStatePatterns on ProgramsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProgramsInitial value)?  initial,TResult Function( ProgramsLoading value)?  loading,TResult Function( ProgramsLoaded value)?  loaded,TResult Function( ProgramsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProgramsInitial() when initial != null:
return initial(_that);case ProgramsLoading() when loading != null:
return loading(_that);case ProgramsLoaded() when loaded != null:
return loaded(_that);case ProgramsFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProgramsInitial value)  initial,required TResult Function( ProgramsLoading value)  loading,required TResult Function( ProgramsLoaded value)  loaded,required TResult Function( ProgramsFailure value)  failure,}){
final _that = this;
switch (_that) {
case ProgramsInitial():
return initial(_that);case ProgramsLoading():
return loading(_that);case ProgramsLoaded():
return loaded(_that);case ProgramsFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProgramsInitial value)?  initial,TResult? Function( ProgramsLoading value)?  loading,TResult? Function( ProgramsLoaded value)?  loaded,TResult? Function( ProgramsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ProgramsInitial() when initial != null:
return initial(_that);case ProgramsLoading() when loading != null:
return loading(_that);case ProgramsLoaded() when loaded != null:
return loaded(_that);case ProgramsFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Program> programs)?  loaded,TResult Function( AppFailure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProgramsInitial() when initial != null:
return initial();case ProgramsLoading() when loading != null:
return loading();case ProgramsLoaded() when loaded != null:
return loaded(_that.programs);case ProgramsFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Program> programs)  loaded,required TResult Function( AppFailure failure)  failure,}) {final _that = this;
switch (_that) {
case ProgramsInitial():
return initial();case ProgramsLoading():
return loading();case ProgramsLoaded():
return loaded(_that.programs);case ProgramsFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Program> programs)?  loaded,TResult? Function( AppFailure failure)?  failure,}) {final _that = this;
switch (_that) {
case ProgramsInitial() when initial != null:
return initial();case ProgramsLoading() when loading != null:
return loading();case ProgramsLoaded() when loaded != null:
return loaded(_that.programs);case ProgramsFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ProgramsInitial implements ProgramsState {
  const ProgramsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProgramsState.initial()';
}


}




/// @nodoc


class ProgramsLoading implements ProgramsState {
  const ProgramsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProgramsState.loading()';
}


}




/// @nodoc


class ProgramsLoaded implements ProgramsState {
  const ProgramsLoaded({required final  List<Program> programs}): _programs = programs;
  

 final  List<Program> _programs;
 List<Program> get programs {
  if (_programs is EqualUnmodifiableListView) return _programs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_programs);
}


/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramsLoadedCopyWith<ProgramsLoaded> get copyWith => _$ProgramsLoadedCopyWithImpl<ProgramsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramsLoaded&&const DeepCollectionEquality().equals(other._programs, _programs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_programs));

@override
String toString() {
  return 'ProgramsState.loaded(programs: $programs)';
}


}

/// @nodoc
abstract mixin class $ProgramsLoadedCopyWith<$Res> implements $ProgramsStateCopyWith<$Res> {
  factory $ProgramsLoadedCopyWith(ProgramsLoaded value, $Res Function(ProgramsLoaded) _then) = _$ProgramsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Program> programs
});




}
/// @nodoc
class _$ProgramsLoadedCopyWithImpl<$Res>
    implements $ProgramsLoadedCopyWith<$Res> {
  _$ProgramsLoadedCopyWithImpl(this._self, this._then);

  final ProgramsLoaded _self;
  final $Res Function(ProgramsLoaded) _then;

/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? programs = null,}) {
  return _then(ProgramsLoaded(
programs: null == programs ? _self._programs : programs // ignore: cast_nullable_to_non_nullable
as List<Program>,
  ));
}


}

/// @nodoc


class ProgramsFailure implements ProgramsState {
  const ProgramsFailure({required this.failure});
  

 final  AppFailure failure;

/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramsFailureCopyWith<ProgramsFailure> get copyWith => _$ProgramsFailureCopyWithImpl<ProgramsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramsFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ProgramsState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ProgramsFailureCopyWith<$Res> implements $ProgramsStateCopyWith<$Res> {
  factory $ProgramsFailureCopyWith(ProgramsFailure value, $Res Function(ProgramsFailure) _then) = _$ProgramsFailureCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ProgramsFailureCopyWithImpl<$Res>
    implements $ProgramsFailureCopyWith<$Res> {
  _$ProgramsFailureCopyWithImpl(this._self, this._then);

  final ProgramsFailure _self;
  final $Res Function(ProgramsFailure) _then;

/// Create a copy of ProgramsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ProgramsFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of ProgramsState
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
