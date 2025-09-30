import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();
  static Color whiteBackgroundColor = Color.fromRGBO(241, 249, 255, 1);
  static Color linkColor = const Color.fromRGBO(30, 121, 175, 1);
  static Color lightPrimaryColor = const Color.fromRGBO(8, 102, 255, 1);
  static Color blackColor = const Color(0xff040415);
  static Color lightTextColor = const Color.fromRGBO(77, 77, 77, 1);
  static Color darkTextColor = const Color.fromRGBO(0, 0, 0, 1);
  static Color newdarktheme = Color.fromRGBO(30, 30, 30, 1);
  static Color backGround = const Color.fromRGBO(243, 242, 238, 1);
  static Color backGround2 = const Color.fromRGBO(168, 168, 168, 0.18);
  static Color bodyTextColor = const Color(0xFF464646);
  static Color buttonColor = const Color.fromRGBO(51, 191, 230, 1);
  static Color hintTextColor = const Color.fromRGBO(123, 123, 123, 1);
  static Color newLightColor = const Color.fromRGBO(118, 118, 118, 1);
  static Color newLightColor2 = const Color.fromRGBO(128, 128, 128, 1);
  static Color likeTextColor = const Color.fromRGBO(178, 178, 178, 1);
  static Color likeTextColor2 = const Color.fromRGBO(220, 220, 220, 1);
  static Color starColor = const Color.fromRGBO(255, 227, 2, 1);
  static Color whiteTextColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color lightHintTextColor = const Color.fromRGBO(142, 142, 142, 1);
  static Color powderBlue = const Color.fromRGBO(165, 192, 255, 1);
  static Color powderBlueDark = const Color.fromRGBO(199, 216, 255, 1);

  static Color iconColor = Color.fromRGBO(0, 0, 0, 0.25);
  static Color lightText = Color.fromRGBO(0, 0, 0, 0.6);
  static Color pinkcolor = Color.fromRGBO(248, 213, 210, 0.64);

  static Color iconSelectedColor = Color.fromRGBO(199, 216, 255, 1);
  //s̄
  static Color cardBg = Color.fromRGBO(228, 237, 255, 1);
  static Color cardPromodoroBg = Color.fromRGBO(210, 236, 255, 1);
  static Color impColor = Color.fromRGBO(255, 229, 186, 1);
  static Color noturgent = Color.fromRGBO(254, 194, 189, 0.64);

  static Color blueUrgent = Color.fromRGBO(210, 236, 255, 1);
  static Color greenUrgent = Color.fromRGBO(217, 238, 177, 1);
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    cardColor: backGround2,
    //useMaterial3: true,
    hoverColor: backGround2,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: whiteBackgroundColor,
    appBarTheme: appBarTheme(),
    // dialogTheme: const DialogTheme(
    //   backgroundColor: Colors.white,
    //   surfaceTintColor: Colors.transparent,
    // ),
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          secondary: Colors.blue,
        ),
    indicatorColor: backGround2,
    datePickerTheme: DatePickerThemeData(elevation: 0),
    canvasColor: AppTheme.darkTextColor,
    shadowColor: Colors.black87.withOpacity(0.3),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: lightPrimaryColor,
      selectionColor: lightPrimaryColor,
      selectionHandleColor: lightPrimaryColor,
    ),

    // tabBarTheme: TabBarTheme(
    //   labelColor: lightPrimaryColor,
    //   unselectedLabelColor: blackColor,
    //   unselectedLabelStyle: GoogleFonts.rubik(
    //       fontSize: 14, color: blackColor, fontWeight: FontWeight.w500),
    //   labelStyle: GoogleFonts.rubik(
    //       fontSize: 14,
    //       color: blackColor,
    //       fontWeight: FontWeight.w600), // color for text
    // ),

    // text theme
    textTheme: TextTheme(
        headlineMedium: title16Px,
        headlineLarge: headingText,
        displayLarge: text14Px,
        bodyLarge: text14500Px,
        displayMedium: smallText,
        headlineSmall: text20600Px,
        bodyMedium: smallTextDark,
        bodySmall: extraSmallText,
        labelSmall: lableInputText,
        labelLarge: lightBoldText,
        labelMedium: authScreenTitle,
        displaySmall: hintText),
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: lightPrimaryColor),
    //  scaf : whiteBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    //   appBarTheme: AppBarTheme(backgroundColor: lightPrimaryColor),
  );
  // static final TextStyle smallLikesText = GoogleFonts.rubik(
  //   color: lightTextColor,
  //   fontSize: 12,
  //   letterSpacing: 0,
  //   fontWeight: FontWeight.w400,
  // );
  static final TextStyle headingText = GoogleFonts.rubik(
    color: darkTextColor,
    fontSize: 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle title16Px = GoogleFonts.rubik(
    color: darkTextColor,
    fontSize: 16, // 16 to 14
    letterSpacing: 0,
    height: 0,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle text14Px = GoogleFonts.rubik(
    color: darkTextColor,
    fontSize: 14,
    letterSpacing: 0,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle text14500Px = GoogleFonts.rubik(
    color: hintTextColor,
    fontSize: 14,
    letterSpacing: 0,
    height: 0,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle text20600Px = GoogleFonts.rubik(
    color: lightTextColor,
    fontSize: 20,
    letterSpacing: 0,
    height: 0,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle lightBoldText = GoogleFonts.rubik(
    color: lightTextColor,
    fontSize: 14,
    letterSpacing: 0,
    height: 0,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle hintText = GoogleFonts.rubik(
    color: hintTextColor,
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle authScreenTitle = GoogleFonts.rubik(
      fontSize: 20,
      color: darkTextColor,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
      height: 1.4);
  static final TextStyle lableInputText = GoogleFonts.rubik(
    fontSize: 12,
    letterSpacing: 0,
    color: lightTextColor,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle smallText = GoogleFonts.rubik(
    fontSize: 16,
    letterSpacing: 0,
    color: hintTextColor,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle smallTextDark = GoogleFonts.rubik(
    fontSize: 16,
    letterSpacing: 0,
    color: hintTextColor,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle extraSmallText = GoogleFonts.rubik(
    fontSize: 14,
    letterSpacing: 0,
    color: lightTextColor,
    fontWeight: FontWeight.w400,
  );
  //extraSmallText
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    shadowColor: Colors.black.withOpacity(0.7),
    //   surfaceTintColor: Colors.transparent,
    color: Colors.white,
    //  scrolledUnderElevation: 0,
    //  brightness: Brightness.light,
    iconTheme: IconThemeData(color: AppTheme.darkTextColor),
    // titleTextStyle: GoogleFonts.rubik(
    //     fontSize: 18,
    //     color: AppTheme.darkTextColor,
    //     fontWeight: FontWeight.w600),
  );
}
