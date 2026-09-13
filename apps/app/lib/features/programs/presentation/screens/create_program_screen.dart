import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_state.dart';

/// Full-screen create-program form (PC-002).
///
/// Wires the [ProgramCreateBloc] and delegates rendering to
/// [ProgramCreateView] so tests can pump the view under an injected bloc.
class ProgramCreateScreen extends StatelessWidget {
  const ProgramCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgramCreateBloc(),
      child: const ProgramCreateView(),
    );
  }
}

class ProgramCreateView extends StatefulWidget {
  const ProgramCreateView({super.key});

  @override
  State<ProgramCreateView> createState() => _ProgramCreateViewState();
}

class _ProgramCreateViewState extends State<ProgramCreateView> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _startDateFocusNode = FocusNode();
  final _endDateFocusNode = FocusNode();

  DateTime? _startDate;
  DateTime? _endDate;

  /// Per-field errors, attributed to the failing field only. `Form.validate()`
  /// runs every field's validator at once, which would flag sibling fields on a
  /// blank submit; the create form instead validates stage by stage in
  /// name → start → end order so exactly the first failing field reports.
  String? _nameError;
  String? _startError;
  String? _endError;

  @override
  void initState() {
    super.initState();
    // AppTextField exposes no `autofocus`, so the name field claims initial
    // focus once the first frame has laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameFocusNode.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    super.dispose();
  }

  /// Recomputes the end-date error against the current selections (PC-002:
  /// strict `endDate.isAfter(startDate)`, equal dates fail).
  String? _recomputeEndError() {
    if (_endDate == null) return 'Select an end date.';
    if (_startDate == null) return 'Select a start date first.';
    if (!_endDate!.isAfter(_startDate!)) {
      return 'End date must be after the start date.';
    }
    return null;
  }

  void _submit(ProgramCreateBloc bloc) {
    // Stage 1: name. A blank submit reports on the name field only.
    final nameError = _nameController.text.trim().isEmpty
        ? 'Program name is required.'
        : null;
    if (nameError != null) {
      setState(() => _nameError = nameError);
      FocusScope.of(context).requestFocus(_nameFocusNode);
      return;
    }

    // Stage 2: dates. With a valid name, start reports only when both dates
    // are empty; otherwise the end field carries the attribution for the
    // missing/out-of-order end date (PC-002 per-field error routing).
    final startError = _startDate == null && _endDate == null
        ? 'Select a start date.'
        : null;
    final endError = _recomputeEndError();
    setState(() {
      _nameError = null;
      _startError = startError;
      _endError = endError;
    });
    if (_startDate == null) {
      FocusScope.of(context).requestFocus(_startDateFocusNode);
      return;
    }
    if (endError != null) {
      FocusScope.of(context).requestFocus(_endDateFocusNode);
      return;
    }

    bloc.add(
      ProgramCreateSubmitted(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProgramCreateBloc, ProgramCreateState>(
      listener: (context, state) {
        if (state is ProgramCreateCompleted && context.mounted) {
          context.pop(true);
        }
      },
      child: BlocBuilder<ProgramCreateBloc, ProgramCreateState>(
        builder: (context, state) {
          final isSubmitting = state is ProgramCreateSubmitting;
          final submitError = state is ProgramCreateFailure
              ? state.submitError
              : null;

          return Scaffold(
            appBar: AppBar(title: const Text('Create Program')),
            body: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.space.s4),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.layout.maxWidth.form,
                  ),
                  child: AppCard(
                    padding: EdgeInsets.all(context.space.s5),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (submitError != null) ...[
                            AppInlineAlert.error(
                              title: 'Could not create program',
                              message: submitError.userMessage,
                              onDismiss: () => context
                                  .read<ProgramCreateBloc>()
                                  .add(const ProgramCreateErrorDismissed()),
                            ),
                            SizedBox(height: context.space.s4),
                          ],
                          AppTextField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            label: 'Program name',
                            hint: 'e.g. Summer Camp',
                            semanticLabel: const Key('program_create_name'),
                            errorText: _nameError,
                            onChanged: (_) {
                              if (_nameError != null) {
                                setState(() => _nameError = null);
                              }
                            },
                          ),
                          SizedBox(height: context.space.s3),
                          AppTextField(
                            controller: _descriptionController,
                            label: 'Description',
                            hint: 'Optional',
                            maxLines: 3,
                            semanticLabel: const Key(
                              'program_create_description',
                            ),
                          ),
                          SizedBox(height: context.space.s4),
                          Focus(
                            key: const Key('program_create_start_field'),
                            focusNode: _startDateFocusNode,
                            child: AppDatePicker(
                              label: 'Start date',
                              mode: AppDatePickerMode.single,
                              presets: const [],
                              allowClear: true,
                              value: _startDate,
                              errorText: _startError,
                              onChanged: (value) => setState(() {
                                _startDate = value;
                                _startError = null;
                                if (_endError != null) {
                                  _endError = _recomputeEndError();
                                }
                              }),
                              semanticLabel: const Key('program_create_start'),
                            ),
                          ),
                          SizedBox(height: context.space.s3),
                          Focus(
                            key: const Key('program_create_end_field'),
                            focusNode: _endDateFocusNode,
                            child: AppDatePicker(
                              label: 'End date',
                              mode: AppDatePickerMode.single,
                              presets: const [],
                              allowClear: true,
                              value: _endDate,
                              errorText: _endError,
                              onChanged: (value) => setState(() {
                                _endDate = value;
                                _endError = _recomputeEndError();
                              }),
                              semanticLabel: const Key('program_create_end'),
                            ),
                          ),
                          SizedBox(height: context.space.s5),
                          AppButton.primary(
                            label: 'Create Program',
                            icon: Icons.add,
                            semanticLabel: const Key('program_create_submit'),
                            state: isSubmitting
                                ? AppButtonState.loading
                                : AppButtonState.base,
                            onPressed: isSubmitting
                                ? null
                                : () => _submit(
                                    context.read<ProgramCreateBloc>(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
