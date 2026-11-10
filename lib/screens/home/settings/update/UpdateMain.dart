import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/utils/toast.dart';

/// Updates: current version, and the new one with its notes when available.
class UpdateMain extends StatefulWidget {
  const UpdateMain({super.key});

  @override
  State<UpdateMain> createState() => _UpdateMainState();
}

class _UpdateMainState extends State<UpdateMain> {
  static final _downloadPage = Uri.parse("https://nevinmanoj.github.io/xpens/");
  bool _checking = false;

  Future<void> _check(UserInfoProvider userInfo) async {
    setState(() => _checking = true);
    await userInfo.checkForUpdate();
    if (!mounted) return;
    setState(() => _checking = false);
    if (!userInfo.updateAvailable) {
      showToast(context: context, msg: "You're on the latest version");
    }
  }

  Future<void> _download() async {
    try {
      await launchUrl(_downloadPage, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        showToast(context: context, msg: "Couldn't open the download page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final available = userInfo.updateAvailable;
    String latest = "", notes = "";
    try {
      latest = (userInfo.latestVersionData?["currentVersion"] ?? "").toString();
      notes = (userInfo.latestVersionData?["bio"] ?? "").toString().trim();
    } catch (_) {}

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
          backgroundColor: primaryAppColor, title: const Text("Updates")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset("assets/release.png", width: 88, height: 88),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text("xpens",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          Center(
            child: Text("Version ${userInfo.currentVersion}",
                style: TextStyle(color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: available ? secondaryAppColor : Colors.grey.shade200,
                  width: available ? 1.5 : 1),
            ),
            child: available
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.new_releases_outlined,
                              color: secondaryAppColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text("Version $latest is available",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      if (notes.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text("What's new",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700)),
                        const SizedBox(height: 4),
                        Text(notes, style: const TextStyle(height: 1.4)),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _download,
                          icon: const Icon(Icons.download_outlined, size: 20),
                          label: Text("Download $latest"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryAppColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.green.shade700),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text("You're up to date",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                      TextButton(
                        onPressed: _checking ? null : () => _check(userInfo),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black87),
                        child: _checking
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black54),
                              )
                            : const Text("Check again"),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
