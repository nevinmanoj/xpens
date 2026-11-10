import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/components/ItemInput/formFields.dart'
    show FieldLabel, SubmitButton, fieldDecoration;
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/utils/toast.dart';

import '../../../../shared/constants.dart';

/// Edit your name and phone number. Email is shown but can't be changed.
class Profile extends StatefulWidget {
  final String name;
  final String phoneNumber;
  const Profile({super.key, required this.name, required this.phoneNumber});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.name);
  late final _phone = TextEditingController(text: widget.phoneNumber);
  bool _saving = false;

  bool get _changed =>
      _name.text.trim() != widget.name.trim() ||
      _phone.text.trim() != widget.phoneNumber.trim();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _name.text
        .trim()
        .split(RegExp(r"\s+"))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return "";
    return (parts.first[0] + (parts.length > 1 ? parts.last[0] : ""))
        .toUpperCase();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final db = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
    try {
      if (_name.text.trim() != widget.name.trim()) {
        await db.updateUserInfo("Name", _name.text.trim());
      }
      if (_phone.text.trim() != widget.phoneNumber.trim()) {
        await db.updateUserInfo("PhoneNumber", _phone.text.trim());
      }
      if (!mounted) return;
      showToast(context: context, msg: "Profile updated");
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showToast(context: context, msg: "Couldn't update your profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? "";

    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryAppColor, title: const Text("Profile")),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: secondaryAppColor, shape: BoxShape.circle),
                    child: _initials.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : Text(_initials,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 28),
                const FieldLabel("Name"),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: primaryAppColor,
                  decoration: fieldDecoration(hint: "Your name"),
                  validator: (v) =>
                      (v ?? "").trim().isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 20),
                const FieldLabel("Phone number"),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  cursorColor: primaryAppColor,
                  decoration: fieldDecoration(hint: "Phone number"),
                  validator: (v) =>
                      (v ?? "").trim().isEmpty ? "Enter a phone number" : null,
                ),
                const SizedBox(height: 20),
                const FieldLabel("Email"),
                TextFormField(
                  initialValue: email,
                  enabled: false,
                  decoration: fieldDecoration().copyWith(
                    suffixIcon: const Icon(Icons.lock_outline, size: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2),
                  child: Text("Your sign-in email can't be changed here.",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ),
                const SizedBox(height: 32),
                Opacity(
                  opacity: _changed ? 1 : 0.4,
                  child: SubmitButton(
                    label: "Save",
                    loading: _saving,
                    onPressed: _changed ? _save : () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
