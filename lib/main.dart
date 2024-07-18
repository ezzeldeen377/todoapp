import 'package:flutter/material.dart';
import 'package:to_do_app/home_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     initialRoute: HomePage.routeName,
     routes:{
       HomePage.routeName:(context)=>HomePage(),
     },
   );
  }
}