import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color bg2Color = Color.fromARGB(255, 255, 255, 255);
  static Color bgColor = Color.fromARGB(255, 43, 43, 43);
  static Color mainColor = Color.fromARGB(255, 240, 240, 240);
  static Color accentColor = Color.fromARGB(255, 111, 169, 255);

  //setting the card different color
  static List<Color> cardsColor =[
    const Color.fromARGB(255, 217, 151, 255),
    const Color.fromARGB(255, 141, 255, 145),
    const Color.fromARGB(255, 137, 202, 255),
    const Color.fromARGB(255, 255, 229, 145),
    ];
  
  static TextStyle mainTitle =
    GoogleFonts.roboto(fontSize: 18.0,fontWeight: FontWeight.bold);
  static TextStyle mainContent =
    GoogleFonts.nunito(fontSize: 16.0,fontWeight: FontWeight.normal);
  static TextStyle dateTitle =
    GoogleFonts.roboto(fontSize: 13.0,fontWeight: FontWeight.w500);
}