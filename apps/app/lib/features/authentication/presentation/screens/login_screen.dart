import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_state.dart';

/// Which flow the [AuthScreen] is presenting.
enum AuthScreenMode { login, register }

class LoginScreen extends StatelessWidget {
  final AuthenticationBloc authBloc;
  final AuthScreenMode initialMode;

  const LoginScreen({
    super.key,
    required this.authBloc,
    this.initialMode = AuthScreenMode.login,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>.value(
      value: authBloc,
      child: _AuthScreen(mode: initialMode),
    );
  }
}

class _AuthScreen extends StatefulWidget {
  final AuthScreenMode mode;
  const _AuthScreen({required this.mode});

  @override
  State<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<_AuthScreen> {
  late AuthScreenMode _mode;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _accountRequestId;
  String? _failureMessage;

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  bool get _isRegister => _mode == AuthScreenMode.register;

  void _toggleMode() {
    setState(() {
      _mode = _isRegister ? AuthScreenMode.login : AuthScreenMode.register;
      _accountRequestId = null;
      _failureMessage = null;
    });
  }

  void _dismissFailure() {
    setState(() => _failureMessage = null);
  }

  void _submit(AuthenticationBloc bloc) {
    if (_isRegister) {
      if (_accountRequestId == null) {
        if (_formKey.currentState!.validate()) {
          bloc.add(
            AuthenticationRegisterRequested(
              email: _emailController.text.trim(),
            ),
          );
        }
      } else {
        bloc.add(
          AuthenticationVerifyRegistrationCode(
            accountRequestId: _accountRequestId!,
            verificationCode: _codeController.text.trim(),
            password: _passwordController.text,
            email: _emailController.text.trim(),
          ),
        );
      }
    } else if (_formKey.currentState!.validate()) {
      bloc.add(
        AuthenticationLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final register = _isRegister;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          context.go('/household');
        } else if (state is AuthenticationFailure) {
          setState(() => _failureMessage = state.failure.userMessage);
        } else if (state is AuthenticationRegistrationCodeSent) {
          _accountRequestId = state.accountRequestId;
          setState(() => _failureMessage = null);
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.space.s4),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.layout.maxWidth.form,
                ),
                child: AppCard(
                  padding: EdgeInsets.all(context.space.s5),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (register) ...[
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                              final submitting =
                                  state is AuthenticationLoading ||
                                  state is AuthenticationRegistrationSubmitting;
                              return Row(
                                children: [
                                  AppIconButton(
                                    icon: Icons.arrow_back,
                                    tooltip: 'Back to sign in',
                                    state: submitting
                                        ? AppButtonState.disabled
                                        : AppButtonState.base,
                                    onPressed: submitting
                                        ? null
                                        : () => _toggleMode(),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: context.space.s2),
                        ],
                        Text(
                          FlavorConfig.appName,
                          style: context.text.headline.medium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.space.s5),
                        if (_failureMessage != null) ...[
                          AppInlineAlert.error(
                            title: _isRegister
                                ? 'Registration Failed'
                                : 'Sign In Failed',
                            message: _failureMessage,
                            actionLabel: 'Retry',
                            onAction: () => _submit(context.read()),
                            onDismiss: _dismissFailure,
                          ),
                          SizedBox(height: context.space.s5),
                        ],
                        if (register && _accountRequestId == null)
                          Text(
                            'Enter your email to receive a verification code',
                            style: context.text.body.medium.copyWith(
                              color: context.color.fg.secondary,
                            ),
                          )
                        else if (register)
                          Text(
                            'Enter the code sent to "${_emailController.text}" '
                            'and choose a password',
                            style: context.text.body.medium.copyWith(
                              color: context.color.fg.secondary,
                            ),
                          ),
                        SizedBox(height: context.space.s5),
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.space.s3),
                        if (register && _accountRequestId == null)
                          _buildRequestCodeFields()
                        else
                          _buildCredentialsFields(register),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCodeFields() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final loading =
            state is AuthenticationLoading ||
            state is AuthenticationRegistrationSubmitting;
        return AppButton.primary(
          label: 'Request Verification Code',
          state: loading ? AppButtonState.loading : AppButtonState.base,
          onPressed: loading ? null : () => _submit(context.read()),
        );
      },
    );
  }

  Widget _buildCredentialsFields(bool register) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final loading =
            state is AuthenticationLoading ||
            state is AuthenticationRegistrationSubmitting;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (register) ...[
              AppTextField(
                controller: _codeController,
                label: 'Verification Code',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Code is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.space.s3),
            ],
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            SizedBox(height: context.space.s5),
            AppButton.primary(
              label: register ? 'Create Account' : 'Sign In',
              state: loading ? AppButtonState.loading : AppButtonState.base,
              onPressed: loading ? null : () => _submit(context.read()),
            ),
            SizedBox(height: context.space.s3),
            AppTextButton(
              label: register
                  ? 'Already have an account? Sign in'
                  : 'New here? Create an account',
              state: loading ? AppButtonState.disabled : AppButtonState.base,
              onPressed: loading ? null : _toggleMode,
            ),
            if (!register)
              Padding(
                padding: EdgeInsets.only(top: context.space.s1),
                child: Text(
                  'Forgot password: DESIGN_PENDING',
                  style: context.text.body.small.copyWith(
                    color: context.color.fg.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }
}
