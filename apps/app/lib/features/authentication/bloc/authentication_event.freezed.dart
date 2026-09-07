// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent()';
}


}

/// @nodoc
class $AuthenticationEventCopyWith<$Res>  {
$AuthenticationEventCopyWith(AuthenticationEvent _, $Res Function(AuthenticationEvent) __);
}


/// Adds pattern-matching-related methods to [AuthenticationEvent].
extension AuthenticationEventPatterns on AuthenticationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthenticationStarted value)?  started,TResult Function( AuthenticationLoginRequested value)?  loginRequested,TResult Function( AuthenticationRegisterRequested value)?  registerRequested,TResult Function( AuthenticationVerifyRegistrationCode value)?  verifyRegistrationCode,TResult Function( AuthenticationLogoutRequested value)?  logoutRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthenticationStarted() when started != null:
return started(_that);case AuthenticationLoginRequested() when loginRequested != null:
return loginRequested(_that);case AuthenticationRegisterRequested() when registerRequested != null:
return registerRequested(_that);case AuthenticationVerifyRegistrationCode() when verifyRegistrationCode != null:
return verifyRegistrationCode(_that);case AuthenticationLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthenticationStarted value)  started,required TResult Function( AuthenticationLoginRequested value)  loginRequested,required TResult Function( AuthenticationRegisterRequested value)  registerRequested,required TResult Function( AuthenticationVerifyRegistrationCode value)  verifyRegistrationCode,required TResult Function( AuthenticationLogoutRequested value)  logoutRequested,}){
final _that = this;
switch (_that) {
case AuthenticationStarted():
return started(_that);case AuthenticationLoginRequested():
return loginRequested(_that);case AuthenticationRegisterRequested():
return registerRequested(_that);case AuthenticationVerifyRegistrationCode():
return verifyRegistrationCode(_that);case AuthenticationLogoutRequested():
return logoutRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthenticationStarted value)?  started,TResult? Function( AuthenticationLoginRequested value)?  loginRequested,TResult? Function( AuthenticationRegisterRequested value)?  registerRequested,TResult? Function( AuthenticationVerifyRegistrationCode value)?  verifyRegistrationCode,TResult? Function( AuthenticationLogoutRequested value)?  logoutRequested,}){
final _that = this;
switch (_that) {
case AuthenticationStarted() when started != null:
return started(_that);case AuthenticationLoginRequested() when loginRequested != null:
return loginRequested(_that);case AuthenticationRegisterRequested() when registerRequested != null:
return registerRequested(_that);case AuthenticationVerifyRegistrationCode() when verifyRegistrationCode != null:
return verifyRegistrationCode(_that);case AuthenticationLogoutRequested() when logoutRequested != null:
return logoutRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String email,  String password)?  loginRequested,TResult Function( String email)?  registerRequested,TResult Function( String accountRequestId,  String verificationCode,  String password,  String email)?  verifyRegistrationCode,TResult Function()?  logoutRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthenticationStarted() when started != null:
return started();case AuthenticationLoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password);case AuthenticationRegisterRequested() when registerRequested != null:
return registerRequested(_that.email);case AuthenticationVerifyRegistrationCode() when verifyRegistrationCode != null:
return verifyRegistrationCode(_that.accountRequestId,_that.verificationCode,_that.password,_that.email);case AuthenticationLogoutRequested() when logoutRequested != null:
return logoutRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String email,  String password)  loginRequested,required TResult Function( String email)  registerRequested,required TResult Function( String accountRequestId,  String verificationCode,  String password,  String email)  verifyRegistrationCode,required TResult Function()  logoutRequested,}) {final _that = this;
switch (_that) {
case AuthenticationStarted():
return started();case AuthenticationLoginRequested():
return loginRequested(_that.email,_that.password);case AuthenticationRegisterRequested():
return registerRequested(_that.email);case AuthenticationVerifyRegistrationCode():
return verifyRegistrationCode(_that.accountRequestId,_that.verificationCode,_that.password,_that.email);case AuthenticationLogoutRequested():
return logoutRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String email,  String password)?  loginRequested,TResult? Function( String email)?  registerRequested,TResult? Function( String accountRequestId,  String verificationCode,  String password,  String email)?  verifyRegistrationCode,TResult? Function()?  logoutRequested,}) {final _that = this;
switch (_that) {
case AuthenticationStarted() when started != null:
return started();case AuthenticationLoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password);case AuthenticationRegisterRequested() when registerRequested != null:
return registerRequested(_that.email);case AuthenticationVerifyRegistrationCode() when verifyRegistrationCode != null:
return verifyRegistrationCode(_that.accountRequestId,_that.verificationCode,_that.password,_that.email);case AuthenticationLogoutRequested() when logoutRequested != null:
return logoutRequested();case _:
  return null;

}
}

}

