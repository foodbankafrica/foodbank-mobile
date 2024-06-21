import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/config/routes.dart';
import 'package:food_bank/core/providers.dart';
import 'package:food_bank/themes/theme.dart';

import 'core/app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await App.init();
      HttpOverrides.global = MyHttpOverrides();
      runApp(const MyApp());
    },
    (error, stack) {
      "error $error ====== stack $stack".log();
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: Providers.getBlocs(),
      child: GestureDetector(
        onTap: () {
          final FocusScopeNode currentNode = FocusScope.of(context);
          if (!currentNode.hasPrimaryFocus &&
              currentNode.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: MaterialApp.router(
          title: 'Food Bank',
          debugShowCheckedModeBanner: false,
          // themeMode: ThemeMode.system,
          theme: FoodBankTheme.lightTheme,
          // darkTheme: FoodBankTheme.darkTheme,
          routerConfig: routes,
        ),
      ),
    );
  }
}
