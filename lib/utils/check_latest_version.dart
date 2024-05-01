import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckLatestVersionArg {
  RxString oldVersion = "".obs;
  RxString currentVersion = "".obs;
  RxString newAppUrl = "".obs;
  CheckLatestVersionArg({
    required this.oldVersion,
    required this.currentVersion,
    required this.newAppUrl,
  });
}

Future<void> checkLatestVersion(CheckLatestVersionArg item) async {
  const repositoryOwner = 'AJIb63PT';
  const repositoryName = 'full-body-routine';
  final response = await http.get(Uri.parse(
    'https://api.github.com/repos/$repositoryOwner/$repositoryName/releases/latest',
  ));
  print('response');

  print(response.body);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final tagName = data['tag_name'];
    item.oldVersion.value = tagName;
    final assets = data['assets'] as List<dynamic>;

    if (Platform.isAndroid) {
      // Android-specific code/UI Component
      final assetName = assets[0]['name'];
      final assetDownloadUrl = assets[0]['browser_download_url'];
      item.newAppUrl.value = assetDownloadUrl;

      print(assetName);
      print(assetDownloadUrl);
    } else if (Platform.isIOS) {
      final assetName = assets.last['name'];
      final assetDownloadUrl = assets.last['browser_download_url'];
      item.newAppUrl.value = assetDownloadUrl;
    }
    // добавить проверку на устройство
    // for (final asset in assets) {
    //   final assetName = asset['name'];
    //   final assetDownloadUrl = asset['browser_download_url'];

    //   item.newAppUrl.value = assetDownloadUrl;
    // }

    if (item.currentVersion.value != item.oldVersion.value) {
      // checkUpdate();
    }
  } else {
    print(
        'Failed to fetch GitHub release info. Status code: ${response.statusCode}');
  }
}
