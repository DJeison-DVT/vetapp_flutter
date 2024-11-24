import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'animal.dart';
import 'animal_details_view.dart';
import 'animal_create_view.dart';
import '../settings/settings_view.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Error loading animals.'));
          }

          final animalDocs = snapshot.data?.docs ?? [];

          if (animalDocs.isEmpty) {
            return const Center(child: Text('No animals found.'));
          }

          return ListView.builder(
            restorationId: 'animalListView',
            itemCount: animalDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final animalData =
                  animalDocs[index].data() as Map<String, dynamic>;

              // Convert Firestore data to an Animal object
              final animal = Animal.fromMap(animalData);

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
