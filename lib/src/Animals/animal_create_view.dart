import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CreateAnimalView extends StatefulWidget {
  const CreateAnimalView({super.key});

  static const routeName = '/create_animal';

  @override
  State<CreateAnimalView> createState() => _CreateAnimalViewState();
}

class _CreateAnimalViewState extends State<CreateAnimalView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveAnimal() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final age = _ageController.text;
      final imageUrl = _imageUrlController.text;

      try {
        await FirebaseFirestore.instance.collection('animals').add({
          'name': name,
          'age': age,
          'imageUrl': imageUrl,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add animal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Input Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age Input Field
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Picture URL Input Field
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Picture URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a picture URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveAnimal,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
