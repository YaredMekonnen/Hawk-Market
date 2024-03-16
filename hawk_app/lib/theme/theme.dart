import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ThemeClass {
  static Color primarColor = const Color.fromRGBO(255, 205, 0, 1);
  static Color secondaryColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color backgroundColor = const Color.fromRGBO(40, 40, 40, 1);
  static Color secondaryColor2 = const Color.fromRGBO(91, 97, 110, 1);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primarColor,
      secondary: secondaryColor,
      background: backgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => primarColor),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
        }),
        foregroundColor: MaterialStateProperty.all<Color>(secondaryColor)
      )
    ),
    textTheme: TextTheme(
        displayLarge: GoogleFonts.getFont(
            'Outfit',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: secondaryColor
        ),
        displayMedium: GoogleFonts.getFont(
            'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondaryColor
        ),
        displaySmall: GoogleFonts.getFont(
            'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: secondaryColor
        ),
        titleLarge: GoogleFonts.getFont(
            'Outfit',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: secondaryColor
        ),
        titleMedium: GoogleFonts.getFont(
            'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: secondaryColor
        ),
        titleSmall: GoogleFonts.getFont(
            'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: secondaryColor
        ),
        bodyLarge:GoogleFonts.getFont(
            'Outfit',
            fontSize: 16,
            color: secondaryColor
        ),
        bodyMedium: GoogleFonts.getFont(
            'Outfit',
            fontSize: 14,
            color: secondaryColor
        ),
        bodySmall: GoogleFonts.getFont(
          'Outfit',
          fontSize: 12,
          color: secondaryColor.withOpacity(0.4)
        ),
        
      ),
      iconTheme: IconThemeData(
        color: secondaryColor,
        size: 10.w,
        
      ),
  );
}

ThemeClass _themeClass = ThemeClass();