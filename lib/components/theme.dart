import 'package:flutter/material.dart';

ThemeData apptheame(){
  return ThemeData(
      colorSchemeSeed: const Color(0xFF01579B),
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      appBarTheme: appBarTheme(),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.black)
          )
      )
  );
}

appBarTheme() {
  return AppBarTheme(
      elevation: 0,
      color: Colors.white,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black));
}