class Studmodel {
  String id;
  String img;
  String name;
  int age;

  Studmodel(
      {required this.id,
      required this.img,
      required this.name,
      required this.age});
  factory Studmodel.fromMap(Map<String, dynamic> map) {
    return Studmodel(
      id: map['id'],
      img: map['img'],
      name: map['name'],
      age: map['age'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'name': name,
      'age': age,
    };
  }
}
