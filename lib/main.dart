import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/homepage/edit_page.dart';
import 'package:to_do_app/homepage/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_app/homepage/view_page.dart';
import 'package:to_do_app/login/login_page.dart';
import 'package:to_do_app/my_theme.dart';
import 'package:to_do_app/provider/Appprovider.dart';
import 'package:to_do_app/register/register_page.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'provider/list_provider.dart';
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(
  MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=>AppProvider()),
    ChangeNotifierProvider(create: (context)=>ListProvider()),
  ],
            child: MyApp()));
  await FirebaseFirestore.instance.disableNetwork();

}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<AppProvider>(context);
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     initialRoute: LoginPage.routeName,
     routes:{
       HomePage.routeName:(context)=>HomePage(),
       EditPage.routeName:(context)=>EditPage(),
       ViewPage.routeName:(context)=>ViewPage(),
       RegisterPage.routeName:(context)=>RegisterPage(),
       LoginPage.routeName:(context)=>LoginPage(),


     },
     locale: Locale(provider.appLanguage),
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: AppLocalizations.supportedLocales,
     theme: MyTheme.lightTheme,
     darkTheme:MyTheme.darkTheme ,
     themeMode: provider.appTheme,

   );
  }
}