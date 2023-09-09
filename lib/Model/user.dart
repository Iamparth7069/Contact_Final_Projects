class Users {
  String? id;
  String? imagepath;
  String? phoneNo;
  String? add;
  String? name;
  String? email;
  Users(
      {this.id,
        this.imagepath,
        this.phoneNo,
        this.name,
        this.email,
        this.add});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'imagepath': this.imagepath,
      'phoneNo': this.phoneNo,
      'name': this.name,
      'email': this.email,
      'HomeAdd' : this.add,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as String,
      imagepath: map['imagepath'] as String,
      phoneNo: map['phoneNo'] as String,
      add: map['HomeAdd'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
