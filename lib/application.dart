import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:get_it/get_it.dart';
import 'package:chainmore/route/navigate_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application{
  static FluroRouter router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static SharedPreferences sp;
  static double screenWidth;
  static double screenHeight;
  static double statusBarHeight;
  static GetIt getIt = GetIt.instance;

  static initSp() async{
    sp = await SharedPreferences.getInstance();
  }

  static setupLocator(){
    getIt.registerSingleton(NavigateService());
  }

}