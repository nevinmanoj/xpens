import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/utils/filterFunction.dart';

/// Shared building blocks for the Expense and Points forms.

const _fieldRadius = BorderRadius.all(Radius.circular(12));
final _fieldFill = Colors.grey.shade100;

InputDecoration fieldDecoration({String? hint, Widget? prefix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey.shade500),
    filled: true,
    fillColor: _fieldFill,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    prefixIcon: prefix,
    border: const OutlineInputBorder(
        borderRadius: _fieldRadius, borderSide: BorderSide.none),
    focusedBorder: const OutlineInputBorder(
        borderRadius: _fieldRadius,
        borderSide: BorderSide(color: primaryAppColor, width: 1.2)),
    errorBorder: OutlineInputBorder(
        borderRadius: _fieldRadius,
        borderSide: BorderSide(color: Colors.red.shade400)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: _fieldRadius,
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.2)),
  );
}

/// Locations keep their stored spelling; only the label is fixed.
String locationLabel(String loc) => loc == "Personel" ? "Personal" : loc;

class FieldLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const FieldLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Row(
        children: [
          Text(text,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

/// Large amount entry. [prefix] is "₹" for expenses, null for points.
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final bool isRequired;
  final String? prefix;

  const AmountField({
    super.key,
    required this.controller,
    required this.isRequired,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      cursorColor: primaryAppColor,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      validator: (v) {
        final text = (v ?? "").trim();
        if (text.isEmpty) return isRequired ? "Enter an amount" : null;
        return double.tryParse(text) == null ? "Enter a valid number" : null;
      },
      decoration: fieldDecoration(
        hint: "0",
        prefix: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 6),
                child: Text(prefix!,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500)),
              ),
      ).copyWith(
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      ),
    );
  }
}

/// Text field with suggestions drawn from earlier entries' [tag] field.
///
/// Suggestions show as a chip row under the field, in the page's own layout
/// rather than a floating overlay, so they stay visible above the keyboard.
/// Once the keyboard has opened, the field scrolls to the top of the
/// visible area so its chips have the space below it.
/// With [suggestRecent], focusing an empty field lists recent values.
class SuggestField extends StatefulWidget {
  final List docs;
  final String tag;
  final String value;
  final String hint;
  final bool isRequired;
  final bool suggestRecent;
  final bool autofocus;
  final String? avoidValue;
  final ValueChanged<String> onChanged;

  const SuggestField({
    super.key,
    required this.docs,
    required this.tag,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.isRequired = false,
    this.suggestRecent = false,
    this.autofocus = false,
    this.avoidValue,
  });

  @override
  State<SuggestField> createState() => _SuggestFieldState();
}

