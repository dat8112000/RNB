import 'package:flutter/material.dart';
import './size_configs.dart';

Color kPrimaryColor = const Color(0xffFC9D45);
Color kSecondaryColor = const Color(0xff573353);

final kTitle = TextStyle(
  fontFamily: "Lora",
  fontSize: SizeConfig.blockSizeH! * 10,
  color: kSecondaryColor,
);
final kTitle1 = TextStyle(
  fontFamily: "Klasik",
  fontSize: SizeConfig.blockSizeH! * 10,
  color: kSecondaryColor,
);

final kBodyText1 = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontWeight: FontWeight.bold,
);