class contact{
  String email;
  String HomeAdd;
  String imagepath;
  String name;
  String phone;
  String? docId;

  contact(
      {required this.email,
      required this.HomeAdd,
      required this.imagepath,
      required this.name,
      required this.phone,this.docId});

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'HomeAdd': this.HomeAdd,
      'imagepath': this.imagepath,
      'name': this.name,
      'phoneNo': this.phone
    };
  }

  factory contact.fromMap(Map<String, dynamic> map) {
    return contact(
      email: map['email'] as String,
      HomeAdd: map['HomeAdd'] as String,
      imagepath: map['imagepath'] as String,
      name: map['name'] as String,
      phone: map['phoneNo'] as String,
    );
  }
}