class _SuggestFieldState extends State<SuggestField>
    with WidgetsBindingObserver {
  static const _max = 8;
  late final _ctrl = TextEditingController(text: widget.value);
  final _focus = FocusNode();
  final _boxKey = GlobalKey();
  bool _hadOptions = false;
  Timer? _settle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focus.addListener(() {
      setState(() {});
      if (_focus.hasFocus) _revealWhenSettled();
    });
  }

  /// Fires on every frame of the keyboard animation; scroll once it stops.
  @override
  void didChangeMetrics() {
    if (_focus.hasFocus) _revealWhenSettled();
  }

  void _revealWhenSettled() {
    _settle?.cancel();
    _settle = Timer(const Duration(milliseconds: 150), _reveal);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settle?.cancel();
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _reveal() {
    final ctx = _boxKey.currentContext;
    if (!mounted || ctx == null || !_focus.hasFocus) return;
    // Put the field at the top of the visible area so the chips (and
    // whatever follows) get all the space between it and the keyboard.
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  bool _usable(dynamic s) =>
      s is String && s.trim().isNotEmpty && s != widget.avoidValue;

  List<String> _options() {
    final query = _ctrl.text.trim().toLowerCase();
    final names = <String>{};
    if (query.isEmpty) {
      if (!widget.suggestRecent) return const [];
      // Provider docs are newest first, so this is most-recent order.
      for (final item in widget.docs) {
        final s = item[widget.tag];
        if (_usable(s)) names.add(s);
        if (names.length >= _max) break;
      }
      return names.toList();
    }
    final matches = applyFilter(
        data: List.of(widget.docs),
        filter: {'query': query, 'queryType': widget.tag});
    for (final item in matches) {
      final s = item[widget.tag];
      if (_usable(s) && s.toLowerCase() != query) names.add(s);
      if (names.length >= _max) break;
    }
    return names.toList();
  }

  void _pick(String option) {
    _ctrl.value = TextEditingValue(
      text: option,
      selection: TextSelection.collapsed(offset: option.length),
    );
    widget.onChanged(option);
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final options = _focus.hasFocus ? _options() : const <String>[];
    // Newly appeared chips may sit under the keyboard; bring them up.
    if (options.isNotEmpty && !_hadOptions) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
    }
    _hadOptions = options.isNotEmpty;

    return Column(
      key: _boxKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _ctrl,
          focusNode: _focus,
          autofocus: widget.autofocus,
          // Flutter scrolls the caret into view when the keyboard opens;
          // keep enough room below it for the chip row too.
          scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          cursorColor: primaryAppColor,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (v) {
            setState(() {});
            widget.onChanged(v);
          },
          validator: widget.isRequired
              ? (v) => (v ?? "").trim().isEmpty ? "This can't be empty" : null
              : null,
          decoration: fieldDecoration(hint: widget.hint),
        ),
        if (options.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => ActionChip(
                  label: Text(options[i]),
                  onPressed: () => _pick(options[i]),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Item category as tappable chips. "Other" (or any name not in [items])
/// reveals a free-text field with suggestions.
class CategoryPicker extends StatelessWidget {
  final List items;
  final String value;
  final List docs;
  final ValueChanged<String> onChanged;

  const CategoryPicker({
    super.key,
    required this.items,
    required this.value,
    required this.docs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isOther = value == "Other" || !items.contains(value);
    final selected = isOther ? "Other" : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              ChoiceChip(
                label: Text(item.toString()),
                selected: item == selected,
                onSelected: (_) => onChanged(item.toString()),
                showCheckmark: false,
                backgroundColor: _fieldFill,
                selectedColor: primaryAppColor,
                labelStyle: TextStyle(
                  color: item == selected ? Colors.white : Colors.black87,
                  fontWeight:
                      item == selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
          ],
        ),
        if (isOther) ...[
          const SizedBox(height: 10),
          SuggestField(
            docs: docs,
            tag: "itemName",
            value: value == "Other" ? "" : value,
            hint: "What was it?",
            isRequired: true,
            onChanged: onChanged,
          ),
        ],
      ],
    );
  }
}

/// Two-way Personal / Home switch.
class LocationToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const LocationToggle(
      {super.key, required this.value, required this.onChanged});

  static IconData _icon(String loc) =>
      loc == "Home" ? Icons.home_outlined : Icons.person_outline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: _fieldFill, borderRadius: _fieldRadius),
      child: Row(
        children: [
          for (final loc in locationList)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(loc),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 42,
                  decoration: BoxDecoration(
                    color: loc == value ? primaryAppColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_icon(loc),
                          size: 18,
                          color: loc == value ? Colors.white : Colors.black54),
                      const SizedBox(width: 6),
                      Text(
                        locationLabel(loc),
                        style: TextStyle(
                          color: loc == value ? Colors.white : Colors.black87,
                          fontWeight: loc == value
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Date and time pickers side by side. With [allowNoDate] the date can be
/// cleared (used by Defaults, where no date means "the day you add it").
class DateTimeRow extends StatelessWidget {
  final DateTime? date;
  final TimeOfDay time;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final bool allowNoDate;

  const DateTimeRow({
    super.key,
    required this.date,
    required this.time,
    required this.onDateChanged,
    required this.onTimeChanged,
    this.allowNoDate = false,
  });

  static Widget _pickerTheme(BuildContext context, Widget? child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryAppColor,
            onPrimary: secondaryAppColor,
            onSurface: primaryAppColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: primaryAppColor),
          ),
        ),
        child: child!,
      );

  static String _dateLabel(DateTime? d) {
    if (d == null) return "Day of adding";
    final today = DateUtils.dateOnly(DateTime.now());
    final diff = today.difference(DateUtils.dateOnly(d)).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    if (d.year == today.year) return DateFormat("EEE, d MMM").format(d);
    return DateFormat.yMMMd().format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PickerTile(
            icon: Icons.calendar_today_outlined,
            label: _dateLabel(date),
            onClear: allowNoDate && date != null
                ? () => onDateChanged(null)
                : null,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2030),
                builder: _pickerTheme,
              );
              if (picked != null) onDateChanged(picked);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PickerTile(
            icon: Icons.schedule,
            label: time.format(context),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
                builder: _pickerTheme,
              );
              if (picked != null) onTimeChanged(picked);
            },
          ),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _fieldFill,
      borderRadius: _fieldRadius,
      child: InkWell(
        borderRadius: _fieldRadius,
        onTap: onTap,
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(icon, size: 18, color: Colors.black54),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15)),
              ),
              if (onClear != null)
                IconButton(
                  tooltip: "Clear date",
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClear,
                )
              else
                const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

/// Optional group tag. Off stores "none"; on asks for a group name.
class GroupField extends StatelessWidget {
  final String group;
  final List docs;
  final ValueChanged<String> onChanged;

  const GroupField({
    super.key,
    required this.group,
    required this.docs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final on = group != "none";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: _fieldRadius,
          onTap: () => onChanged(on ? "none" : ""),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              children: [
                const Icon(Icons.label_outline, size: 20, color: Colors.black54),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text("Add to a group", style: TextStyle(fontSize: 15)),
                ),
                Switch(
                  value: on,
                  activeColor: secondaryAppColor,
                  onChanged: (v) => onChanged(v ? "" : "none"),
                ),
              ],
            ),
          ),
        ),
        if (on) ...[
          const SizedBox(height: 6),
          SuggestField(
            docs: docs,
            tag: "group",
            value: group,
            hint: "Group name, e.g. Goa trip",
            avoidValue: "none",
            isRequired: true,
            suggestRecent: true,
            // Just switched on: open the keyboard with recent groups.
            autofocus: group.isEmpty,
            onChanged: onChanged,
          ),
        ],
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAppColor,
          disabledBackgroundColor: primaryAppColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: _fieldRadius),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: secondaryAppColor),
              )
            : Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
      ),
    );
  }
}
