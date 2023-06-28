import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logic/activity.dart';
import 'logic/alarm.dart';
import 'logic/drug.dart';
import 'logic/log.dart';
import 'screens/home/home.dart';
import 'services/notification.dart';
import 'shared/constants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  // THIS IS NOT RECOMMENDED FOR PRODUCTION
  HttpOverrides.global = MyHttpOverrides();
  // FIXME: however this does not work
  // ByteData data = await PlatformAssetBundle().load('assets/ca/cert.pem');
  // SecurityContext.defaultContext
  //     .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ActivityBloc>(create: (_) => ActivityBloc()),
        ChangeNotifierProvider<DrugBloc>(create: (_) => DrugBloc()),
        ChangeNotifierProxyProvider2<DrugBloc, ActivityBloc, AlarmBloc>(
          create: (_) => AlarmBloc(),
          update: (_, __, ___, bloc) {
            if (bloc == null) {
              return AlarmBloc();
            } else {
              return bloc..refresh();
            }
          },
        ),
        ChangeNotifierProvider<LogBloc>(create: (_) => LogBloc()),
      ],
      child: MaterialApp(
        title: 'SafeMed',
        theme: ThemeData(
          fontFamily: "IBM Plex Sans",
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: seedColorLight,
          ),
          appBarTheme: const AppBarTheme(backgroundColor: appBarColorLight),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: fabBackgroundColorLight),
          scaffoldBackgroundColor: scfBackgroundColorLight,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          fontFamily: "IBM Plex Sans",
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: seedColorDark,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: fabBackgroundColorDark,
          ),
          useMaterial3: true,
        ),
        home: const Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
