import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/bloc/household_bloc.dart';
import 'package:shipit_golden_app/features/household/bloc/household_event.dart';
import 'package:shipit_golden_app/features/household/bloc/household_state.dart';

class AddMemberDialog {
  static Future<void> show(BuildContext context) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final bloc = context.read<HouseholdBloc>();

    return showDialog<void>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: AppDialog(
          title: 'Add Member',
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameController,
                  label: 'Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSpacing.space3),
                AppTextField(
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            AppButton.secondary(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
            BlocBuilder<HouseholdBloc, dynamic>(
              builder: (context, state) {
                final isLoading = state is HouseholdLoading;
                return AppButton.primary(
                  label: 'Add',
                  onPressed: isLoading
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            context.read<HouseholdBloc>().add(
                              HouseholdMemberAdded(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                  state: isLoading
                      ? AppButtonState.loading
                      : AppButtonState.default_,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
