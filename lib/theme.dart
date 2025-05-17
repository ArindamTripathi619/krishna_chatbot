import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData krishnaDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: const Color(0xFF0B0C10), // almost black
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF0B0C10),
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.pacifico(
      color: Colors.tealAccent.shade100,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardColor: const Color(0xFF181C22),
  textTheme: GoogleFonts.latoTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal.shade700,
      foregroundColor: Colors.white,
      textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      minimumSize: const Size(double.infinity, 48),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.tealAccent,
      textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white10,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    labelStyle: GoogleFonts.lato(color: Colors.white70),
    hintStyle: GoogleFonts.lato(color: Colors.white38),
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.tealAccent.shade400,
    secondary: Colors.purpleAccent.shade100,
    background: const Color(0xFF0B0C10),
    surface: const Color(0xFF181C22),
  ),
);
