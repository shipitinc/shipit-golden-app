// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState()';
}


}

/// @nodoc
class $AuthenticationStateCopyWith<$Res>  {
$AuthenticationStateCopyWith(AuthenticationState _, $Res Function(AuthenticationState) __);
}


/// Adds pattern-matching-related methods to [AuthenticationState].
extension AuthenticationStatePatterns on AuthenticationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthenticationInitial value)?  initial,TResult Function( AuthenticationLoading value)?  loading,TResult Function( AuthenticationAuthenticated value)?  authenticated,TResult Function( AuthenticationUnauthenticated value)?  unauthenticated,TResult Function( AuthenticationFailure value)?  failure,TResult Function( AuthenticationRegistrationCodeSent value)?  registrationCodeSent,TResult Function( AuthenticationRegistrationSubmitting value)?  registrationSubmitting,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthenticationInitial() when initial != null:
return initial(_that);case AuthenticationLoading() when loading != null:
return loading(_that);case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthenticationFailure() when failure != null:
return failure(_that);case AuthenticationRegistrationCodeSent() when registrationCodeSent != null:
return registrationCodeSent(_that);case AuthenticationRegistrationSubmitting() when registrationSubmitting != null:
return registrationSubmitting(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthenticationInitial value)  initial,required TResult Function( AuthenticationLoading value)  loading,required TResult Function( AuthenticationAuthenticated value)  authenticated,required TResult Function( AuthenticationUnauthenticated value)  unauthenticated,required TResult Function( AuthenticationFailure value)  failure,required TResult Function( AuthenticationRegistrationCodeSent value)  registrationCodeSent,required TResult Function( AuthenticationRegistrationSubmitting value)  registrationSubmitting,}){
final _that = this;
switch (_that) {
case AuthenticationInitial():
return initial(_that);case AuthenticationLoading():
return loading(_that);case AuthenticationAuthenticated():
return authenticated(_that);case AuthenticationUnauthenticated():
return unauthenticated(_that);case AuthenticationFailure():
return failure(_that);case AuthenticationRegistrationCodeSent():
return registrationCodeSent(_that);case AuthenticationRegistrationSubmitting():
return registrationSubmitting(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthenticationInitial value)?  initial,TResult? Function( AuthenticationLoading value)?  loading,TResult? Function( AuthenticationAuthenticated value)?  authenticated,TResult? Function( AuthenticationUnauthenticated value)?  unauthenticated,TResult? Function( AuthenticationFailure value)?  failure,TResult? Function( AuthenticationRegistrationCodeSent value)?  registrationCodeSent,TResult? Function( AuthenticationRegistrationSubmitting value)?  registrationSubmitting,}){
final _that = this;
switch (_that) {
case AuthenticationInitial() when initial != null:
return initial(_that);case AuthenticationLoading() when loading != null:
return loading(_that);case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthenticationFailure() when failure != null:
return failure(_that);case AuthenticationRegistrationCodeSent() when registrationCodeSent != null:
return registrationCodeSent(_that);case AuthenticationRegistrationSubmitting() when registrationSubmitting != null:
return registrationSubmitting(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String token,  String email)?  authenticated,TResult Function()?  unauthenticated,TResult Function( AppFailure failure)?  failure,TResult Function( String email,  String accountRequestId)?  registrationCodeSent,TResult Function()?  registrationSubmitting,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthenticationInitial() when initial != null:
return initial();case AuthenticationLoading() when loading != null:
return loading();case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that.token,_that.email);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthenticationFailure() when failure != null:
return failure(_that.failure);case AuthenticationRegistrationCodeSent() when registrationCodeSent != null:
return registrationCodeSent(_that.email,_that.accountRequestId);case AuthenticationRegistrationSubmitting() when registrationSubmitting != null:
return registrationSubmitting();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String token,  String email)  authenticated,required TResult Function()  unauthenticated,required TResult Function( AppFailure failure)  failure,required TResult Function( String email,  String accountRequestId)  registrationCodeSent,required TResult Function()  registrationSubmitting,}) {final _that = this;
switch (_that) {
case AuthenticationInitial():
return initial();case AuthenticationLoading():
return loading();case AuthenticationAuthenticated():
return authenticated(_that.token,_that.email);case AuthenticationUnauthenticated():
return unauthenticated();case AuthenticationFailure():
return failure(_that.failure);case AuthenticationRegistrationCodeSent():
return registrationCodeSent(_that.email,_that.accountRequestId);case AuthenticationRegistrationSubmitting():
return registrationSubmitting();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String token,  String email)?  authenticated,TResult? Function()?  unauthenticated,TResult? Function( AppFailure failure)?  failure,TResult? Function( String email,  String accountRequestId)?  registrationCodeSent,TResult? Function()?  registrationSubmitting,}) {final _that = this;
switch (_that) {
case AuthenticationInitial() when initial != null:
return initial();case AuthenticationLoading() when loading != null:
return loading();case AuthenticationAuthenticated() when authenticated != null:
return authenticated(_that.token,_that.email);case AuthenticationUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthenticationFailure() when failure != null:
return failure(_that.failure);case AuthenticationRegistrationCodeSent() when registrationCodeSent != null:
return registrationCodeSent(_that.email,_that.accountRequestId);case AuthenticationRegistrationSubmitting() when registrationSubmitting != null:
return registrationSubmitting();case _:
  return null;

}
}

}

