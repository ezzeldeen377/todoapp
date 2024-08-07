import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/firestore_utils.dart';
import 'package:to_do_app/moduls/user.dart';
import 'package:to_do_app/provider/Appprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../moduls/task.dart';

class ListProvider extends ChangeNotifier{
  List<Task> list=[];
  DateTime selectedDate=DateTime.now();
  MyUser? currentUser;

  ListProvider()  {
    initUser();
  }
  initUser() async {
    final SharedPreferences pref=await SharedPreferences.getInstance();
    var user=jsonDecode(pref.getString('user')!) as Map<String,dynamic> ;
    currentUser=MyUser.fromFirestore(user);
    print(currentUser?.name);


  }
  Future<void> changeUser(MyUser newUser) async {
    if(currentUser== newUser){
      return;
    }
    final SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString('user', jsonEncode(newUser.toFirestore()));

    currentUser=newUser;
    notifyListeners();
  }



   Future<void> initDataList() async {
    List<QueryDocumentSnapshot<Task>> docSnapshot= await FirestoreUtils.getTaskFromFirestore(currentUser!.id!);
    list=  docSnapshot.map((doc){
      return doc.data();
    }).toList();


    list.sort(
        (task1,task2){
          return task1.dateTime.compareTo(task2.dateTime);
        }
    );
    list= list.where((task){
      if(task.dateTime.year==selectedDate.year&&
          task.dateTime.month==selectedDate.month&&
          task.dateTime.day==selectedDate.day
      ){
        return true;
      }
      return false;
    }).toList();
     notifyListeners();

  }
  void changeDate(DateTime newDate){
    selectedDate=newDate;
    initDataList();
  }
  void changeTaskState(Task task, bool state){
    task.isDone=state;
    initDataList();
  }
  void finishTask(Task task) {
    task.isDone=true;
     FirestoreUtils.getTaskCollections(currentUser!.id!).doc(task.id).update(task.toFirestore());
    notifyListeners();
  }

  bool isDone(Task task){
    return task.isDone;
  }



}