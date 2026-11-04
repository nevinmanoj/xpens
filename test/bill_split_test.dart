import 'package:flutter_test/flutter_test.dart';
import 'package:xpens/services/providers/BillSplitProvider.dart';
import 'package:xpens/shared/dataModals/billSplitModels.dart';

int sum(Map<String, int> m) => m.values.fold(0, (a, b) => a + b);

BillItem item(int price, SplitMode mode, Map<String, num> weights) => BillItem(
    id: "i", name: "x", pricePaise: price, mode: mode, weights: weights);

void main() {
  group("allocate", () {
    test("₹100 three ways sums exactly, extra paisa to the first", () {
      final r = allocate(10000, {"a": 1, "b": 1, "c": 1});
      expect(r, {"a": 3334, "b": 3333, "c": 3333});
    });

    test("always sums to the total", () {
      for (final total in [1, 7, 999, 10001, 123457]) {
        for (final w in [
          {"a": 1, "b": 2, "c": 3},
          {"a": 33.33, "b": 33.33, "c": 33.34},
          {"a": 1, "b": 1, "c": 1, "d": 1, "e": 1, "f": 1, "g": 1},
        ]) {
          expect(sum(allocate(total, w)), total, reason: "$total $w");
        }
      }
    });

    test("negative totals (discounts) split too", () {
      final r = allocate(-1000, {"a": 1, "b": 1, "c": 1});
      expect(sum(r), -1000);
      expect(r["a"], -334);
    });

    test("ignores zero weights", () {
      expect(allocate(1000, {"a": 1, "b": 0}), {"a": 1000});
      expect(allocate(1000, {}), isEmpty);
    });
  });

  group("splitItem", () {
    test("equal", () {
      expect(splitItem(item(30000, SplitMode.equal, {"a": 1, "b": 1})),
          {"a": 15000, "b": 15000});
    });

    test("shares 2:1", () {
      expect(splitItem(item(30000, SplitMode.shares, {"a": 2, "b": 1})),
          {"a": 20000, "b": 10000});
    });

    test("exact must add up to the price", () {
      expect(splitItem(item(30000, SplitMode.exact, {"a": 10000, "b": 20000})),
          {"a": 10000, "b": 20000});
      final short = item(30000, SplitMode.exact, {"a": 10000, "b": 10000});
      expect(splitItem(short), isNull);
      expect(remaining(short), 10000);
    });

    test("percent must add up to 100", () {
      expect(splitItem(item(20000, SplitMode.percent, {"a": 75, "b": 25})),
          {"a": 15000, "b": 5000});
      expect(splitItem(item(20000, SplitMode.percent, {"a": 75, "b": 30})),
          isNull);
    });

    test("unassigned is invalid", () {
      expect(splitItem(item(100, SplitMode.equal, {})), isNull);
    });
  });

  test("defaultWeights makes every mode valid immediately", () {
    final base = item(10000, SplitMode.equal, {"a": 1, "b": 1, "c": 1});
    for (final mode in SplitMode.values) {
      final converted =
          base.copyWith(mode: mode, weights: defaultWeights(base, mode, []));
      expect(isValidSplit(converted), isTrue, reason: mode.name);
      expect(sum(splitItem(converted)!), 10000, reason: mode.name);
    }
  });

  test("parsePaise", () {
    expect(parsePaise("250"), 25000);
    expect(parsePaise("1,250.50"), 125050);
    expect(parsePaise("-40"), -4000);
    expect(parsePaise("abc"), isNull);
  });

  group("BillSplitProvider", () {
    late BillSplitProvider bill;
    late String a, b;

    setUp(() {
      bill = BillSplitProvider();
      bill.addMe();
      bill.addPerson("Asha");
      a = bill.people[0].id;
      b = bill.people[1].id;
    });

    test("me is first and only added once", () {
      bill.addMe();
      expect(bill.people.where((p) => p.isMe).length, 1);
      expect(bill.people.first.isMe, isTrue);
    });

    test("totals derive from items and survive edits", () {
      final naan = BillItem(id: bill.newId(), name: "Naan", pricePaise: 12000);
      bill.addItem(naan);
      bill.togglePersonOnItem(naan.id, a);
      bill.togglePersonOnItem(naan.id, b);
      expect(bill.totals, {a: 6000, b: 6000});

      // Price edit: the old bug subtracted with the new cost.
      bill.updateItem(bill.items.first.copyWith(pricePaise: 20000));
      expect(bill.totals, {a: 10000, b: 10000});

      bill.togglePersonOnItem(naan.id, b);
      expect(bill.totals, {a: 20000, b: 0});

      // The old removeBillItem crashed here.
      bill.removeItem(naan.id);
      expect(bill.totals, {a: 0, b: 0});
    });

    test("duplicate item names are fine", () {
      bill.addItem(BillItem(id: bill.newId(), name: "Coke", pricePaise: 100));
      bill.addItem(BillItem(id: bill.newId(), name: "Coke", pricePaise: 200));
      expect(bill.billTotal, 300);
    });

    test("removing a person strips them from items", () {
      final id = bill.newId();
      bill.addItem(BillItem(
          id: id, name: "Tea", pricePaise: 1000, weights: {a: 1, b: 1}));
      bill.removePerson(b);
      expect(bill.items.first.weights.keys, [a]);
      expect(bill.totals, {a: 1000});
    });

    test("unassigned items are reported, not counted", () {
      bill.addItem(BillItem(id: bill.newId(), name: "Soup", pricePaise: 500));
      expect(bill.problemItems.length, 1);
      expect(bill.unsettledTotal, 500);
      expect(bill.totals.values.every((v) => v == 0), isTrue);
    });

    test("breakdown lists my items with my share", () {
      final id = bill.newId();
      bill.addItem(BillItem(
          id: id,
          name: "Pizza",
          pricePaise: 30000,
          mode: SplitMode.shares,
          weights: {a: 2, b: 1}));
      final mine = bill.breakdown(a);
      expect(mine.length, 1);
      expect(mine.first.$2, 20000);
    });

    test("name check is case-insensitive", () {
      expect(bill.nameTaken("asha"), isTrue);
      expect(bill.nameTaken("asha", exceptId: b), isFalse);
    });
  });
}
