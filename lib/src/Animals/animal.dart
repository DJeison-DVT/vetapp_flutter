import 'package:cloud_firestore/cloud_firestore.dart';

class Animal {
  const Animal(this.id, this.name, this.imageUrl, this.age);

  final String id;
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
      map['id'] as String,
      map['name'] as String,
      map['imageUrl'] as String,
      map['age'] as String,
    );
  }

  factory Animal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Animal(
      doc.id,
      data['name'] ?? '',
      data['imageUrl'] ?? '',
      data['age'] ?? '',
    );
  }
}
