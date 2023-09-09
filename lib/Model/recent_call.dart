class Recent{
  String number;
  String? Name;
  String time;
  String uid;
  String imageUrl;
  Recent({required this.number, required this.Name,required this.uid, required this.time,required this.imageUrl });

  Map<String, dynamic> toMap() {
    return {
      'number': this.number,
      'Name': this.Name,
      'time': this.time,
      'uid': this.uid,
      'imageUrl': this.imageUrl,
    };
  }

  factory Recent.fromMap(Map<String, dynamic> map) {
    return Recent(
      number: map['number'] as String,
      Name: map['Name'] as String,
      time: map['time'] as String,
      uid: map['uid'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

}