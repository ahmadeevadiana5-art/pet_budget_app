import 'package:flutter/material.dart';
import 'game/pet/pet.dart';
import 'game/pet/pet_manager.dart';
import 'game/pet/in_memory_pet_storage.dart';
import 'game/tasks/task_manager.dart';
import 'game/tasks/consequence_manager.dart';
import 'ui/screens/task_screen.dart';
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

/// Временный экран для проверки PetWidget + TaskScreen.
/// В финале его заменит настоящий HomeScreen (Маша).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PetManager _petManager;
  late ConsequenceManager _consequenceManager;
  late TaskManager _taskManager;
  Pet? _pet;

  @override
  void initState() {
    super.initState();
    _petManager = PetManager(storage: InMemoryPetStorage());
    _consequenceManager = ConsequenceManager(petManager: _petManager);
    _taskManager = TaskManager(consequenceManager: _consequenceManager);
    _createTestPet();
  }

  Future<void> _createTestPet() async {
    final pet = await _petManager.createPet(
      id: '1',
      type: PetType.cat,
      color: PetColor.red,
      name: 'Барсик',
    );
    setState(() => _pet = pet);
  }

  Future<void> _feed() async {
    final pet = await _petManager.feed();
    setState(() => _pet = pet);
  }

  void _openTask() {
    final task = _taskManager.getTaskForPeriod(1);
    if (task == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет заданий для этого периода')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskScreen(
          task: task,
          taskManager: _taskManager,
          onCompleted: () {
            Navigator.of(context).pop();
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверка')),
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
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _openTask,
                      icon: const Icon(Icons.assignment),
                      label: const Text('Показать задание'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}