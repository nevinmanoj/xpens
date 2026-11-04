import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/billSplit/billSplitMain.dart';
import 'package:xpens/services/providers/BillSplitProvider.dart';
import 'package:xpens/shared/dataModals/billSplitModels.dart';

void main() {
  late BillSplitProvider bill;

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: bill,
      child: const MaterialApp(home: BillSplitMain()),
    ));
  }

  /// Two people sharing one ₹100 item, optionally with me on the bill too.
  void seedBill({bool withMe = false}) {
    if (withMe) bill.addMe();
    bill.addPerson("Asha");
    bill.addItem(BillItem(
      id: bill.newId(),
      name: "Naan",
      pricePaise: 10000,
      mode: SplitMode.equal,
      weights: {for (final id in bill.personIds) id: 1},
    ));
  }

  setUp(() => bill = BillSplitProvider());

  testWidgets("Summary button moves to the People tab", (tester) async {
    seedBill();
    await pumpScreen(tester);
    expect(find.text("No people added yet. Tap + to add someone."),
        findsNothing);

    await tester.tap(find.text("Summary"));
    await tester.pumpAndSettle();

    expect(find.text("1 item"), findsOneWidget);
    expect(find.text("Summary"), findsNothing);
    expect(find.byTooltip("Add person"), findsOneWidget);
  });

  testWidgets("People tab offers Add me until I'm on the bill", (tester) async {
    seedBill();
    await pumpScreen(tester);
    await tester.tap(find.text("People"));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, "Add me"));
    await tester.pumpAndSettle();

    expect(bill.me, isNotNull);
    expect(find.widgetWithText(ElevatedButton, "Preview my expense"),
        findsOneWidget);
  });

  testWidgets("Add button adds a person on the People tab", (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text("People"));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), "Ravi");
    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();

    expect(bill.people.map((p) => p.name), ["Ravi"]);
    expect(find.text("No items yet"), findsOneWidget);
  });

  testWidgets("Person card expands to show their items", (tester) async {
    seedBill(withMe: true);
    await pumpScreen(tester);
    await tester.tap(find.text("People"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Asha"));
    await tester.pumpAndSettle();

    expect(find.text("Naan"), findsOneWidget);
  });
}
