import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/formFields.dart'
    show fieldDecoration;
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import 'GroupDetail.dart';

/// Totals for one group tag.
class GroupStats {
  final String name;
  double total = 0;
  int count = 0;
  late DateTime first;
  late DateTime last;
  GroupStats(this.name);

  String get span {
    final f = DateUtils.dateOnly(first), l = DateUtils.dateOnly(last);
    final thisYear = l.year == DateTime.now().year;
    if (f == l) return DateFormat(thisYear ? "d MMM" : "d MMM y").format(f);
    final left = DateFormat(
            f.year != l.year ? "d MMM y" : (f.month == l.month ? "d" : "d MMM"))
        .format(f);
    return "$left – ${DateFormat(thisYear ? "d MMM" : "d MMM y").format(l)}";
  }
}

bool _isGroup(dynamic g) => g is String && g.trim().isNotEmpty && g != "none";

/// Every group tag in [docs] with its totals.
List<GroupStats> groupStats(List docs) {
  final map = <String, GroupStats>{};
  for (final doc in docs) {
    final name = doc['group'];
    if (!_isGroup(name)) continue;
    final d = DateTime.parse(doc['date']);
    final s = map.putIfAbsent(
        name,
        () => GroupStats(name)
          ..first = d
          ..last = d);
    s.total += costOf(doc);
    s.count++;
    if (d.isBefore(s.first)) s.first = d;
    if (d.isAfter(s.last)) s.last = d;
  }
  return map.values.toList();
}

enum GroupSort { latest, oldest, highest, lowest, nameAz, nameZa }

extension on GroupSort {
  String get label => switch (this) {
        GroupSort.latest => "Most recent",
        GroupSort.oldest => "Oldest",
        GroupSort.highest => "Highest total",
        GroupSort.lowest => "Lowest total",
        GroupSort.nameAz => "Name A–Z",
        GroupSort.nameZa => "Name Z–A",
      };

  int compare(GroupStats a, GroupStats b) => switch (this) {
        GroupSort.latest => b.last.compareTo(a.last),
        GroupSort.oldest => a.first.compareTo(b.first),
        GroupSort.highest => b.total.compareTo(a.total),
        GroupSort.lowest => a.total.compareTo(b.total),
        GroupSort.nameAz =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        GroupSort.nameZa =>
          b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      };
}

/// Groups: every group tag with its total. Tap one for its report.
class GroupReportMain extends StatefulWidget {
  const GroupReportMain({super.key});

  @override
  State<GroupReportMain> createState() => _GroupReportMainState();
}

class _GroupReportMainState extends State<GroupReportMain> {
  GroupSort _sort = GroupSort.latest;
  String _query = "";

  @override
  Widget build(BuildContext context) {
    final docs = Provider.of<UserInfoProvider>(context).docs;
    final all = groupStats(docs);
    final q = _query.trim().toLowerCase();
    final groups = all
        .where((g) => q.isEmpty || g.name.toLowerCase().contains(q))
        .toList()
      ..sort(_sort.compare);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        title: const Text("Groups"),
        actions: [
          PopupMenuButton<GroupSort>(
            tooltip: "Sort",
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (s) => setState(() => _sort = s),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              for (final s in GroupSort.values)
                PopupMenuItem(value: s, child: Text(s.label)),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: all.isEmpty
            ? const _Empty(
                icon: Icons.sell_outlined,
                title: "No groups yet",
                message:
                    "Turn on \"Add to a group\" when adding an expense to track a trip or event here.",
              )
            : ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    cursorColor: primaryAppColor,
                    decoration: fieldDecoration(
                      hint: "Search groups",
                      prefix: const Icon(Icons.search, size: 20),
                    ).copyWith(fillColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
                    child: Text(
                      "${groups.length} ${groups.length == 1 ? "group" : "groups"} · ${_sort.label.toLowerCase()}",
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ),
                  if (groups.isEmpty)
                    _Empty(
                      icon: Icons.search_off,
                      title: "No matching groups",
                      message: "Nothing called \"${_query.trim()}\".",
                    ),
                  for (final g in groups) _GroupTile(stats: g),
                ],
              ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final GroupStats stats;
  const _GroupTile({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => GroupDetail(group: stats.name)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: secondaryAppColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sell_outlined,
                      size: 20, color: Color(0xFFB25E00)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stats.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        "${stats.count} ${stats.count == 1 ? "expense" : "expenses"} · ${stats.span}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(formatRupee(stats.total),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  const _Empty(
      {required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
