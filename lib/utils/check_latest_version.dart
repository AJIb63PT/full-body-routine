// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<void> checkLatestVersion() async {
//   const repositoryOwner = 'MrNitishroy';
//   const repositoryName = 'Sampark';
//   final response = await http.get(Uri.parse(
//     'https://api.github.com/repos/$repositoryOwner/$repositoryName/releases/latest',
//   ));
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> data = json.decode(response.body);
//     final tagName = data['tag_name'];
//     oldVersion.value = tagName;
//     final assets = data['assets'] as List<dynamic>;
//     for (final asset in assets) {
//       final assetName = asset['name'];
//       final assetDownloadUrl = asset['browser_download_url'];
//       newAppUrl.value = assetDownloadUrl;
//     }

//     if (currentVersion.value != oldVersion.value) {
//       checkUpdate();
//     }
//   } else {
//     print(
//         'Failed to fetch GitHub release info. Status code: ${response.statusCode}');
//   }
// }
