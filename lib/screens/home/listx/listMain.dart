import 'package:flutter/material.dart';

import 'package:xpens/screens/home/listx/listStream/listStream.dart';
import 'package:xpens/shared/constants.dart';

/// List tab: search + filter chips on top, date-grouped expenses below.
class listx extends StatefulWidget {
  const listx({super.key});

  @override
  State<listx> createState() => _listxState();
}

class _listxState extends State<listx> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  String _query = "";
  String _queryType = "itemName"; // or "remarks"
  String? _location; // null = all
  String _order = 'new'; // 'new' | 'old' | 'added'

  bool get _hasFilters => _query.isNotEmpty || _location != null;

  Map get _filter => {
        'order': _order,
        if (_location != null) 'location': _location,
        if (_query.isNotEmpty) 'query': _query,
        if (_query.isNotEmpty) 'queryType': _queryType,
      };

  void _update(VoidCallback change) {
    setState(change);
    if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(0);
  }

  void _clearAll() {
    _searchCtrl.clear();
    _update(() {
      _query = "";
      _location = null;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          controller: _searchCtrl,
          queryType: _queryType,
          onQueryChanged: (v) => _update(() => _query = v.trim()),
          onQueryTypeToggled: () => _update(() =>
              _queryType = _queryType == "itemName" ? "remarks" : "itemName"),
        ),
        _FilterBar(
          location: _location,
          order: _order,
          onLocation: (v) => _update(() => _location = v),
          onOrder: (v) => _update(() => _order = v),
        ),
        const Divider(height: 1),
        Expanded(
          child: ExpenseList(
            filter: _filter,
            hasFilters: _hasFilters,
            onClearFilters: _clearAll,
            controller: _scrollCtrl,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatefulWidget {
  final TextEditingController controller;
  final String queryType;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onQueryTypeToggled;

  const _Header({
    required this.controller,
    required this.queryType,
    required this.onQueryChanged,
    required this.onQueryTypeToggled,
  });

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    final byName = widget.queryType == "itemName";
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      color: primaryAppColor,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Expenses",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.search, color: Colors.white60, size: 22),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    onChanged: (v) {
                      setState(() {});
                      widget.onQueryChanged(v);
                    },
                    textInputAction: TextInputAction.search,
                    cursorColor: secondaryAppColor,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: byName ? "Search by item" : "Search by remark",
                      hintStyle: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                if (hasText)
                  IconButton(
                    tooltip: "Clear search",
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() {});
                      widget.onQueryChanged("");
                    },
                  ),
                // Search scope toggle: Item <-> Remark
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Material(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: widget.onQueryTypeToggled,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              byName ? "Item" : "Remark",
                              style: const TextStyle(
                                  color: secondaryAppColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.swap_vert,
                                color: secondaryAppColor, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String? location;
  final String order;
  final ValueChanged<String?> onLocation;
  final ValueChanged<String> onOrder;

  const _FilterBar({
    required this.location,
    required this.order,
    required this.onLocation,
    required this.onOrder,
  });

  static const _orders = {
    'new': ("Newest", Icons.arrow_downward),
    'old': ("Oldest", Icons.arrow_upward),
    'added': ("Recently added", Icons.history),
  };

  /// Stored values keep their original spelling; only the label is fixed.
  static String _label(String loc) => loc == "Personel" ? "Personal" : loc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 52,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              children: [
                _chip("All", location == null, () => onLocation(null)),
                for (final loc in locationList)
                  _chip(_label(loc), location == loc,
                      () => onLocation(location == loc ? null : loc)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: "Sort",
            initialValue: order,
            onSelected: onOrder,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              for (final e in _orders.entries)
                PopupMenuItem(
                  value: e.key,
                  child: Row(children: [
                    Icon(e.value.$2, size: 18, color: Colors.black54),
                    const SizedBox(width: 10),
                    Text(e.value.$1),
                  ]),
                ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                Icon(_orders[order]!.$2, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
                Text(_orders[order]!.$1,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black87)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
          showCheckmark: false,
          backgroundColor: Colors.grey.shade200,
          selectedColor: primaryAppColor,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
        ),
      ),
    );
  }
}
