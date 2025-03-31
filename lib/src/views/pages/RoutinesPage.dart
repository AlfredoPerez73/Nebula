import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/controllers/historyTraining.controller.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:flutter/services.dart';
import 'package:nebula/src/models/historyExercises.model.dart';
import 'package:amicons/amicons.dart';

class Routinespage extends StatelessWidget {
  final EntrenamientoController controller = Get.put(EntrenamientoController());
  final HistoryEntrenamientoController hcontroller =
      Get.put(HistoryEntrenamientoController());

  // Datos constantes
  final List<String> diasSemanaCortos = [
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom'
  ];
  final List<String> diasSemanaCompletos = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  // Esquema de colores refinado
  final ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF6A3DE8),
    primaryContainer: Color(0xFF53379B),
    secondary: Color(0xFF8C65F7),
    secondaryContainer: Color(0xFF35244F),
    surface: Color(0xFF1E1728),
    background: Color(0xFF121016),
    error: Color(0xFFFF5252),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white70,
    onError: Colors.white,
    brightness: Brightness.dark,
  );

  // Estilos de texto consistentes
  final TextStyle titleStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  final TextStyle subtitleStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  final TextStyle bodyStyle = const TextStyle(
    fontSize: 14,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  );

  Routinespage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configuración del sistema para UI inmersiva
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: colorScheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.background,
              colorScheme.background.withOpacity(0.85),
              colorScheme.primaryContainer.withOpacity(0.3),
            ],
            stops: const [0.1, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Elementos decorativos en el fondo
            Positioned(
              top: -120,
              right: -100,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -60,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.05),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  _buildEnhancedAppBar(context),
                  Expanded(
                    child: GetBuilder<EntrenamientoController>(
                      init: controller,
                      builder: (controller) {
                        // Si está en proceso de carga, mostrar indicador
                        if (controller.cargando) {
                          return _buildEnhancedLoadingState();
                        }

                        // Si hay error, limpiar y reintentar
                        if (controller.tieneError) {
                          controller.limpiarError();
                          controller.cargarEntrenamientos();
                          return _buildEnhancedLoadingState(); // Mostrar carga mientras reintenta
                        }

                        // Si los datos ya se inicializaron pero están vacíos, mostrar estado vacío
                        if (controller.entrenamientos.isEmpty) {
                          return _buildEnhancedEmptyState(context);
                        }

                        // Si hay datos, mostrar el contenido
                        return _buildEnhancedContent();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildEnhancedFloatingButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // FAB Mejorado
  Widget _buildEnhancedFloatingButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _mostrarDialogoAgregarEjercicio(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: const Icon(
              Amicons.iconly_plus_curved_fill,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  // AppBar con diseño mejorado
  Widget _buildEnhancedAppBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.secondaryContainer.withOpacity(0.95),
            colorScheme.primaryContainer.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withOpacity(0.7),
                      colorScheme.primary.withOpacity(0.4),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Amicons.iconly_calendar_curved_fill,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                'Programación de Rutina',
                style: titleStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Amicons.iconly_more_circle_fill, size: 28),
              color: colorScheme.onSurface,
              onPressed: () => _mostrarOpcionesMenu(context),
              tooltip: 'Más opciones',
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }

  // Estado de carga mejorado
  Widget _buildEnhancedLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.secondary.withOpacity(0.1),
                  colorScheme.primary.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(15),
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
              backgroundColor: colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              'Cargando rutinas...',
              style: subtitleStyle.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Estado vacío mejorado
  Widget _buildEnhancedEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.secondary.withOpacity(0.1),
                    colorScheme.primary.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Amicons.flaticon_gym_rounded_fill,
                size: 70,
                color: colorScheme.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'No tienes entrenamientos creados',
              style: titleStyle.copyWith(
                color: colorScheme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Crea tu primer entrenamiento para comenzar a organizar tus rutinas de ejercicio.',
                style: bodyStyle.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            _buildEnhancedButton(
              'Crear Entrenamiento',
              Amicons.iconly_plus_curved_fill,
              () => _mostrarDialogoCrearEntrenamiento(context),
              colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  // Botón mejorado para acciones principales
  Widget _buildEnhancedButton(
      String text, IconData icon, VoidCallback onPressed, Color color) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color,
            Color.lerp(color, Colors.black, 0.2) ?? color,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: subtitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Contenido principal mejorado
  Widget _buildEnhancedContent() {
    return Column(
      children: [
        _buildEnhancedRoutineSelector(),
        _buildEnhancedDaySelector(),
        if (controller.entrenamientoActual != null) ...[
          _buildEnhancedExerciseHeader(),
          _buildEnhancedExerciseList(),
        ],
      ],
    );
  }

  // Selector de rutina con diseño mejorado
  Widget _buildEnhancedRoutineSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface.withOpacity(0.9),
            colorScheme.surface.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: colorScheme.surface,
            isExpanded: true,
            value: controller.entrenamientoActual?.id,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Amicons.iconly_arrow_down_curved_fill,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            hint: Row(
              children: [
                Icon(
                  Amicons.flaticon_gym_rounded_fill,
                  color: colorScheme.primary.withOpacity(0.7),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Text(
                  'Selecciona una rutina',
                  style: bodyStyle.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            style: subtitleStyle.copyWith(
              color: colorScheme.onSurface,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (String? value) {
              if (value != null) {
                controller.seleccionarEntrenamiento(value);
              }
            },
            items: controller.entrenamientos.map((entrenamiento) {
              return DropdownMenuItem<String>(
                value: entrenamiento.id,
                child: Row(
                  children: [
                    Icon(
                      Amicons.flaticon_gym_rounded_fill,
                      color: colorScheme.primary.withOpacity(0.7),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(entrenamiento.nombre),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

// Selector de días mejorado con fechas reales
  Widget _buildEnhancedDaySelector() {
    // Obtener la fecha actual
    final DateTime now = DateTime.now();

    // Encontrar el lunes de la semana actual (dia 1 = lunes, dia 7 = domingo)
    final DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: diasSemanaCortos.length,
        itemBuilder: (context, index) {
          final String diaCorto = diasSemanaCortos[index];
          final String diaCompleto = diasSemanaCompletos[index];

          // Calcular la fecha para este día de la semana
          final DateTime dateForThisDay =
              startOfWeek.add(Duration(days: index));
          final String dayNumber = dateForThisDay.day.toString();

          // Verificar si este día corresponde a hoy
          final bool isToday = dateForThisDay.day == now.day &&
              dateForThisDay.month == now.month &&
              dateForThisDay.year == now.year;

          // Usar la selección del controlador o por defecto seleccionar el día actual
          final bool isSelected = diaCompleto == controller.diaSeleccionado ||
              (controller.diaSeleccionado == null && isToday);

          return GestureDetector(
            onTap: () {
              controller.seleccionarDia(diaCompleto);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 65,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primaryContainer,
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.surface.withOpacity(0.95),
                          colorScheme.surface.withOpacity(0.8),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? colorScheme.primary.withOpacity(0.4)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: isSelected ? 1 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isToday && !isSelected
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : isSelected
                        ? null
                        : Border.all(
                            color: colorScheme.primary.withOpacity(0.1),
                            width: 1.5,
                          ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    diaCorto,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onBackground,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : (isToday
                              ? colorScheme.primary.withOpacity(0.1)
                              : colorScheme.surface.withOpacity(0.5)),
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: colorScheme.primary, width: 1)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        dayNumber,
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : (isToday
                                  ? colorScheme.primary
                                  : colorScheme.onSurface),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Encabezado de ejercicios mejorado
  Widget _buildEnhancedExerciseHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.secondaryContainer.withOpacity(0.9),
            colorScheme.secondaryContainer.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Amicons.lucide_dumbbell,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ejers. para ${controller.diaSeleccionado}',
                style: subtitleStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _confirmarBorrarTodosEjercicios(Get.context!),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Amicons.iconly_delete_curved_fill,
                        color: colorScheme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Borrar todos',
                        style: bodyStyle.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Lista de ejercicios mejorada
  Widget _buildEnhancedExerciseList() {
    return Expanded(
      child: controller.ejerciciosPorDia.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Amicons.flaticon_gym_rounded_fill,
                      size: 50,
                      color: colorScheme.onBackground.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      'No hay ejercicios para este día',
                      style: subtitleStyle.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.ejerciciosPorDia.length,
              itemBuilder: (context, index) {
                final ejercicio = controller.ejerciciosPorDia[index];
                return _buildEnhancedEjercicioCard(context, ejercicio);
              },
            ),
    );
  }

  // Tarjeta de ejercicio rediseñada
  Widget _buildEnhancedEjercicioCard(
      BuildContext context, Ejercicio ejercicio) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface.withOpacity(0.95),
            colorScheme.surface.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono del ejercicio
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withOpacity(0.3),
                    colorScheme.primary.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Amicons.flaticon_gym_rounded_fill,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Detalles del ejercicio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ejercicio.nombre,
                    style: subtitleStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${ejercicio.series} series × ${ejercicio.repeticiones} repeticiones',
                      style: bodyStyle.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Botones de acción
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  Amicons.iconly_edit_curved_fill,
                  colorScheme.secondary,
                  () => _mostrarDialogoEditarEjercicio(context, ejercicio),
                  'Editar',
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  Amicons.iconly_delete_curved_fill,
                  colorScheme.error,
                  () => _confirmarEliminarEjercicio(context, ejercicio.id),
                  'Eliminar',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Botón de acción para tarjetas de ejercicio
  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed, String tooltip) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  // Opción del menú
  Widget _buildMenuOption(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: subtitleStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Amicons.iconly_arrow_right_curved_fill,
                  color: color.withOpacity(0.7),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Campo de texto mejorado
  Widget _buildEnhancedTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    TextInputType keyboardType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: bodyStyle.copyWith(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          labelText: label,
          labelStyle: bodyStyle.copyWith(
            color: colorScheme.onBackground,
            fontSize: 16,
          ),
          hintText: hint,
          hintStyle: bodyStyle.copyWith(
            color: colorScheme.onBackground.withOpacity(0.5),
            fontSize: 15,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  // Diálogo para crear entrenamiento mejorado
  void _mostrarDialogoCrearEntrenamiento(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono y título
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Amicons.flaticon_gym_rounded_fill,
                  color: colorScheme.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Crear Entrenamiento',
                style: titleStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // Campo de texto para el nombre
              TextField(
                controller: nombreController,
                style: bodyStyle.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Nombre del entrenamiento',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon: Icon(Amicons.flaticon_gym_rounded_fill,
                      color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                autofocus: true,
              ),

              const SizedBox(height: 30),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                            color: colorScheme.onBackground.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Cancelar',
                        style: bodyStyle.copyWith(
                          color: colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Botón Crear
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.primaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (nombreController.text.isNotEmpty) {
                              controller
                                  .crearEntrenamiento(nombreController.text);
                              hcontroller
                                  .crearEntrenamiento(nombreController.text);
                              Navigator.pop(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'Crear',
                                style: subtitleStyle.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
      ),
    );
  }

  // Diálogo para agregar ejercicio mejorado
  void _mostrarDialogoAgregarEjercicio(BuildContext context) {
    final TextEditingController seriesController = TextEditingController();
    final TextEditingController repeticionesController =
        TextEditingController();
    String selectedDay = controller.diaSeleccionado;
    String? selectedEjercicio;

    // Lista de ejercicios predefinidos con íconos
    final List<Map<String, dynamic>> ejerciciosPredefinidos = [
      {'nombre': 'Sentadillas', 'icono': Amicons.lucide_activity},
      {'nombre': 'Press de Banca', 'icono': Amicons.lucide_dumbbell},
      {'nombre': 'Peso Muerto', 'icono': Amicons.flaticon_gym_rounded_fill},
      {'nombre': 'Curl de Bíceps', 'icono': Amicons.lucide_dumbbell},
      {
        'nombre': 'Extensión de Tríceps',
        'icono': Amicons.lucide_user_round_cog
      },
      {'nombre': 'Press de Hombros', 'icono': Amicons.lucide_dumbbell},
      {'nombre': 'Dominadas', 'icono': Amicons.lucide_activity},
      {'nombre': 'Fondos', 'icono': Amicons.vuesax_archive_minus},
      {
        'nombre': 'Plancha',
        'icono': Amicons.flaticon_rings_wedding_rounded_fill
      },
      {'nombre': 'Abdominales', 'icono': Amicons.remix_walk_fill},
      {
        'nombre': 'Zancadas',
        'icono': Amicons.flaticon_head_side_thinking_rounded
      },
      {'nombre': 'Peso de Piernas', 'icono': Amicons.lucide_brain},
      {'nombre': 'Press de Pecho', 'icono': Amicons.flaticon_gym_rounded_fill},
      {'nombre': 'Remo', 'icono': Amicons.remix_body_scan},
      {'nombre': 'Jumping Jacks', 'icono': Amicons.remix_walk_fill}
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícono y título
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withOpacity(0.2),
                        colorScheme.primary.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Amicons.iconly_plus_curved_fill,
                    color: colorScheme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Agregar Nuevo Ejercicio',
                  style: titleStyle.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Selector de ejercicio
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: colorScheme.surface,
                      menuMaxHeight: 300,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 15, right: 10),
                          child: Icon(
                            Amicons.lucide_dumbbell,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        border: InputBorder.none,
                        labelText: 'Selecciona un Ejercicio',
                        labelStyle: bodyStyle.copyWith(
                          color: colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      value: selectedEjercicio,
                      style: bodyStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hint: Text(
                        'Elige un ejercicio',
                        style: bodyStyle.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                      icon: Icon(
                        Amicons.iconly_arrow_down_curved_fill,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedEjercicio = newValue;
                        }
                      },
                      items: ejerciciosPredefinidos
                          .map<DropdownMenuItem<String>>((ejercicio) {
                        return DropdownMenuItem<String>(
                          value: ejercicio['nombre'],
                          child: Row(
                            children: [
                              Icon(
                                ejercicio['icono'],
                                color: colorScheme.primary.withOpacity(0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(ejercicio['nombre']),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Campo de series
                _buildEnhancedTextField(
                  seriesController,
                  'Número de Series',
                  'Ej: 3, 4',
                  Amicons.remix_restart,
                  TextInputType.number,
                ),

                const SizedBox(height: 25),

                // Campo de repeticiones
                _buildEnhancedTextField(
                  repeticionesController,
                  'Repeticiones por Serie',
                  'Ej: 10, 12, 15',
                  Amicons.remix_repeat,
                  TextInputType.text,
                ),

                const SizedBox(height: 35),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón Cancelar
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                              color: colorScheme.onBackground.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Cancelar',
                          style: bodyStyle.copyWith(
                            color: colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Botón Agregar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.primaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (selectedEjercicio != null &&
                                  seriesController.text.isNotEmpty &&
                                  repeticionesController.text.isNotEmpty) {
                                // Crear nuevo ejercicio
                                final ejercicio = Ejercicio(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  nombre: selectedEjercicio!,
                                  dia: selectedDay,
                                  series:
                                      int.tryParse(seriesController.text) ?? 0,
                                  repeticiones: repeticionesController.text,
                                );
                                final hejercicio = HistoryEjercicio(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  nombre: selectedEjercicio!,
                                  dia: selectedDay,
                                  series:
                                      int.tryParse(seriesController.text) ?? 0,
                                  repeticiones: repeticionesController.text,
                                );
                                controller.agregarEjercicio(ejercicio);
                                hcontroller.agregarEjercicio(hejercicio);
                                Navigator.pop(context);
                              } else {
                                // Mostrar mensaje de error si falta información
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Por favor, completa todos los campos',
                                    style:
                                        bodyStyle.copyWith(color: Colors.white),
                                  ),
                                  backgroundColor: colorScheme.error,
                                ));
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Amicons.iconly_plus_curved_fill,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Agregar',
                                    style: subtitleStyle.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }

  void _mostrarDialogoEditarEjercicio(
      BuildContext context, Ejercicio ejercicio) {
    final TextEditingController seriesController =
        TextEditingController(text: ejercicio.series.toString());
    final TextEditingController repeticionesController =
        TextEditingController(text: ejercicio.repeticiones);
    String selectedDay = ejercicio.dia;
    String? selectedEjercicio = ejercicio.nombre;
    String id = ejercicio.id;

    // Lista de ejercicios predefinidos con íconos
    final List<Map<String, dynamic>> ejerciciosPredefinidos = [
      {'nombre': 'Sentadillas', 'icono': Amicons.lucide_activity},
      {'nombre': 'Press de Banca', 'icono': Amicons.lucide_dumbbell},
      {'nombre': 'Peso Muerto', 'icono': Amicons.flaticon_gym_rounded_fill},
      {'nombre': 'Curl de Bíceps', 'icono': Amicons.lucide_dumbbell},
      {
        'nombre': 'Extensión de Tríceps',
        'icono': Amicons.lucide_user_round_cog
      },
      {'nombre': 'Press de Hombros', 'icono': Amicons.lucide_dumbbell},
      {'nombre': 'Dominadas', 'icono': Amicons.lucide_activity},
      {'nombre': 'Fondos', 'icono': Amicons.vuesax_archive_minus},
      {
        'nombre': 'Plancha',
        'icono': Amicons.flaticon_rings_wedding_rounded_fill
      },
      {'nombre': 'Abdominales', 'icono': Amicons.remix_walk_fill},
      {
        'nombre': 'Zancadas',
        'icono': Amicons.flaticon_head_side_thinking_rounded
      },
      {'nombre': 'Peso de Piernas', 'icono': Amicons.lucide_brain},
      {'nombre': 'Press de Pecho', 'icono': Amicons.flaticon_gym_rounded_fill},
      {'nombre': 'Remo', 'icono': Amicons.remix_body_scan},
      {'nombre': 'Jumping Jacks', 'icono': Amicons.remix_walk_fill}
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                colorScheme.surface.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: colorScheme.secondary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícono y título
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.secondary.withOpacity(0.2),
                        colorScheme.secondary.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Amicons.iconly_edit_curved_fill,
                    color: colorScheme.secondary,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Editar Ejercicio',
                  style: titleStyle.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Selector de ejercicio
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.secondary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: colorScheme.surface,
                      menuMaxHeight: 300,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 15, right: 10),
                          child: Icon(
                            Amicons.lucide_dumbbell,
                            color: colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                        border: InputBorder.none,
                        labelText: 'Selecciona un Ejercicio',
                        labelStyle: bodyStyle.copyWith(
                          color: colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      value: selectedEjercicio,
                      style: bodyStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hint: Text(
                        'Elige un ejercicio',
                        style: bodyStyle.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                      icon: Icon(
                        Amicons.iconly_arrow_down_curved_fill,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedEjercicio = newValue;
                        }
                      },
                      items: ejerciciosPredefinidos
                          .map<DropdownMenuItem<String>>((ejercicio) {
                        return DropdownMenuItem<String>(
                          value: ejercicio['nombre'],
                          child: Row(
                            children: [
                              Icon(
                                ejercicio['icono'],
                                color: colorScheme.secondary.withOpacity(0.8),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(ejercicio['nombre']),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Selector de día
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.secondary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      dropdownColor: colorScheme.surface,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        prefixIcon: Container(
                          margin: const EdgeInsets.only(left: 15, right: 10),
                          child: Icon(
                            Amicons.iconly_calendar_curved_fill,
                            color: colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                        border: InputBorder.none,
                        labelText: 'Día de Entrenamiento',
                        labelStyle: bodyStyle.copyWith(
                          color: colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      ),
                      value: selectedDay,
                      style: bodyStyle.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      icon: Icon(
                        Amicons.iconly_arrow_down_curved_fill,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedDay = newValue;
                        }
                      },
                      items: diasSemanaCompletos
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Campo de series - con color secundario para edición
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.secondary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: seriesController,
                    keyboardType: TextInputType.number,
                    style: bodyStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      border: InputBorder.none,
                      labelText: 'Número de Series',
                      labelStyle: bodyStyle.copyWith(
                        color: colorScheme.onBackground,
                        fontSize: 16,
                      ),
                      hintText: 'Ej: 3, 4',
                      hintStyle: bodyStyle.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(left: 15, right: 10),
                        child: Icon(
                          Amicons.remix_restart,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Campo de repeticiones - con color secundario para edición
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.background.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.secondary.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: repeticionesController,
                    style: bodyStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      border: InputBorder.none,
                      labelText: 'Repeticiones por Serie',
                      labelStyle: bodyStyle.copyWith(
                        color: colorScheme.onBackground,
                        fontSize: 16,
                      ),
                      hintText: 'Ej: 10, 12, 15',
                      hintStyle: bodyStyle.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.only(left: 15, right: 10),
                        child: Icon(
                          Amicons.remix_repeat,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón Cancelar
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                              color: colorScheme.onBackground.withOpacity(0.3)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          'Cancelar',
                          style: bodyStyle.copyWith(
                            color: colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Botón Actualizar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              colorScheme.secondary,
                              colorScheme.secondaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.secondary.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (selectedEjercicio != null &&
                                  seriesController.text.isNotEmpty &&
                                  repeticionesController.text.isNotEmpty) {
                                // Crear ejercicio actualizado
                                final ejercicioActualizado = Ejercicio(
                                  id: id,
                                  nombre: selectedEjercicio!,
                                  dia: selectedDay,
                                  series:
                                      int.tryParse(seriesController.text) ?? 0,
                                  repeticiones: repeticionesController.text,
                                );
                                controller
                                    .actualizarEjercicio(ejercicioActualizado);
                                Navigator.pop(context);
                              } else {
                                // Mostrar mensaje de error si falta información
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Por favor, completa todos los campos',
                                    style:
                                        bodyStyle.copyWith(color: Colors.white),
                                  ),
                                  backgroundColor: colorScheme.error,
                                ));
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Amicons.iconly_edit_curved_fill,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Actualizar',
                                    style: subtitleStyle.copyWith(
                                      color: colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }

  void _confirmarBorrarTodosEjercicios(BuildContext context) {
    // Verificar si hay ejercicios para eliminar
    if (controller.ejerciciosPorDia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'No hay ejercicios para eliminar en ${controller.diaSeleccionado}',
          style: bodyStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: colorScheme.secondary,
      ));
      return;
    }

    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.secondaryContainer,
        title: Text('Eliminar todos los ejercicios',
            style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Estás seguro de que deseas eliminar todos los ejercicios de ${controller.diaSeleccionado}? Esta acción no se puede deshacer.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              _eliminarTodosEjercicios(context);
              Navigator.pop(context);
            },
            child:
                Text('Eliminar todos', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

// Método para eliminar todos los ejercicios del día seleccionado
  void _eliminarTodosEjercicios(BuildContext context) async {
    try {
      // Verificar si hay un entrenamiento seleccionado
      if (controller.entrenamientoActual == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'No hay un entrenamiento seleccionado',
            style: bodyStyle.copyWith(color: Colors.white),
          ),
          backgroundColor: colorScheme.error,
        ));
        return;
      }

      // Obtener una copia de la lista de ejercicios del día
      final List<Ejercicio> ejerciciosParaEliminar =
          List.from(controller.ejerciciosPorDia);

      // Eliminar cada ejercicio uno por uno
      for (var ejercicio in ejerciciosParaEliminar) {
        await controller.eliminarEjercicio(ejercicio.id);
      }

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Se han eliminado todos los ejercicios de ${controller.diaSeleccionado}',
          style: bodyStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: colorScheme.primary,
      ));
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error al eliminar ejercicios: ${e.toString()}',
          style: bodyStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: colorScheme.error,
      ));
    }
  }

  // Confirmar eliminación de un ejercicio
  void _confirmarEliminarEjercicio(BuildContext context, String ejercicioId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.secondaryContainer,
                Color.lerp(colorScheme.secondaryContainer, Colors.black, 0.2) ??
                    colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: colorScheme.error.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Amicons.iconly_delete_curved_fill,
                  color: colorScheme.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Eliminar Ejercicio',
                style: titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                '¿Estás seguro de que deseas eliminar este ejercicio?',
                style: bodyStyle.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        'Cancelar',
                        style: bodyStyle.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Botón Eliminar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colorScheme.error,
                            Color.lerp(colorScheme.error, Colors.black, 0.2) ??
                                colorScheme.error,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.error.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.eliminarEjercicio(ejercicioId);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Amicons.iconly_delete_curved_fill,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Eliminar',
                                  style: subtitleStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  // Confirmar eliminación de un entrenamiento
  void _confirmarEliminarEntrenamiento(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.secondaryContainer,
        title: Text('Eliminar Entrenamiento',
            style: TextStyle(color: Colors.white)),
        content: Text(
          '¿Estás seguro de que deseas eliminar este entrenamiento y todos sus ejercicios? Esta acción no se puede deshacer.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              if (controller.entrenamientoActual != null) {
                controller
                    .eliminarEntrenamiento(controller.entrenamientoActual!.id);
              }
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Menú de opciones mejorado
  void _mostrarOpcionesMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicador de arrastre
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(top: 16, bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.onBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Título del menú
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Amicons.iconly_more_circle_broken,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Opciones',
                    style: titleStyle.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Opción: Crear entrenamiento
            _buildMenuOption(
              'Crear nuevo entrenamiento',
              Amicons.iconly_plus_curved_fill,
              colorScheme.primary,
              () {
                Navigator.pop(context);
                _mostrarDialogoCrearEntrenamiento(context);
              },
            ),

            if (controller.entrenamientoActual != null) ...[
              const Divider(
                height: 30,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Colors.white10,
              ),
              // Opción: Eliminar entrenamiento
              _buildMenuOption(
                'Eliminar entrenamiento actual',
                Amicons.iconly_delete_curved_fill,
                colorScheme.error,
                () {
                  Navigator.pop(context);
                  _confirmarEliminarEntrenamiento(context);
                },
              ),
            ],

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
