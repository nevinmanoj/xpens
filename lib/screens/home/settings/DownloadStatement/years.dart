import 'package:flutter/material.dart';

class Year extends StatefulWidget {
  final Function(String) setVal;

  const Year({super.key, required this.setVal});
  @override
  State<Year> createState() => _YearState();
}

class _YearState extends State<Year> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200]?.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: TextFormField(
              // initialValue: widget.year,
              keyboardType: TextInputType.number,
              // validator: (value) => value.contains(other) ? ' Must enter year' : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Year is required';
                }

                int? year = int.tryParse(value);

                if (year == null) {
                  return 'Invalid year';
                }

                if (year < 1200) {
                  return 'Year must be above 1200';
                }

                // Validation passed
                return null;
              },
              decoration:
                  const InputDecoration(hintText: "Year", border: InputBorder.none),
              onChanged: (val) {
                widget.setVal(val);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
