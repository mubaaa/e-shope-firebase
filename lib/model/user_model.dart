class UserModel {
  String? uid;
  String? firstName;
  String? secondName;
  String? email;

  UserModel({
     this.uid,
     this.firstName,
     this.secondName,
     this.email,
  });

//receiving data from server
  factory UserModel.fromJson(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      email: map['email'],
    );
  }


 // sending data to our server
  Map<String, dynamic> toMap(){
    return{
     'uid':uid,
     'firstName':firstName,
     'secondName':secondName,
     'email':email
    };
  }
}
