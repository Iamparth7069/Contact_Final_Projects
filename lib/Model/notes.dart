class note{
  String? Uid;
  String? title;
  String? description;
  String? date;
  int? id;
  note({this.Uid, this.title,this.description,this.date});
  note.withId({this.Uid, this.title, this.description, this.date, this.id});
  Map<String, dynamic> toMap() {
    return {
      'Uid': this.Uid,
      'title': this.title,
      'description': this.description,
      'date': this.date,
      'id' : this.id
    };
  }

  factory note.fromMap(Map<String, dynamic> map) {
    return note.withId(
      id: map['id'] as int,
      Uid: map['Uid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
    );
  }
}