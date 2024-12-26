import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:install_plugin/install_plugin.dart';

class AppUpdater {
  static Future<void> checkAndUpdate() async {
    String updateUrl = "https://nevinmanoj.github.io/xpens/apk/app-release.apk";
    try {
      if (!await _checkPermissions()) {
        throw 'Required permissions not granted';
      }

      // final packageInfo = await PackageInfo.fromPlatform();
      // final currentVersion = packageInfo.version;
      // final packageName = packageInfo.packageName;

      final dir = await getExternalStorageDirectory();
      final filePath = '${dir?.path}/app-release.apk';

      await _downloadUpdate(updateUrl, filePath);
      await _installUpdate(filePath);
    } catch (e) {
      print('Update failed: $e');
      rethrow;
    }
  }

  static Future<bool> _checkPermissions() async {
    final storage = await Permission.storage.request();
    final install = await Permission.requestInstallPackages.request();
    return storage.isGranted && install.isGranted;
  }

  static Future<void> _downloadUpdate(String url, String filePath) async {
    final dio = Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(0);
          print('Download Progress: $progress%');
        }
      },
    );
  }

  static Future<void> _installUpdate(String filePath) async {
    if (Platform.isAndroid) {
      await InstallPlugin.installApk(filePath);
    } else {
      throw 'Platform not supported';
    }
  }
}
