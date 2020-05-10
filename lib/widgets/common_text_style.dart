import 'package:flutter/material.dart';

class TextUtil {
  static Map<int, FontWeight> fontWeightMap = {
    100 : FontWeight.w100,
    200 : FontWeight.w200,
    300 : FontWeight.w300,
    400 : FontWeight.w400,
    500 : FontWeight.w500,
    600 : FontWeight.w600,
    700 : FontWeight.w700,
  };

  static TextStyle style(double size, int weight, {Color color = Colors.black87}) {
    return TextStyle(fontSize: size, fontWeight: fontWeightMap[weight], color: color);
  }
}

final commonTitleTextStyle = TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500);
final commonSubtitleTextStyle = TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);

final commonTextStyle = TextStyle(fontSize: 16, color: Colors.black87);
final commonWhiteTextStyle = TextStyle(fontSize: 16, color: Colors.white);
final commonGrayTextStyle = TextStyle(fontSize: 16, color: Colors.grey);
final commonWhite70TextStyle = TextStyle(fontSize: 16, color: Colors.white70);
final smallWhite70TextStyle = TextStyle(fontSize: 12, color: Colors.white70);
final smallWhite30TextStyle = TextStyle(fontSize: 12, color: Colors.white30);
final smallWhiteTextStyle = TextStyle(fontSize: 12, color: Colors.white);
final smallRedTextStyle = TextStyle(fontSize: 12, color: Colors.red);
final mWhiteTextStyle = TextStyle(fontSize: 18, color: Colors.white);
final mCommonTextStyle = TextStyle(fontSize: 18, color: Colors.black87);
final mGrayTextStyle = TextStyle(fontSize: 18, color: Colors.grey);
final mWhiteBoldTextStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
final mBlackBoldTextStyle = TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold);
final mGrayBoldTextStyle = TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold);
final smallCommonTextStyle = TextStyle(fontSize: 12, color: Colors.black87);
final smallGrayTextStyle = TextStyle(fontSize: 12, color: Colors.grey);
final common14TextStyle = TextStyle(fontSize: 14, color: Colors.black87);
final common13TextStyle = TextStyle(fontSize: 13, color: Colors.black87);
final bold20TextStyle = TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold);
final bold18TextStyle = TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold);
final w600_18TextStyle = TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600);
final w600_16TextStyle = TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600);
final w600_15TextStyle = TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600);
final w600_14TextStyle = TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600);
final w500_18TextStyle = TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500);
final w500_16TextStyle = TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500);
final w400_18TextStyle = TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w400);
final w400_16TextStyle = TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400);
final w400_15TextStyle = TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w400);
final w400_14TextStyle = TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w400);
final w400_13TextStyle = TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w400);
final bold17TextStyle = TextStyle(fontSize: 17, color: Colors.black87, fontWeight: FontWeight.bold);
final bold16TextStyle = TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold);
final bold16RedTextStyle = TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);
final bold18RedTextStyle = TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold);
final bold16GrayTextStyle = TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold);
final bold18GrayTextStyle = TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold);
final common14WhiteTextStyle = TextStyle(fontSize: 14, color: Colors.white);
final common10White70TextStyle = TextStyle(fontSize: 10, color: Colors.white70);
final common14GrayTextStyle = TextStyle(fontSize: 14, color: Colors.grey);
final common13GrayTextStyle = TextStyle(fontSize: 13, color: Colors.grey);
final common15GrayTextStyle = TextStyle(fontSize: 15, color: Colors.grey);
final common16GrayTextStyle = TextStyle(fontSize: 16, color: Colors.grey);
final common16TextStyle = TextStyle(fontSize: 16, color: Colors.black87);
final common18TextStyle = TextStyle(fontSize: 18, color: Colors.black87);
final common10RedTextStyle = TextStyle(fontSize: 10, color: Colors.red);
final common14White70TextStyle = TextStyle(fontSize: 14, color: Colors.white70);