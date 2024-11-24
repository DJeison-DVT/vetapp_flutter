import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vetapp/src/Animals/animal_create_view.dart';

import '../settings/settings_view.dart';
import 'animal.dart';
import 'animal_details_view.dart';

class AnimalListView extends StatelessWidget {
  const AnimalListView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('animals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No animals found'));
          }

          return ListView.builder(
            restorationId: 'animalListView',
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final doc = snapshot.data!.docs[index];
              final animal = Animal.fromFirestore(doc);

              return ListTile(
                title: Text(animal.name),
                subtitle: Text('Age: ${animal.age}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(animal.imageUrl),
                ),
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    AnimalDetailsView.routeName,
                    arguments: animal.toMap(),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateAnimalView.routeName);
        },
        tooltip: 'Add Animal',
        child: const Icon(Icons.add),
      ),
    );
  }
}
