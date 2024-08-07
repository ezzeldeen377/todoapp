import 'package:flutter/material.dart';
import 'package:to_do_app/moduls/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppProvider extends ChangeNotifier{
  String appLanguage='en';
  ThemeMode appTheme=ThemeMode.light;

  AppProvider(){

    initProvider();
  }

  Future<void>  initProvider() async {
    try {

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        appLanguage = prefs.getString('language')!;
        appTheme =
        prefs.getString('theme') == 'light' ? ThemeMode.light : ThemeMode.dark;
        notifyListeners() ;

    }catch(e){
      print(e.toString());
    }
  }
  void changeLanguage(String newLanguage)async {
    if(appLanguage == newLanguage){
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language',newLanguage);
    appLanguage=newLanguage;
    notifyListeners();
  }

  void changeTheme(ThemeMode newTheme)async{
    if(appTheme==newTheme){
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme',newTheme==ThemeMode.light?'light':'dark');
    appTheme=newTheme;
    notifyListeners();
  }

  bool isDark(){
    return appTheme==ThemeMode.dark;
  }



}