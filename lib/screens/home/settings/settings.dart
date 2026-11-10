import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/items/itemList.dart';
import 'package:xpens/screens/home/settings/defaults/defaultMain.dart';
import 'package:xpens/screens/home/settings/points/PointsMain.dart';
import 'package:xpens/screens/home/settings/update/UpdateMain.dart';
import '../../../services/auth.dart';
import '../../../services/providers/UserInfoProvider.dart';
import 'Trash/TrashMain.dart';
import 'billSplit/billSplitMain.dart';
import 'dev/devDash.dart';
import 'DownloadStatement/DownloadStatementMain.dart';
import 'GroupReport/GroupReportMain.dart';
import 'settingsHeader.dart';
import 'settingsMenuItem.dart';

/// Settings tab: profile header, then grouped sections of tools, data,
/// app and account actions.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email;
    final userInfo = Provider.of<UserInfoProvider>(context);

    void open(Widget page) =>
        Navigator.push(context, CupertinoPageRoute(builder: (_) => page));

    return Container(
      color: Colors.grey.shade50,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SettingsHeader(),
          const SizedBox(height: 20),
          SettingsSection(title: "Tools", items: [
            SettingsItem(
              icon: Icons.receipt_long_outlined,
              title: "Bill split",
              subtitle: "Scan a receipt and split it between people",
              onTap: () => open(const BillSplitMain()),
            ),
            SettingsItem(
              icon: Icons.sell_outlined,
              title: "Groups",
              subtitle: "Totals for trips, events and other groups",
              onTap: () => open(const GroupReportMain()),
            ),
            SettingsItem(
              icon: Icons.star_outline,
              title: "Points",
              subtitle: "Cards and the points you've used",
              onTap: () => open(const PointsMain()),
            ),
          ]),
          SettingsSection(title: "Your data", items: [
            SettingsItem(
              icon: Icons.file_download_outlined,
              title: "Download statement",
              subtitle: "Export a month as an Excel sheet",
              onTap: () => open(const DownloadStatementMain()),
            ),
            SettingsItem(
              icon: Icons.category_outlined,
              title: "Items",
              subtitle: "The categories shown on the Add tab",
              onTap: () => open(const ItemList()),
            ),
            SettingsItem(
              icon: Icons.tune,
              title: "Defaults",
              subtitle: "What the Add form starts with",
              onTap: () => open(const Defaults()),
            ),
            SettingsItem(
              icon: Icons.delete_outline,
              title: "Trash",
              subtitle: "Restore or permanently delete entries",
              onTap: () => open(const TrashMain()),
            ),
          ]),
          SettingsSection(title: "App", items: [
            SettingsItem(
              icon: Icons.system_update_outlined,
              title: "Updates",
              subtitle: "Version ${userInfo.currentVersion}",
              badge: userInfo.updateAvailable ? "New" : null,
              onTap: () => open(const UpdateMain()),
            ),
            if (userInfo.isDev)
              SettingsItem(
                icon: Icons.code,
                title: "Dev dashboard",
                subtitle: "Test data and maintenance tools",
                onTap: () => open(const DevDash()),
              ),
          ]),
          SettingsSection(title: "Account", items: [
            if (email != null)
              SettingsItem(
                icon: Icons.lock_reset,
                title: "Reset password",
                subtitle: "Email a reset link to $email",
                onTap: () => _confirm(
                  context,
                  title: "Send a reset link?",
                  message: "We'll email a password reset link to $email.",
                  action: "Send",
                  onConfirm: () => AuthSerivice().Passwordreset(email, context),
                ),
              ),
            SettingsItem(
              icon: Icons.logout,
              title: "Log out",
              destructive: true,
              onTap: () => _confirm(
                context,
                title: "Log out?",
                message: "You'll need to sign in again to see your expenses.",
                action: "Log out",
                destructive: true,
                onConfirm: () => AuthSerivice().signOut(),
              ),
            ),
          ]),
          Center(
            child: Text("xpens ${userInfo.currentVersion}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
    required VoidCallback onConfirm,
    bool destructive = false,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor:
                    destructive ? Colors.red.shade700 : Colors.black),
            child: Text(action,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) onConfirm();
  }
}