/// @nodoc


class AuthenticationStarted implements AuthenticationEvent {
  const AuthenticationStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.started()';
}


}




/// @nodoc


class AuthenticationLoginRequested implements AuthenticationEvent {
  const AuthenticationLoginRequested({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationLoginRequestedCopyWith<AuthenticationLoginRequested> get copyWith => _$AuthenticationLoginRequestedCopyWithImpl<AuthenticationLoginRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationLoginRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthenticationEvent.loginRequested(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthenticationLoginRequestedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationLoginRequestedCopyWith(AuthenticationLoginRequested value, $Res Function(AuthenticationLoginRequested) _then) = _$AuthenticationLoginRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$AuthenticationLoginRequestedCopyWithImpl<$Res>
    implements $AuthenticationLoginRequestedCopyWith<$Res> {
  _$AuthenticationLoginRequestedCopyWithImpl(this._self, this._then);

  final AuthenticationLoginRequested _self;
  final $Res Function(AuthenticationLoginRequested) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(AuthenticationLoginRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationRegisterRequested implements AuthenticationEvent {
  const AuthenticationRegisterRequested({required this.email});
  

 final  String email;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationRegisterRequestedCopyWith<AuthenticationRegisterRequested> get copyWith => _$AuthenticationRegisterRequestedCopyWithImpl<AuthenticationRegisterRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationRegisterRequested&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthenticationEvent.registerRequested(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthenticationRegisterRequestedCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationRegisterRequestedCopyWith(AuthenticationRegisterRequested value, $Res Function(AuthenticationRegisterRequested) _then) = _$AuthenticationRegisterRequestedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthenticationRegisterRequestedCopyWithImpl<$Res>
    implements $AuthenticationRegisterRequestedCopyWith<$Res> {
  _$AuthenticationRegisterRequestedCopyWithImpl(this._self, this._then);

  final AuthenticationRegisterRequested _self;
  final $Res Function(AuthenticationRegisterRequested) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthenticationRegisterRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationVerifyRegistrationCode implements AuthenticationEvent {
  const AuthenticationVerifyRegistrationCode({required this.accountRequestId, required this.verificationCode, required this.password, required this.email});
  

 final  String accountRequestId;
 final  String verificationCode;
 final  String password;
 final  String email;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationVerifyRegistrationCodeCopyWith<AuthenticationVerifyRegistrationCode> get copyWith => _$AuthenticationVerifyRegistrationCodeCopyWithImpl<AuthenticationVerifyRegistrationCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationVerifyRegistrationCode&&(identical(other.accountRequestId, accountRequestId) || other.accountRequestId == accountRequestId)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.password, password) || other.password == password)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,accountRequestId,verificationCode,password,email);

@override
String toString() {
  return 'AuthenticationEvent.verifyRegistrationCode(accountRequestId: $accountRequestId, verificationCode: $verificationCode, password: $password, email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthenticationVerifyRegistrationCodeCopyWith<$Res> implements $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationVerifyRegistrationCodeCopyWith(AuthenticationVerifyRegistrationCode value, $Res Function(AuthenticationVerifyRegistrationCode) _then) = _$AuthenticationVerifyRegistrationCodeCopyWithImpl;
@useResult
$Res call({
 String accountRequestId, String verificationCode, String password, String email
});




}
/// @nodoc
class _$AuthenticationVerifyRegistrationCodeCopyWithImpl<$Res>
    implements $AuthenticationVerifyRegistrationCodeCopyWith<$Res> {
  _$AuthenticationVerifyRegistrationCodeCopyWithImpl(this._self, this._then);

  final AuthenticationVerifyRegistrationCode _self;
  final $Res Function(AuthenticationVerifyRegistrationCode) _then;

/// Create a copy of AuthenticationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountRequestId = null,Object? verificationCode = null,Object? password = null,Object? email = null,}) {
  return _then(AuthenticationVerifyRegistrationCode(
accountRequestId: null == accountRequestId ? _self.accountRequestId : accountRequestId // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthenticationLogoutRequested implements AuthenticationEvent {
  const AuthenticationLogoutRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationLogoutRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthenticationEvent.logoutRequested()';
}


}




// dart format on
