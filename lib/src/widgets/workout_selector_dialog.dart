// lib/src/views/widgets/workout_selector_dialog.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';

class WorkoutSelectorDialog extends StatefulWidget {
  final Function(String level, String goal, int daysPerWeek, String? focusMuscleGroup, String? additionalDetails) onGeneratePressed;
  
  const WorkoutSelectorDialog({
    Key? key,
    required this.onGeneratePressed,
  }) : super(key: key);

  @override
  State<WorkoutSelectorDialog> createState() => _WorkoutSelectorDialogState();
}

class _WorkoutSelectorDialogState extends State<WorkoutSelectorDialog> {
  // Opciones seleccionadas
  String selectedLevel = 'Intermedio';
  String selectedGoal = 'Hipertrofia';
  int selectedDays = 4;
  String selectedMuscleGroup = 'Todos';
  final TextEditingController detailsController = TextEditingController();
  
  // Opciones disponibles
  final List<String> levels = ['Principiante', 'Intermedio', 'Avanzado'];
  final List<String> goals = ['Pérdida de peso', 'Hipertrofia', 'Definición', 'Fuerza', 'Mantenimiento'];
  final List<int> daysOptions = [3, 4, 5, 6];
  final List<String> muscleGroups = ['Todos', 'Piernas', 'Pecho', 'Espalda', 'Brazos', 'Hombros', 'Core'];

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF242038),
              Color(0xFF35305B),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Crear rutina personalizada",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Contenido con scroll para pantallas pequeñas
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nivel de experiencia
                    _buildSectionTitle("Nivel de experiencia"),
                    const SizedBox(height: 8),
                    _buildOptionSelector(
                      options: levels,
                      selectedOption: selectedLevel,
                      onOptionSelected: (value) {
                        setState(() {
                          selectedLevel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Objetivo
                    _buildSectionTitle("Objetivo"),
                    const SizedBox(height: 8),
                    _buildOptionSelector(
                      options: goals,
                      selectedOption: selectedGoal,
                      onOptionSelected: (value) {
                        setState(() {
                          selectedGoal = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Días por semana
                    _buildSectionTitle("Días por semana"),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: daysOptions.map((days) {
                        return _buildDayOption(
                          days: days,
                          isSelected: selectedDays == days,
                          onSelected: () {
                            setState(() {
                              selectedDays = days;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Grupo muscular de enfoque
                    _buildSectionTitle("Enfoque muscular (opcional)"),
                    const SizedBox(height: 8),
                    Container(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: muscleGroups.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: _buildMuscleGroupChip(
                              muscleGroup: muscleGroups[index],
                              isSelected: selectedMuscleGroup == muscleGroups[index],
                              onSelected: () {
                                setState(() {
                                  selectedMuscleGroup = muscleGroups[index];
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Detalles adicionales
                    _buildSectionTitle("Detalles adicionales (opcional)"),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: detailsController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "Ej: Con poco equipamiento, para entrenar en casa...",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botón de generar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Cerrar el diálogo
                  
                  // Llamar a la función con los parámetros seleccionados
                  widget.onGeneratePressed(
                    selectedLevel,
                    selectedGoal,
                    selectedDays,
                    selectedMuscleGroup == 'Todos' ? null : selectedMuscleGroup,
                    detailsController.text.isEmpty ? null : detailsController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9067C6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "GENERAR RUTINA",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
  
  Widget _buildOptionSelector({
    required List<String> options,
    required String selectedOption,
    required Function(String) onOptionSelected,
  }) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selectedOption == option;
          
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onOptionSelected(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF9067C6) : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF9067C6) : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildDayOption({
    required int days,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9067C6) : Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF9067C6) : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            days.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMuscleGroupChip({
    required String muscleGroup,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9067C6) : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF9067C6) : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Text(
          muscleGroup,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}