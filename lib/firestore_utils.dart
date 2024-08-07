import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/moduls/task.dart';

import 'moduls/user.dart';

class FirestoreUtils{

  static CollectionReference<Task> getTaskCollections(String uId){
     return getUserCollections().doc(uId).collection(Task.collectionName).withConverter<Task>(
        fromFirestore: (snapshot,options)=>Task.fromFirestore(snapshot.data()!),
        toFirestore: (task,options)=>task.toFirestore()
    );
  }
  static Future<void> addTaskToFirestore(Task task,String uId) async {
     var docref= getTaskCollections(uId).doc();
     task.id=docref.id;
      return docref.set(task);
   }
  static Future<List<QueryDocumentSnapshot<Task>>> getTaskFromFirestore(String uId) async{
       var snapshot=  await getTaskCollections(uId).get();

       List<QueryDocumentSnapshot<Task>> list =snapshot.docs;
      return list;

   }
   
   static Future<void> updateDate(Task task,String uId){
    return getTaskCollections(uId).doc(task.id).update(task.toFirestore());
   }


   static  CollectionReference<MyUser> getUserCollections(){
     return FirebaseFirestore.instance.collection(MyUser.collectionName).withConverter<MyUser>(
        fromFirestore: (snapShot,options)=>MyUser.fromFirestore(snapShot.data()),
        toFirestore: (user,options)=>user.toFirestore()
    );
   }

   static Future<void> addUserToFirestore(MyUser user)  {
       var docref =getUserCollections().doc(user.id);
       return docref.set(user);
   }

   static Future<MyUser?> getUserFromFirestore(String uId) async {
    var snapshot =await getUserCollections().doc(uId).get();
    return  snapshot.data();

   }
}