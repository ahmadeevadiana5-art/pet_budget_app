import 'package:flutter/material.dart';
import 'game/pet/pet.dart';
import 'game/pet/pet_manager.dart';
import 'game/pet/in_memory_pet_storage.dart';
import 'ui/widgets/pet_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Budget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// Временный экран для проверки PetWidget.
/// В финале его заменит настоящий HomeScreen (Маша).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PetManager _manager;
  Pet? _pet;

  @override
  void initState() {
    super.initState();
    _manager = PetManager(storage: InMemoryPetStorage());
    _createTestPet();
  }

  Future<void> _createTestPet() async {
    final pet = await _manager.createPet(
      id: '1',
      type: PetType.cat,
      color: PetColor.red,
      name: 'Барсик',
    );
    setState(() => _pet = pet);
  }

  Future<void> _feed() async {
    final pet = await _manager.feed();
    setState(() => _pet = pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверка PetWidget')),
      body: Center(
        child: _pet == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PetWidget(pet: _pet!),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _feed,
                      icon: const Icon(Icons.restaurant),
                      label: const Text('Покормить'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}