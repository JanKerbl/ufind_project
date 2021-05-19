import 'package:flutter/material.dart';
import 'package:ufind_project/screens/result.dart';
import 'screens/vvz.dart';
import 'screens/home.dart';
import 'screens/details.dart';

void main() => runApp(MyApp());

//Main Klasse mit Routen Namen für die verschiedenen Screens
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ufind App',
      theme: ThemeData(
        primarySwatch: myColor,
      ),
      home: HomeScreen(),
      initialRoute: "/",
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        VvzScreen.routeName: (ctx) => VvzScreen(),
        SearchResult.routeName: (ctx) => SearchResult(),
        Details.routeName: (ctx) => Details(),
      },
    );
  }
}

const MaterialColor myColor = const MaterialColor(
  0xFF0063A6,
  const <int, Color>{
    50: const Color(0xFF0063A6),
    100: const Color(0xFF0063A6),
    200: const Color(0xFF0063A6),
    300: const Color(0xFF0063A6),
    400: const Color(0xFF0063A6),
    500: const Color(0xFF0063A6),
    600: const Color(0xFF0063A6),
    700: const Color(0xFF0063A6),
    800: const Color(0xFF0063A6),
    900: const Color(0xFF0063A6),
  },
);
