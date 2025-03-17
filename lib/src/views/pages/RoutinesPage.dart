import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:amicons/amicons.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:nebula/src/models/training.model.dart';

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

  // Day names
  final List<String> dayNamesSpanish = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  final List<String> dayNamesEnglish = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();

    Get.find<EntrenamientoController>()
        .cargarEntrenamientos(); // Añade esta línea
    _calculateCurrentWeekMonday();
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
    return dayNamesSpanish[date.weekday - 1];
  }

  // Get the short day name in English for a given date (used for data mapping)
  String _getShortDayNameEnglish(DateTime date) {
    return dayNamesEnglish[date.weekday - 1];
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
  bool _hasWorkoutForSelectedDay(Entrenamiento? entrenamiento) {
    if (entrenamiento == null) return false;
    String dayName = dayNamesEnglish[_selectedDate.weekday - 1];
    // Filter exercises that belong to the selected day
    return entrenamiento.ejercicios
        .any((ejercicio) => ejercicio.dia == dayName);
  }

  // Get the workouts for the selected day in the current routine
  List<Ejercicio> _getWorkoutsForSelectedDay(Entrenamiento? entrenamiento) {
    if (entrenamiento == null) return [];

    final String dayName = _getShortDayNameEnglish(_selectedDate);
    // Filter exercises that belong to the selected day
    return entrenamiento.ejercicios
        .where((ejercicio) => ejercicio.dia == dayName)
        .toList();
  }

  // Improved modal for adding a workout
  void _addWorkout(EntrenamientoController controller) {
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
                    if (controller.entrenamientoActual != null) {
                      // Crear un nuevo ejercicio
                      final ejercicio = Ejercicio(
                        id: '', // Firebase generará el ID
                        nombre: nameController.text.isEmpty
                            ? 'Nuevo ejercicio'
                            : nameController.text,
                        series: int.tryParse(setsController.text) ?? 3,
                        repeticiones: repsController.text.isEmpty
                            ? '10-12'
                            : repsController.text,
                        dia: dayName,
                      );

                      // Añadir el ejercicio al entrenamiento actual
                      controller.agregarEjercicio(ejercicio);
                    }
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

  void _createRoutine(EntrenamientoController controller) {
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
                  onPressed: () async {
                    String nombre = _routineNameController.text.isEmpty
                        ? 'Nueva Rutina ${controller.entrenamientos.length + 1}'
                        : _routineNameController.text;
// Crear una nueva rutina y cargarla
                    String? nuevaRutinaId =
                        await controller.crearEntrenamiento(nombre);
                    if (nuevaRutinaId != null) {
                      await controller.cargarEntrenamientos();
                      controller.seleccionarEntrenamiento(nuevaRutinaId);
                    }

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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EntrenamientoController>();
    return Scaffold(
      backgroundColor: const Color(0xFF18141C),
      body: SafeArea(
        child: Column(
          children: [
            // Top header with week navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Week navigation buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Color(0xFF9067C6), size: 16),
                        onPressed: _prevWeek,
                      ),
                      Text(
                        'Semana ${DateFormat('d MMM', 'es').format(_currentWeekMonday)} - ${DateFormat('d MMM', 'es').format(_currentWeekMonday.add(const Duration(days: 6)))}',
                        style: const TextStyle(
                          color: Color(0xFFF7ECE1),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Color(0xFF9067C6), size: 16),
                        onPressed: _nextWeek,
                      ),
                    ],
                  ),
                  // Dropdown or selector for current routine
                  controller.entrenamientoActual != null
                      ? GestureDetector(
                          onTap: () {
                            // Show routine selector
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: const Color(0xFF242038),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, bottom: 12),
                                      child: Text(
                                        'Seleccionar Rutina',
                                        style: TextStyle(
                                          color: Color(0xFFF7ECE1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Color(0xFF333333)),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          controller.entrenamientos.length,
                                      itemBuilder: (context, index) {
                                        final entrenamiento =
                                            controller.entrenamientos[index];
                                        final isSelected = controller
                                                .entrenamientoActual?.id ==
                                            entrenamiento.id;
                                        return ListTile(
                                          title: Text(
                                            entrenamiento.nombre,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? const Color(0xFF9067C6)
                                                  : const Color(0xFFF7ECE1),
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          leading: Icon(
                                            Amicons.iconly_activity,
                                            color: isSelected
                                                ? const Color(0xFF9067C6)
                                                : const Color(0xFFCAC4CE),
                                            size: 20,
                                          ),
                                          trailing: isSelected
                                              ? const Icon(Icons.check_circle,
                                                  color: Color(0xFF9067C6))
                                              : null,
                                          onTap: () {
                                            controller.seleccionarEntrenamiento(
                                                entrenamiento.id);
                                            Navigator.pop(context);
                                            setState(
                                                () {}); // Force rebuild after pop
                                          },
                                          // Long press to delete routine
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor:
                                                    const Color(0xFF242038),
                                                title: const Text(
                                                  'Eliminar Rutina',
                                                  style: TextStyle(
                                                      color: Color(0xFFF7ECE1)),
                                                ),
                                                content: Text(
                                                  '¿Estás seguro de eliminar la rutina "${entrenamiento.nombre}"?',
                                                  style: const TextStyle(
                                                      color: Color(0xFFCAC4CE)),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child:
                                                        const Text('Cancelar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await controller
                                                          .eliminarEntrenamiento(
                                                              entrenamiento.id);
                                                      Navigator.pop(
                                                          context); // Close delete dialog
                                                      Navigator.pop(
                                                          context); // Close routine selector
                                                    },
                                                    child: const Text(
                                                        'Eliminar',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    // Button to create a new routine
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _createRoutine(controller);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF9067C6),
                                          foregroundColor:
                                              const Color(0xFFF7ECE1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                        ),
                                        child: const Text('Nueva Rutina'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9067C6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                      const Color(0xFF9067C6).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  controller.entrenamientoActual!.nombre,
                                  style: const TextStyle(
                                    color: Color(0xFF9067C6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(Icons.keyboard_arrow_down,
                                    color: Color(0xFF9067C6), size: 16),
                              ],
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => _createRoutine(controller),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9067C6),
                            foregroundColor: const Color(0xFFF7ECE1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          child: const Text('Nueva Rutina'),
                        ),
                ],
              ),
            ),

            // Calendar week view
            Container(
              height: 90,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final day = _currentWeekMonday.add(Duration(days: index));
                  final isSelected = _selectedDate.day == day.day &&
                      _selectedDate.month == day.month &&
                      _selectedDate.year == day.year;
                  final bool hasWorkout =
                      controller.entrenamientoActual != null &&
                          controller.entrenamientoActual!.ejercicios.any(
                              (ejercicio) =>
                                  ejercicio.dia ==
                                  dayNamesEnglish[day.weekday - 1]);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF9067C6)
                            : hasWorkout
                                ? const Color(0xFF9067C6).withOpacity(0.15)
                                : const Color(0xFF242038),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : hasWorkout
                                  ? const Color(0xFF9067C6).withOpacity(0.3)
                                  : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(day).substring(0, 3),
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFF7ECE1)
                                  : hasWorkout
                                      ? const Color(0xFF9067C6)
                                      : const Color(0xFFCAC4CE),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFFF7ECE1)
                                      : hasWorkout
                                          ? const Color(0xFF9067C6)
                                          : const Color(0xFFF7ECE1),
                                  fontWeight: isSelected || hasWorkout
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main content area
            Expanded(
              child: controller.entrenamientoActual == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Amicons.iconly_activity,
                            size: 50,
                            color: const Color(0xFF9067C6).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No tienes rutinas creadas',
                            style: TextStyle(
                              color: Color(0xFFF7ECE1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Crea una nueva rutina para comenzar',
                            style: TextStyle(
                              color: Color(0xFFCAC4CE),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => _createRoutine(controller),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9067C6),
                              foregroundColor: const Color(0xFFF7ECE1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Nueva Rutina'),
                          ),
                        ],
                      ),
                    )
                  : _hasWorkoutForSelectedDay(controller.entrenamientoActual)
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _getWorkoutsForSelectedDay(
                                  controller.entrenamientoActual)
                              .length,
                          itemBuilder: (context, index) {
                            final ejercicio = _getWorkoutsForSelectedDay(
                                controller.entrenamientoActual)[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF242038),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                title: Text(
                                  ejercicio.nombre,
                                  style: const TextStyle(
                                    color: Color(0xFFF7ECE1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${ejercicio.series} series x ${ejercicio.repeticiones} repeticiones',
                                    style: const TextStyle(
                                      color: Color(0xFFCAC4CE),
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Edit button
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Color(0xFF9067C6), size: 20),
                                      onPressed: () {
                                        // Show edit dialog similar to add workout
                                        final nameController =
                                            TextEditingController(
                                                text: ejercicio.nombre);
                                        final setsController =
                                            TextEditingController(
                                                text: ejercicio.series
                                                    .toString());
                                        final repsController =
                                            TextEditingController(
                                                text: ejercicio.repeticiones);

                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor:
                                                const Color(0xFF242038),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: const Row(
                                              children: [
                                                Icon(Amicons.iconly_activity,
                                                    color: Color(0xFF9067C6),
                                                    size: 22),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Editar Ejercicio',
                                                  style: TextStyle(
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 8),
                                                    child: Text(
                                                      'Modifica los detalles del ejercicio',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFCAC4CE),
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  // Exercise name input
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.08),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.15)),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 5),
                                                    child: TextField(
                                                      controller:
                                                          nameController,
                                                      style: const TextStyle(
                                                          color: Color(
                                                              0xFFF7ECE1)),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Nombre del ejercicio',
                                                        hintStyle: TextStyle(
                                                          color: const Color(
                                                                  0xFFCAC4CE)
                                                              .withOpacity(0.8),
                                                          fontSize: 15,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        prefixIcon: Icon(
                                                          Icons.fitness_center,
                                                          color: const Color(
                                                                  0xFFCAC4CE)
                                                              .withOpacity(0.8),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.08),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.15)),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 5),
                                                          child: TextField(
                                                            controller:
                                                                setsController,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFFF7ECE1)),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Series',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color: const Color(
                                                                        0xFFCAC4CE)
                                                                    .withOpacity(
                                                                        0.8),
                                                                fontSize: 15,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              prefixIcon: Icon(
                                                                Icons.repeat,
                                                                color: const Color(
                                                                        0xFFCAC4CE)
                                                                    .withOpacity(
                                                                        0.8),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.08),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.15)),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 5),
                                                          child: TextField(
                                                            controller:
                                                                repsController,
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xFFF7ECE1)),
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Repeticiones',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color: const Color(
                                                                        0xFFCAC4CE)
                                                                    .withOpacity(
                                                                        0.8),
                                                                fontSize: 15,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .format_list_numbered,
                                                                color: const Color(
                                                                        0xFFCAC4CE)
                                                                    .withOpacity(
                                                                        0.8),
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
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      style:
                                                          TextButton.styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          side: BorderSide(
                                                            color: const Color(
                                                                    0xFFCAC4CE)
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                      ),
                                                      child: Text(
                                                        'Cancelar',
                                                        style: TextStyle(
                                                          color: const Color(
                                                                  0xFFCAC4CE)
                                                              .withOpacity(0.8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Update the exercise
                                                        final updatedEjercicio =
                                                            Ejercicio(
                                                          id: ejercicio.id,
                                                          nombre: nameController
                                                                  .text.isEmpty
                                                              ? ejercicio.nombre
                                                              : nameController
                                                                  .text,
                                                          series: int.tryParse(
                                                                  setsController
                                                                      .text) ??
                                                              ejercicio.series,
                                                          repeticiones:
                                                              repsController
                                                                      .text
                                                                      .isEmpty
                                                                  ? ejercicio
                                                                      .repeticiones
                                                                  : repsController
                                                                      .text,
                                                          dia: ejercicio.dia,
                                                        );

                                                        controller
                                                            .actualizarEjercicio(
                                                                updatedEjercicio);
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF9067C6),
                                                        foregroundColor:
                                                            const Color(
                                                                0xFFF7ECE1),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                      ),
                                                      child:
                                                          const Text('Guardar'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            actionsPadding:
                                                const EdgeInsets.fromLTRB(
                                                    20, 0, 20, 20),
                                          ),
                                        );
                                      },
                                    ),
                                    // Delete button
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent, size: 20),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor:
                                                const Color(0xFF242038),
                                            title: const Text(
                                              'Eliminar Ejercicio',
                                              style: TextStyle(
                                                  color: Color(0xFFF7ECE1)),
                                            ),
                                            content: Text(
                                              '¿Estás seguro de eliminar el ejercicio "${ejercicio.nombre}"?',
                                              style: const TextStyle(
                                                  color: Color(0xFFCAC4CE)),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller.eliminarEjercicio(
                                                      ejercicio.id);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Eliminar',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 50,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay ejercicios para ${_getDayName(_selectedDate)}',
                                style: const TextStyle(
                                  color: Color(0xFFF7ECE1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Agrega ejercicios a tu rutina para este día',
                                style: TextStyle(
                                  color: Color(0xFFCAC4CE),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => _addWorkout(controller),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9067C6),
                                  foregroundColor: const Color(0xFFF7ECE1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: const Text('Agregar Ejercicio'),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
      // FAB to add workout for the currently selected day
      floatingActionButton: controller.entrenamientoActual == null
          ? null
          : FloatingActionButton(
              onPressed: () => _addWorkout(controller),
              backgroundColor: const Color(0xFF9067C6),
              child: const Icon(Icons.add, color: Color(0xFFF7ECE1)),
            ),
    );
  }

  @override
  void dispose() {
    _routineNameController.dispose();
    super.dispose();
  }
}
