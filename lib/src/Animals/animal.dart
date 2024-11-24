class Animal {
  const Animal(this.id, this.name, this.imageUrl, this.age);

  final int id;
  final String name;
  final String imageUrl;
  final String age;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'age': age,
    };
  }

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      map['id'] as int,
      map['name'] as String,
      map['imageUrl'] as String,
      map['age'] as String,
    );
  }
}
