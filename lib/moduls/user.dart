class MyUser {
  static const String collectionName='users';
  String? name;
  String? email;
  String? id;

  MyUser({required this.id,required this.name,required this.email});

  MyUser.fromFirestore(Map<String,dynamic>? data):this(
    name: data?['name'] as String,
    email: data?['email'] as String,
    id: data?['id'] as String
  );

  Map<String,dynamic> toFirestore(){
    return{
      'id':this.id,
      'email':this.email,
      'name':this.name
    };

  }
}