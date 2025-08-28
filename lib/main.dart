import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayer_palace_admin/core/func/app_colors.dart';

import 'package:prayer_palace_admin/screens/stats_screen.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  if (Platform.isAndroid) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Church Stats',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: const Color.fromARGB(255, 234, 233, 236),
        appBarTheme: const AppBarTheme(
          color: const Color.fromARGB(255, 234, 233, 236),
          elevation: 0,
          surfaceTintColor: Colors.white,
        ),
        textTheme: GoogleFonts.manropeTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StatsScreen(),
    );
  }
}
