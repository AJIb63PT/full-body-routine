import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class CheckLatestVersionRes {
  String oldVersion = "";
  String currentVersion = "";
  String newAppUrl = "";
  String statusText = "";
  bool hasUpdate = false;

  CheckLatestVersionRes({
    required this.newAppUrl,
    required this.statusText,
    required this.hasUpdate,
  });
}

Future<CheckLatestVersionRes> checkLatestVersion() async {
  String oldVersion = "";
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = 'v${packageInfo.version}';
  String newAppUrl = "";
  String statusText = "";
  const repositoryOwner = 'AJIb63PT';
  const repositoryName = 'full-body-routine';
  final response = await http.get(Uri.parse(
    'https://api.github.com/repos/$repositoryOwner/$repositoryName/releases/latest',
  ));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final tagName = data['tag_name'];
    oldVersion = tagName;
    final assets = data['assets'] as List<dynamic>;

    if (Platform.isAndroid) {
      final assetDownloadUrl = assets[0]['browser_download_url'];
      newAppUrl = assetDownloadUrl;
    } else if (Platform.isIOS) {
      final assetDownloadUrl = assets.last['browser_download_url'];
      newAppUrl = assetDownloadUrl;
    }
    // добавить проверку на устройство и тип ядра
    // for (final asset in assets) {
    // }

    if (currentVersion != oldVersion) {
      statusText = 'New Update Available';
    } else {
      statusText = 'No Update';
    }
  } else {
    print(
        'Failed to fetch GitHub release info. Status code: ${response.statusCode}');
  }
  print(currentVersion);
  print(oldVersion);

  return CheckLatestVersionRes(
      hasUpdate: currentVersion != oldVersion,
      newAppUrl: newAppUrl,
      statusText: statusText);
}
