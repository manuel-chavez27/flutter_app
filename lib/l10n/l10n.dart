import 'package:flutter/material.dart';

class L10n {
  static final all= [
    const Locale ('en'),
    const Locale ('es'),
  ];

  static String getFlag(String code) {
    switch(code){
      case 'es':
        return 'πͺπΈ';
      case 'en':
        default:
          return 'πΊπΈ';
    }
  }
}