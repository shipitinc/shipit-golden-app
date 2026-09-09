import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/features/household/bloc/household_bloc.dart';
import 'package:shipit_golden_app/features/household/data/household_repository.dart';
import 'package:shipit_golden_app/features/household/presentation/widgets/add_member_dialog.dart';

class _MockHouseholdRepository extends Mock implements HouseholdRepository {}

void main() {
  testWidgets('add-member dialog surfaces field-level errors on submit', (
    tester,
  ) async {
    final repository = _MockHouseholdRepository();
    final bloc = HouseholdBloc(repository: repository);
    addTearDown(bloc.close);

    await tester.pumpWidget(
      MaterialApp(
        theme: shipitLightTheme(),
        home: BlocProvider<HouseholdBloc>.value(
          value: bloc,
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: AppButton.primary(
                  label: 'Open dialog',
                  onPressed: () => AddMemberDialog.show(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // GAP-010: the add-member validators now run through the Form and each
    // field renders its own actionable message.
    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Error: Please check this field'), findsNothing);

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Name'),
      'Ada Lovelace',
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Email'),
      'not-an-email',
    );
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // A malformed email is rejected at the field level with a specific message.
    expect(find.text('Name is required'), findsNothing);
    expect(find.text('Email is required'), findsNothing);
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.byType(AppInlineAlert), findsNothing);
  });
}
