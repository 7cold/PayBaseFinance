import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/root.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("erro");
          return CupertinoActivityIndicator();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
            supportedLocales: [const Locale('pt', 'BR')],
            debugShowCheckedModeBanner: false,
            scrollBehavior: MyCustomScrollBehavior(),
            theme: ThemeData.light().copyWith(
              textSelectionTheme: TextSelectionThemeData(selectionColor: Color(corPri).withAlpha(150), cursorColor: Color(corPri)),
              backgroundColor: Colors.white,
              checkboxTheme: CheckboxThemeData(fillColor: MaterialStateProperty.all(Color(corPri))),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textSelectionTheme: TextSelectionThemeData(selectionColor: Color(corPri).withAlpha(150), cursorColor: Color(corPri)),
              backgroundColor: Color(corBackDark),
              checkboxTheme: CheckboxThemeData(fillColor: MaterialStateProperty.all(Color(corPri))),
            ),
            home: Root(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CupertinoActivityIndicator();
      },
    );
  }
}
