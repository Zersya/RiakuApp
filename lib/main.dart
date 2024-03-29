import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geocoder/services/local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riaku_app/screens/splash/splash_screen.dart';
import 'package:riaku_app/helper/loc_delegate.dart';
import 'package:riaku_app/helper/locator.dart';
import 'package:riaku_app/helper/router.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('id', timeago.IdMessages());

  runApp(MyApp());

  locator(Firestore.instance, false,
      auth: FirebaseAuth.instance,
      geocod: LocalGeocoding(),
      geoloc: Geolocator());
}

class MyApp extends StatelessWidget {
  static final ColorScheme _colorSchemeLight = ColorScheme.light(
    primary: const Color(0xffef3860),
    primaryVariant: const Color(0xfff30e40),
    secondary: const Color(0xffff8f00),
    secondaryVariant: const Color(0xffffc046),
    surface: Colors.black45,
    background: Colors.white,
    error: const Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.grey[300],
    onSurface: Colors.grey[300],
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static final TextTheme _textTheme = TextTheme(
    headline: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
    title: GoogleFonts.varelaRound(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        textStyle: TextStyle(color: _colorSchemeLight.primary)),
    subhead: GoogleFonts.varelaRound(fontSize: 16, fontWeight: FontWeight.bold),
    subtitle:
        GoogleFonts.varelaRound(textStyle: TextStyle(color: Colors.grey[500])),
    body1: GoogleFonts.varelaRound(fontSize: 16),
    body2: GoogleFonts.roboto(
        fontSize: 16, textStyle: TextStyle(color: _colorSchemeLight.onSurface)),
    overline:
        GoogleFonts.varelaRound(textStyle: TextStyle(color: Colors.grey[500])),
    button: GoogleFonts.lato(
        fontSize: 14,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  );

  final ThemeData _themeData = ThemeData(
    colorScheme: _colorSchemeLight,
    primaryColor: _colorSchemeLight.primary,
    accentColor: _colorSchemeLight.secondary,
    backgroundColor: _colorSchemeLight.background,
    textTheme: _textTheme,
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    iconTheme: IconThemeData(
      color: _colorSchemeLight.surface,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RIAKU',
      localizationsDelegates: [
        const LocDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('id')],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      theme: _themeData,
      onGenerateRoute: Router.generateRoute,
      // initialRoute: Router.kRouteSplash,
      home: SplashScreen(),
    );
  }
}
