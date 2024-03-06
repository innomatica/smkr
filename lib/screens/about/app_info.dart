import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/constants.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  String? _getStoreUrl() {
    if (Platform.isAndroid) {
      return urlPlayStore;
    } else if (Platform.isIOS) {
      return urlAppStore;
    }
    return urlHomePage;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          title: Text('앱 버젼',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          subtitle: const Text(appVersion),
        ),
        ListTile(
          title: Text('앱 리뷰하기',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          subtitle: const Text('리뷰, 건의, 버그 리포트'),
          onTap: () {
            final url = _getStoreUrl();
            if (url != null) {
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            }
          },
        ),
        ListTile(
          title: Text('앱 소개하기',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          subtitle: const Text('QR코드를 보여주세요'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Center(
                    child: Text(
                      'QR코드를 스캔해 주세요',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  // backgroundColor: Colors.white,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Image.asset(playStoreUrlQrCode),
                    )
                  ],
                );
              },
            );
          },
        ),
        ListTile(
          title: Text(
            '개발자',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text(urlHomePage),
          onTap: () {
            launchUrl(Uri.parse(urlHomePage),
                mode: LaunchMode.externalApplication);
          },
        ),
      ],
    );
  }
}
