import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/shared/constants.dart';

import '../../../services/providers/UserInfoProvider.dart';
import 'Profile/Profile.dart';

/// Black profile band at the top of Settings. Tapping it edits the profile.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  static String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r"\s+")).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return "";
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final userInfo = Provider.of<UserInfoProvider>(context);
    final name = userInfo.userName.trim();
    final details = [
      if ((user?.email ?? "").isNotEmpty) user!.email!,
      if (userInfo.phone.trim().isNotEmpty) userInfo.phone.trim(),
    ];

    void openProfile() => Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (_) => Profile(
                  name: userInfo.userName,
                  phoneNumber: userInfo.phone,
                )));

    return Material(
      color: primaryAppColor,
      child: InkWell(
        onTap: openProfile,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 12, 20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: secondaryAppColor, shape: BoxShape.circle),
                child: _initials(name).isEmpty
                    ? const Icon(Icons.person, color: Colors.black, size: 28)
                    : Text(_initials(name),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? "Your profile" : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    for (final line in details) ...[
                      const SizedBox(height: 2),
                      Text(line,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 13)),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: "Edit profile",
                onPressed: openProfile,
                icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