/// @nodoc


class AuthenticationInitial implements AuthenticationState {
  const AuthenticationInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.initial()';
}


}




/// @nodoc


class AuthenticationLoading implements AuthenticationState {
  const AuthenticationLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.loading()';
}


}




/// @nodoc


class AuthenticationAuthenticated implements AuthenticationState {
  const AuthenticationAuthenticated({required this.token, required this.email});
  

 final  String token;
 final  String email;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationAuthenticatedCopyWith<AuthenticationAuthenticated> get copyWith => _$AuthenticationAuthenticatedCopyWithImpl<AuthenticationAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationAuthenticated&&(identical(other.token, token) || other.token == token)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,token,email);

@override
String toString() {
  return 'AuthenticationState.authenticated(token: $token, email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthenticationAuthenticatedCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationAuthenticatedCopyWith(AuthenticationAuthenticated value, $Res Function(AuthenticationAuthenticated) _then) = _$AuthenticationAuthenticatedCopyWithImpl;
@useResult
$Res call({
 String token, String email
});




}
/// @nodoc
class _$AuthenticationAuthenticatedCopyWithImpl<$Res>
    implements $AuthenticationAuthenticatedCopyWith<$Res> {
  _$AuthenticationAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthenticationAuthenticated _self;
  final $Res Function(AuthenticationAuthenticated) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,Object? email = null,}) {
  return _then(AuthenticationAuthenticated(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationUnauthenticated implements AuthenticationState {
  const AuthenticationUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.unauthenticated()';
}


}




/// @nodoc


class AuthenticationFailure implements AuthenticationState {
  const AuthenticationFailure({required this.failure});
  

 final  AppFailure failure;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationFailureCopyWith<AuthenticationFailure> get copyWith => _$AuthenticationFailureCopyWithImpl<AuthenticationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'AuthenticationState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AuthenticationFailureCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationFailureCopyWith(AuthenticationFailure value, $Res Function(AuthenticationFailure) _then) = _$AuthenticationFailureCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$AuthenticationFailureCopyWithImpl<$Res>
    implements $AuthenticationFailureCopyWith<$Res> {
  _$AuthenticationFailureCopyWithImpl(this._self, this._then);

  final AuthenticationFailure _self;
  final $Res Function(AuthenticationFailure) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(AuthenticationFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc


class AuthenticationRegistrationCodeSent implements AuthenticationState {
  const AuthenticationRegistrationCodeSent({required this.email, required this.accountRequestId});
  

 final  String email;
 final  String accountRequestId;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationRegistrationCodeSentCopyWith<AuthenticationRegistrationCodeSent> get copyWith => _$AuthenticationRegistrationCodeSentCopyWithImpl<AuthenticationRegistrationCodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationRegistrationCodeSent&&(identical(other.email, email) || other.email == email)&&(identical(other.accountRequestId, accountRequestId) || other.accountRequestId == accountRequestId));
}


@override
int get hashCode => Object.hash(runtimeType,email,accountRequestId);

@override
String toString() {
  return 'AuthenticationState.registrationCodeSent(email: $email, accountRequestId: $accountRequestId)';
}


}

/// @nodoc
abstract mixin class $AuthenticationRegistrationCodeSentCopyWith<$Res> implements $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationRegistrationCodeSentCopyWith(AuthenticationRegistrationCodeSent value, $Res Function(AuthenticationRegistrationCodeSent) _then) = _$AuthenticationRegistrationCodeSentCopyWithImpl;
@useResult
$Res call({
 String email, String accountRequestId
});




}
/// @nodoc
class _$AuthenticationRegistrationCodeSentCopyWithImpl<$Res>
    implements $AuthenticationRegistrationCodeSentCopyWith<$Res> {
  _$AuthenticationRegistrationCodeSentCopyWithImpl(this._self, this._then);

  final AuthenticationRegistrationCodeSent _self;
  final $Res Function(AuthenticationRegistrationCodeSent) _then;

/// Create a copy of AuthenticationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? accountRequestId = null,}) {
  return _then(AuthenticationRegistrationCodeSent(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,accountRequestId: null == accountRequestId ? _self.accountRequestId : accountRequestId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationRegistrationSubmitting implements AuthenticationState {
  const AuthenticationRegistrationSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationRegistrationSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationState.registrationSubmitting()';
}


}




// dart format on
