import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:amicons/amicons.dart';

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({Key? key}) : super(key: key);

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  // Current week's Monday date
  late DateTime _currentWeekMonday;

  // Selected day in the calendar
  late DateTime _selectedDate;

  // Controller for routine name input
  final TextEditingController _routineNameController = TextEditingController();

  // Index of the currently selected routine
  int _selectedRoutineIndex = 0;

  // Mock data for routines
  final List<Map<String, dynamic>> _routines = [
    {
      'name': 'Rutina de Fuerza',
      'workouts': {
        'Monday': [
          {'name': 'Press de Banca', 'sets': 4, 'reps': '8-10'},
          {'name': 'Sentadillas', 'sets': 4, 'reps': '8-10'},
          {'name': 'Dominadas', 'sets': 3, 'reps': '8-10'},
        ],
        'Wednesday': [
          {'name': 'Press Militar', 'sets': 4, 'reps': '8-10'},
          {'name': 'Peso Muerto', 'sets': 4, 'reps': '6-8'},
          {'name': 'Remo con Barra', 'sets': 3, 'reps': '8-10'},
        ],
        'Friday': [
          {'name': 'Fondos en Paralelas', 'sets': 3, 'reps': '8-12'},
          {'name': 'Curl de Bíceps', 'sets': 3, 'reps': '10-12'},
          {'name': 'Extensiones de Tríceps', 'sets': 3, 'reps': '10-12'},
        ],
      }
    },
    {
      'name': 'Rutina de Hipertrofia',
      'workouts': {
        'Monday': [
          {'name': 'Pecho y Bíceps', 'sets': 4, 'reps': '10-12'},
        ],
        'Tuesday': [
          {'name': 'Espalda y Tríceps', 'sets': 4, 'reps': '10-12'},
        ],
        'Thursday': [
          {'name': 'Piernas', 'sets': 4, 'reps': '12-15'},
        ],
        'Friday': [
          {'name': 'Hombros y Abdominales', 'sets': 4, 'reps': '12-15'},
        ],
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    _calculateCurrentWeekMonday();
    _selectedDate = _currentWeekMonday;
  }

  // Calculate the Monday date of the current week
  void _calculateCurrentWeekMonday() {
    final now = DateTime.now();
    final int currentWeekday = now.weekday;
    _currentWeekMonday = now.subtract(Duration(days: currentWeekday - 1));
  }

  // Get the day name in Spanish for a given date
  String _getDayName(DateTime date) {
    final List<String> dayNames = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    return dayNames[date.weekday - 1];
  }

  // Get the short day name in English for a given date (used for data mapping)
  String _getShortDayNameEnglish(DateTime date) {
    final List<String> dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return dayNames[date.weekday - 1];
  }

  // Navigate to the previous week
  void _prevWeek() {
    setState(() {
      _currentWeekMonday = _currentWeekMonday.subtract(const Duration(days: 7));
      _selectedDate = _currentWeekMonday;
    });
  }

  // Navigate to the next week
  void _nextWeek() {
    setState(() {
      _currentWeekMonday = _currentWeekMonday.add(const Duration(days: 7));
      _selectedDate = _currentWeekMonday;
    });
  }

  // Check if a workout exists for the selected day in the currently selected routine
  bool _hasWorkoutForSelectedDay() {
    final String dayName = _getShortDayNameEnglish(_selectedDate);
    return _routines[_selectedRoutineIndex]['workouts'].containsKey(dayName);
  }

  // Get the workouts for the selected day in the current routine
  List<Map<String, dynamic>> _getWorkoutsForSelectedDay() {
    final String dayName = _getShortDayNameEnglish(_selectedDate);
    if (_hasWorkoutForSelectedDay()) {
      return List<Map<String, dynamic>>.from(
          _routines[_selectedRoutineIndex]['workouts'][dayName]);
    }
    return [];
  }

  // Improved modal for adding a workout
  void _addWorkout() {
    final String dayName = _getShortDayNameEnglish(_selectedDate);
    final String displayDayName = _getDayName(_selectedDate);

    final nameController = TextEditingController();
    final setsController = TextEditingController(text: "3");
    final repsController = TextEditingController(text: "10-12");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242038),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Amicons.iconly_activity,
                color: Color(0xFF9067C6), size: 22),
            const SizedBox(width: 10),
            Text(
              'Agregar Ejercicio - $displayDayName',
              style: const TextStyle(
                color: Color(0xFFF7ECE1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Añade un nuevo ejercicio a tu rutina',
                  style: TextStyle(color: Color(0xFFCAC4CE), fontSize: 14),
                ),
              ),
              const SizedBox(height: 12),
              // Exercise name input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Color(0xFFF7ECE1)),
                  decoration: InputDecoration(
                    hintText: 'Nombre del ejercicio',
                    hintStyle: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.fitness_center,
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Sets and reps inputs
              Row(
                children: [
                  // Sets input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: TextField(
                        controller: setsController,
                        style: const TextStyle(color: Color(0xFFF7ECE1)),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Series',
                          hintStyle: TextStyle(
                            color: const Color(0xFFCAC4CE).withOpacity(0.8),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.repeat,
                            color: const Color(0xFFCAC4CE).withOpacity(0.8),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Reps input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: TextField(
                        controller: repsController,
                        style: const TextStyle(color: Color(0xFFF7ECE1)),
                        decoration: InputDecoration(
                          hintText: 'Repeticiones',
                          hintStyle: TextStyle(
                            color: const Color(0xFFCAC4CE).withOpacity(0.8),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.format_list_numbered,
                            color: const Color(0xFFCAC4CE).withOpacity(0.8),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFFCAC4CE).withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!_routines[_selectedRoutineIndex]['workouts']
                          .containsKey(dayName)) {
                        _routines[_selectedRoutineIndex]['workouts']
                            [dayName] = [];
                      }

                      _routines[_selectedRoutineIndex]['workouts'][dayName]
                          .add({
                        'name': nameController.text.isEmpty
                            ? 'Nuevo ejercicio'
                            : nameController.text,
                        'sets': int.tryParse(setsController.text) ?? 3,
                        'reps': repsController.text.isEmpty
                            ? '10-12'
                            : repsController.text,
                      });
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9067C6),
                    foregroundColor: const Color(0xFFF7ECE1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }

  void _createRoutine() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242038),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Amicons.iconly_activity, color: Color(0xFF9067C6), size: 22),
            SizedBox(width: 10),
            Text(
              'Nueva Rutina',
              style: TextStyle(
                color: Color(0xFFF7ECE1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Crea una nueva rutina para tus entrenamientos',
                  style: TextStyle(color: Color(0xFFCAC4CE), fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextField(
                  controller: _routineNameController,
                  style: const TextStyle(color: Color(0xFFF7ECE1)),
                  decoration: InputDecoration(
                    hintText: 'Nombre de la rutina',
                    hintStyle: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.edit_note,
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _routineNameController.clear();
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFFCAC4CE).withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _routines.add({
                        'name': _routineNameController.text.isEmpty
                            ? 'Nueva Rutina ${_routines.length + 1}'
                            : _routineNameController.text,
                        'workouts': {},
                      });
                      _selectedRoutineIndex = _routines.length - 1;
                    });
                    Navigator.pop(context);
                    _routineNameController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9067C6),
                    foregroundColor: const Color(0xFFF7ECE1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Crear'),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }

  // Edit a workout
  void _editWorkout(int index) {
    final String dayName = _getShortDayNameEnglish(_selectedDate);
    final workout = _getWorkoutsForSelectedDay()[index];

    final nameController = TextEditingController(text: workout['name']);
    final setsController =
        TextEditingController(text: workout['sets'].toString());
    final repsController = TextEditingController(text: workout['reps']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242038),
        title: const Text(
          'Editar Ejercicio',
          style: TextStyle(color: Color(0xFFF7ECE1)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Color(0xFFF7ECE1)),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle:
                    TextStyle(color: const Color(0xFFCAC4CE).withOpacity(0.8)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF9067C6)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setsController,
                    style: const TextStyle(color: Color(0xFFF7ECE1)),
                    decoration: InputDecoration(
                      labelText: 'Series',
                      labelStyle: TextStyle(
                          color: const Color(0xFFCAC4CE).withOpacity(0.8)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9067C6)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    style: const TextStyle(color: Color(0xFFF7ECE1)),
                    decoration: InputDecoration(
                      labelText: 'Repeticiones',
                      labelStyle: TextStyle(
                          color: const Color(0xFFCAC4CE).withOpacity(0.8)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9067C6)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: const Color(0xFFCAC4CE).withOpacity(0.8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _routines[_selectedRoutineIndex]['workouts'][dayName][index] = {
                  'name': nameController.text,
                  'sets': int.tryParse(setsController.text) ?? workout['sets'],
                  'reps': repsController.text.isEmpty
                      ? workout['reps']
                      : repsController.text,
                };
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9067C6),
              foregroundColor: const Color(0xFFF7ECE1),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Delete a workout
  void _deleteWorkout(int index) {
    final String dayName = _getShortDayNameEnglish(_selectedDate);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242038),
        title: const Text(
          '¿Eliminar ejercicio?',
          style: TextStyle(color: Color(0xFFF7ECE1)),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este ejercicio?',
          style: TextStyle(color: Color(0xFFCAC4CE)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: const Color(0xFFCAC4CE).withOpacity(0.8)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _routines[_selectedRoutineIndex]['workouts'][dayName]
                    .removeAt(index);

                // If no workouts left for that day, remove the day entry
                if (_routines[_selectedRoutineIndex]['workouts'][dayName]
                    .isEmpty) {
                  _routines[_selectedRoutineIndex]['workouts'].remove(dayName);
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: const Color(0xFFF7ECE1),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _deleteRoutine() {
    if (_routines.length <= 1) {
      // Don't allow deleting the last routine
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes eliminar la última rutina'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242038),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red.shade400, size: 22),
            const SizedBox(width: 10),
            const Text(
              '¿Eliminar rutina?',
              style: TextStyle(
                color: Color(0xFFF7ECE1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Estás seguro de que deseas eliminar la rutina "${_routines[_selectedRoutineIndex]['name']}"?',
                style: const TextStyle(color: Color(0xFFCAC4CE), fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                'Esta acción no se puede deshacer.',
                style: TextStyle(
                    color: Color(0xFFCAC4CE),
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFFCAC4CE).withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _routines.removeAt(_selectedRoutineIndex);
                      _selectedRoutineIndex =
                          0; // Select the first routine after deletion
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: const Color(0xFFF7ECE1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Eliminar'),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }

  void _renameRoutine() {
    final TextEditingController controller = TextEditingController(
      text: _routines[_selectedRoutineIndex]['name'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF242038),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: Color(0xFF9067C6), size: 22),
            SizedBox(width: 10),
            Text(
              'Renombrar Rutina',
              style: TextStyle(
                color: Color(0xFFF7ECE1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Cambia el nombre de tu rutina actual',
                  style: TextStyle(color: Color(0xFFCAC4CE), fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Color(0xFFF7ECE1)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.edit_note,
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFFCAC4CE).withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _routines[_selectedRoutineIndex]['name'] =
                          controller.text.isEmpty
                              ? 'Rutina ${_selectedRoutineIndex + 1}'
                              : controller.text;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9067C6),
                    foregroundColor: const Color(0xFFF7ECE1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Custom app bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF242038).withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Programación de Rutina",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF7ECE1),
                  ),
                ),
                PopupMenuButton<String>(
                  color: const Color(0xFF242038),
                  icon: Icon(
                    Icons.more_vert,
                    color: const Color(0xFFF7ECE1).withOpacity(0.9),
                  ),
                  onSelected: (value) {
                    if (value == 'create') {
                      _createRoutine();
                    } else if (value == 'rename') {
                      _renameRoutine();
                    } else if (value == 'delete') {
                      _deleteRoutine();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'create',
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              color: const Color(0xFFF7ECE1).withOpacity(0.9),
                              size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Nueva Rutina',
                            style: TextStyle(
                                color:
                                    const Color(0xFFF7ECE1).withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'rename',
                      child: Row(
                        children: [
                          Icon(Icons.edit,
                              color: const Color(0xFFF7ECE1).withOpacity(0.9),
                              size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Renombrar',
                            style: TextStyle(
                                color:
                                    const Color(0xFFF7ECE1).withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              color: Colors.red.shade400, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red.shade400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Routine selector
                    _buildRoutineSelector(),
                    const SizedBox(height: 25),

                    // Week calendar
                    _buildWeekCalendar(),
                    const SizedBox(height: 25),

                    // Workout list for selected day
                    _buildWorkoutList(),

                    // Add workout button
                    const SizedBox(height: 30),
                    _buildAddWorkoutButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the routine selector dropdown
  Widget _buildRoutineSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: DropdownButton<int>(
        value: _selectedRoutineIndex,
        isExpanded: true,
        dropdownColor: const Color(0xFF242038),
        underline: Container(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFFF7ECE1).withOpacity(0.8),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFFF7ECE1),
        ),
        onChanged: (int? value) {
          if (value != null) {
            setState(() {
              _selectedRoutineIndex = value;
            });
          }
        },
        items: List.generate(
          _routines.length,
          (index) => DropdownMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Icon(
                  Amicons.iconly_activity,
                  color: const Color(0xFF9067C6),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(_routines[index]['name']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the week calendar
  Widget _buildWeekCalendar() {
    return Column(
      children: [
        // Week navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _prevWeek,
                icon: const Icon(Icons.chevron_left, color: Color(0xFFF7ECE1)),
              ),
              Text(
                "${DateFormat('d MMM').format(_currentWeekMonday)} - ${DateFormat('d MMM').format(_currentWeekMonday.add(const Duration(days: 6)))}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                ),
              ),
              IconButton(
                onPressed: _nextWeek,
                icon: const Icon(Icons.chevron_right, color: Color(0xFFF7ECE1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Days of the week
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = _currentWeekMonday.add(Duration(days: index));
              final isSelected = day.day == _selectedDate.day &&
                  day.month == _selectedDate.month &&
                  day.year == _selectedDate.year;

              final String dayKey = _getShortDayNameEnglish(day);
              final bool hasWorkout = _routines[_selectedRoutineIndex]
                      ['workouts']
                  .containsKey(dayKey);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF9067C6)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: hasWorkout && !isSelected
                          ? const Color(0xFF9067C6).withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDayName(day).substring(0, 3),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFF7ECE1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white
                              : hasWorkout
                                  ? const Color(0xFF9067C6).withOpacity(0.3)
                                  : Colors.transparent,
                        ),
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF9067C6)
                                : hasWorkout
                                    ? Colors.white
                                    : const Color(0xFFF7ECE1),
                          ),
                        ),
                      ),
                      if (hasWorkout && !isSelected)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF9067C6),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Build the workout list for selected day
  Widget _buildWorkoutList() {
    final workouts = _getWorkoutsForSelectedDay();
    final String dayName = _getDayName(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ejercicios para $dayName",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF7ECE1),
              ),
            ),
            if (_hasWorkoutForSelectedDay())
              TextButton.icon(
                onPressed: () {
                  final String dayKey = _getShortDayNameEnglish(_selectedDate);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF242038),
                      title: Text(
                        '¿Eliminar todos los ejercicios del $dayName?',
                        style: const TextStyle(color: Color(0xFFF7ECE1)),
                      ),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar todos los ejercicios de este día?',
                        style: TextStyle(color: Color(0xFFCAC4CE)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                                color:
                                    const Color(0xFFCAC4CE).withOpacity(0.8)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _routines[_selectedRoutineIndex]['workouts']
                                  .remove(dayKey);
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: const Color(0xFFF7ECE1),
                          ),
                          child: const Text('Eliminar todos'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_sweep,
                  color: Colors.red.shade400,
                  size: 16,
                ),
                label: Text(
                  'Borrar todos',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        if (workouts.isEmpty)
          Container(
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center,
                  color: const Color(0xFFCAC4CE).withOpacity(0.5),
                  size: 32,
                ),
                const SizedBox(height: 10),
                Text(
                  "No hay ejercicios para este día",
                  style: TextStyle(
                    color: const Color(0xFFCAC4CE).withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9067C6).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Amicons.iconly_activity,
                      color: Color(0xFF9067C6),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    workout['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF7ECE1),
                    ),
                  ),
                  subtitle: Text(
                    "${workout['sets']} series × ${workout['reps']} repeticiones",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFFCAC4CE).withOpacity(0.9),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: const Color(0xFFCAC4CE).withOpacity(0.8),
                          size: 20,
                        ),
                        onPressed: () => _editWorkout(index),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade400,
                          size: 20,
                        ),
                        onPressed: () => _deleteWorkout(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // Build the add workout button
  Widget _buildAddWorkoutButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _addWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9067C6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text(
          "Agregar Ejercicio",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
