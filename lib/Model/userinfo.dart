class UserInfos{
  String? imageUrl;
  String? email;
  String? name;
  String? Password;

  UserInfos({this.email, this.name, this.Password,this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'name': this.name,
      'Password': this.Password,
    };
  }

  factory UserInfos.fromMap(Map<String, dynamic> map) {
    return UserInfos(
      imageUrl: map['ImageUrlUser'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      Password: map['password'] as String,
    );
  }
}