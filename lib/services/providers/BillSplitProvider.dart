import 'package:flutter/foundation.dart';

import '../../shared/dataModals/billSplitModels.dart';

/// In-memory bill split state. Registered once at the app root, so the bill
/// survives leaving the screen and is lost only when the app closes.
///
/// Totals are always derived from [items]; nothing is cached, so edits can
/// never leave a person's total out of sync.
class BillSplitProvider extends ChangeNotifier {
  final List<Person> _people = [];
  final List<BillItem> _items = [];
  int _nextId = 0;

  List<Person> get people => List.unmodifiable(_people);
  List<BillItem> get items => List.unmodifiable(_items);
  List<String> get personIds => [for (final p in _people) p.id];

  Person? get me {
    for (final p in _people) {
      if (p.isMe) return p;
    }
    return null;
  }

  Person? personById(String id) {
    for (final p in _people) {
      if (p.id == id) return p;
    }
    return null;
  }

  String newId() => "${_nextId++}";

  // ---- People --------------------------------------------------------------

  bool nameTaken(String name, {String? exceptId}) => _people.any((p) =>
      p.id != exceptId && p.name.toLowerCase() == name.trim().toLowerCase());

  void addPerson(String name) {
    _people.add(Person(id: newId(), name: name.trim()));
    notifyListeners();
  }

  void addMe() {
    if (me != null) return;
    _people.insert(0, Person(id: newId(), name: "Me", isMe: true));
    notifyListeners();
  }

  void renamePerson(String id, String name) {
    final i = _people.indexWhere((p) => p.id == id);
    if (i == -1) return;
    _people[i] = _people[i].copyWith(name: name.trim());
    notifyListeners();
  }

  /// Removes the person and their weights from every item. Items they were
  /// on become partially or fully unassigned and show up as needing review.
  void removePerson(String id) {
    _people.removeWhere((p) => p.id == id);
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].weights.containsKey(id)) {
        _items[i] =
            _items[i].copyWith(weights: Map.of(_items[i].weights)..remove(id));
      }
    }
    notifyListeners();
  }

  // ---- Items ---------------------------------------------------------------

  void addItem(BillItem item) {
    _items.add(item);
    notifyListeners();
  }

  void addItems(Iterable<BillItem> items) {
    _items.addAll(items);
    notifyListeners();
  }

  void updateItem(BillItem item) {
    final i = _items.indexWhere((e) => e.id == item.id);
    if (i == -1) return;
    _items[i] = item;
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Quick tap assignment. Only meaningful for equal-mode items.
  void togglePersonOnItem(String itemId, String personId) {
    final i = _items.indexWhere((e) => e.id == itemId);
    if (i == -1 || _items[i].mode != SplitMode.equal) return;
    final weights = Map.of(_items[i].weights);
    if (weights.containsKey(personId)) {
      weights.remove(personId);
    } else {
      weights[personId] = 1;
    }
    _items[i] = _items[i].copyWith(weights: weights);
    notifyListeners();
  }

  /// Splits the item equally across everyone.
  void assignEveryone(String itemId) {
    final i = _items.indexWhere((e) => e.id == itemId);
    if (i == -1) return;
    _items[i] = _items[i].copyWith(
        mode: SplitMode.equal, weights: {for (final id in personIds) id: 1});
    notifyListeners();
  }

  void clear() {
    _people.clear();
    _items.clear();
    notifyListeners();
  }

  // ---- Derived -------------------------------------------------------------

  int get billTotal => _items.fold(0, (a, e) => a + e.pricePaise);

  /// Items that are unassigned or whose exact/percent split doesn't add up.
  List<BillItem> get problemItems => [
        for (final e in _items)
          if (!isValidSplit(e)) e
      ];

  int get unsettledTotal => problemItems.fold(0, (a, e) => a + e.pricePaise);

  /// Every person's total in paise, computed in one pass over the items.
  Map<String, int> get totals {
    final result = {for (final id in personIds) id: 0};
    for (final item in _items) {
      final shares = splitItem(item);
      if (shares == null) continue;
      shares.forEach((id, paise) {
        if (result.containsKey(id)) result[id] = result[id]! + paise;
      });
    }
    return result;
  }

  /// The items [personId] has a share in, with that share.
  List<(BillItem, int)> breakdown(String personId) => [
        for (final item in _items)
          if (splitItem(item)?[personId] case final paise?) (item, paise)
      ];
}
