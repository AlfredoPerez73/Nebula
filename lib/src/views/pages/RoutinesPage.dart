import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:flutter/services.dart';

class Routinespage extends StatelessWidget {
  final EntrenamientoController controller = Get.put(EntrenamientoController());

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
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  final TextStyle subtitleStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  final TextStyle bodyStyle = const TextStyle(
    fontSize: 14,
    letterSpacing: 0.25,
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
      appBar: _buildAppBar(context),
      body: GetBuilder<EntrenamientoController>(
        init: controller,
        builder: (controller) {
          // Si está en proceso de carga, mostrar indicador
          if (controller.cargando) {
            return _buildLoadingState();
          }

          // Si hay error, limpiar y reintentar
          if (controller.tieneError) {
            controller.limpiarError();
            controller.cargarEntrenamientos();
            return _buildLoadingState(); // Mostrar carga mientras reintenta
          }

          // Si los datos ya se inicializaron pero están vacíos, mostrar estado vacío
          if (controller.entrenamientos.isEmpty) {
            return _buildEmptyState(context);
          }

          // Si hay datos, mostrar el contenido
          return _buildContent();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _mostrarDialogoAgregarEjercicio(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // AppBar con diseño mejorado
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Programación de Rutina',
        style: titleStyle.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          color: colorScheme.onSurface,
          onPressed: () => _mostrarOpcionesMenu(context),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  // Estado de carga
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cargando rutinas...',
            style: bodyStyle.copyWith(color: colorScheme.onBackground),
          ),
        ],
      ),
    );
  }

  // Estado de error
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Error: ${controller.error}',
              style: subtitleStyle.copyWith(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh),
              label: Text('Reintentar',
                  style: subtitleStyle.copyWith(color: colorScheme.onPrimary)),
              onPressed: () {
                controller.limpiarError();
                controller.cargarEntrenamientos();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center,
                size: 70, color: colorScheme.onBackground.withOpacity(0.3)),
            const SizedBox(height: 24),
            Text(
              'No tienes entrenamientos creados',
              style: subtitleStyle.copyWith(color: colorScheme.onBackground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              icon: const Icon(Icons.add),
              label: Text(
                'Crear Entrenamiento o espera que se carguen los tuyos',
                style: subtitleStyle.copyWith(color: colorScheme.onPrimary),
              ),
              onPressed: () => _mostrarDialogoCrearEntrenamiento(context),
            ),
          ],
        ),
      ),
    );
  }

  // Contenido principal
  Widget _buildContent() {
    return Column(
      children: [
        _buildRoutineSelector(),
        _buildDaySelector(),
        if (controller.entrenamientoActual != null) ...[
          _buildExerciseHeader(),
          _buildExerciseList(),
        ],
      ],
    );
  }

  // Selector de rutina con diseño mejorado
  Widget _buildRoutineSelector() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: colorScheme.surface,
            isExpanded: true,
            value: controller.entrenamientoActual?.id,
            hint: Text(
              'Selecciona una rutina',
              style: bodyStyle.copyWith(color: colorScheme.onBackground),
            ),
            icon: Icon(Icons.keyboard_arrow_down,
                color: colorScheme.onBackground),
            style: subtitleStyle.copyWith(color: colorScheme.onSurface),
            onChanged: (String? value) {
              if (value != null) {
                controller.seleccionarEntrenamiento(value);
              }
            },
            items: controller.entrenamientos.map((entrenamiento) {
              return DropdownMenuItem<String>(
                value: entrenamiento.id,
                child: Text(entrenamiento.nombre),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Selector de días mejorado
  Widget _buildDaySelector() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: diasSemanaCortos.length,
        itemBuilder: (context, index) {
          final String diaCorto = diasSemanaCortos[index];
          final String diaCompleto = diasSemanaCompletos[index];
          final bool isSelected = diaCompleto == controller.diaSeleccionado;

          return GestureDetector(
            onTap: () {
              controller.seleccionarDia(diaCompleto);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? colorScheme.primary.withOpacity(0.4)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.surface.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (10 + index).toString(),
                        style: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 5,
                      height: 5,
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

  // Encabezado de ejercicios
  Widget _buildExerciseHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ejercicios para ${controller.diaSeleccionado}',
            style: titleStyle.copyWith(color: colorScheme.onBackground),
          ),
          TextButton.icon(
            icon: Icon(Icons.delete_sweep, color: colorScheme.error, size: 20),
            label: Text(
              'Borrar todos',
              style: bodyStyle.copyWith(color: colorScheme.error),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Lista de ejercicios
  Widget _buildExerciseList() {
    return Expanded(
      child: controller.ejerciciosPorDia.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center,
                      size: 50,
                      color: colorScheme.onBackground.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No hay ejercicios para este día',
                    style: subtitleStyle.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: controller.ejerciciosPorDia.length,
              itemBuilder: (context, index) {
                final ejercicio = controller.ejerciciosPorDia[index];
                return _buildEjercicioCard(context, ejercicio);
              },
            ),
    );
  }

  // Tarjeta de ejercicio rediseñada
  Widget _buildEjercicioCard(BuildContext context, Ejercicio ejercicio) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.fitness_center,
            color: colorScheme.primary,
            size: 24,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            ejercicio.nombre,
            style: subtitleStyle.copyWith(color: colorScheme.onSurface),
          ),
        ),
        subtitle: Text(
          '${ejercicio.series} series × ${ejercicio.repeticiones} repeticiones',
          style: bodyStyle.copyWith(color: colorScheme.onBackground),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: colorScheme.secondary,
                size: 22,
              ),
              splashRadius: 24,
              tooltip: 'Editar',
              onPressed: () =>
                  _mostrarDialogoEditarEjercicio(context, ejercicio),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
                size: 22,
              ),
              splashRadius: 24,
              tooltip: 'Eliminar',
              onPressed: () =>
                  _confirmarEliminarEjercicio(context, ejercicio.id),
            ),
          ],
        ),
      ),
    );
  }

  // Menú de opciones mejorado
  void _mostrarOpcionesMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.onBackground.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withOpacity(0.2),
                child: Icon(Icons.add, color: colorScheme.primary),
              ),
              title: Text(
                'Crear nuevo entrenamiento',
                style: subtitleStyle.copyWith(color: colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                _mostrarDialogoCrearEntrenamiento(context);
              },
            ),
            if (controller.entrenamientoActual != null) ...[
              const Divider(height: 1, thickness: 0.5),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.error.withOpacity(0.2),
                  child: Icon(Icons.delete, color: colorScheme.error),
                ),
                title: Text(
                  'Eliminar entrenamiento actual',
                  style: subtitleStyle.copyWith(color: colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmarEliminarEntrenamiento(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Diálogo para crear entrenamiento mejorado
  void _mostrarDialogoCrearEntrenamiento(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Crear Entrenamiento',
          style: titleStyle.copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              style: bodyStyle.copyWith(color: colorScheme.onSurface),
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.background.withOpacity(0.3),
                labelText: 'Nombre del entrenamiento',
                labelStyle: bodyStyle.copyWith(color: colorScheme.onBackground),
                prefixIcon:
                    Icon(Icons.fitness_center, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary),
                ),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: bodyStyle.copyWith(color: colorScheme.onBackground),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              if (nombreController.text.isNotEmpty) {
                controller.crearEntrenamiento(nombreController.text);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Crear',
              style: subtitleStyle.copyWith(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Diálogo para agregar ejercicio mejorado
  void _mostrarDialogoAgregarEjercicio(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController seriesController = TextEditingController();
    final TextEditingController repeticionesController =
        TextEditingController();
    String selectedDay = controller.diaSeleccionado;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Agregar Ejercicio',
          style: titleStyle.copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de nombre
              TextField(
                controller: nombreController,
                style: bodyStyle.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Nombre del ejercicio',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon:
                      Icon(Icons.fitness_center, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Selector de día
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.background.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  dropdownColor: colorScheme.surface,
                  icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                  value: selectedDay,
                  style: bodyStyle.copyWith(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.calendar_today, color: colorScheme.primary),
                    labelText: 'Día',
                    labelStyle:
                        bodyStyle.copyWith(color: colorScheme.onBackground),
                    border: InputBorder.none,
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

              const SizedBox(height: 16),

              // Campo de series
              TextField(
                controller: seriesController,
                style: bodyStyle.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Series',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon: Icon(Icons.repeat, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Campo de repeticiones
              TextField(
                controller: repeticionesController,
                style: bodyStyle.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Repeticiones (ej: 10-12, 15)',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon: Icon(Icons.loop, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: bodyStyle.copyWith(color: colorScheme.onBackground),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              if (nombreController.text.isNotEmpty &&
                  seriesController.text.isNotEmpty &&
                  repeticionesController.text.isNotEmpty) {
                // Crear nuevo ejercicio
                final ejercicio = Ejercicio(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nombre: nombreController.text,
                  dia: selectedDay,
                  series: int.tryParse(seriesController.text) ?? 0,
                  repeticiones: repeticionesController.text,
                );
                controller.agregarEjercicio(ejercicio);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Agregar',
              style: subtitleStyle.copyWith(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Diálogo para editar un ejercicio existente
  void _mostrarDialogoEditarEjercicio(
      BuildContext context, Ejercicio ejercicio) {
    final TextEditingController nombreController =
        TextEditingController(text: ejercicio.nombre);
    final TextEditingController diaController =
        TextEditingController(text: ejercicio.dia);
    final TextEditingController seriesController =
        TextEditingController(text: ejercicio.series.toString());
    final TextEditingController repeticionesController =
        TextEditingController(text: ejercicio.repeticiones);
    String selectedDay = ejercicio.dia;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Actualizar Ejercicio',
          style: titleStyle.copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de nombre
              TextField(
                controller: nombreController,
                style: bodyStyle.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Nombre del ejercicio',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon:
                      Icon(Icons.fitness_center, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Selector de día
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.background.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  dropdownColor: colorScheme.surface,
                  icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                  value: selectedDay,
                  style: bodyStyle.copyWith(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.calendar_today, color: colorScheme.primary),
                    labelText: 'Día',
                    labelStyle:
                        bodyStyle.copyWith(color: colorScheme.onBackground),
                    border: InputBorder.none,
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

              const SizedBox(height: 16),

              // Campo de series
              TextField(
                controller: seriesController,
                style: bodyStyle.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Series',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon: Icon(Icons.repeat, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),

              // Campo de repeticiones
              TextField(
                controller: repeticionesController,
                style: bodyStyle.copyWith(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.background.withOpacity(0.3),
                  labelText: 'Repeticiones (ej: 10-12, 15)',
                  labelStyle:
                      bodyStyle.copyWith(color: colorScheme.onBackground),
                  prefixIcon: Icon(Icons.loop, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: bodyStyle.copyWith(color: colorScheme.onBackground),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              if (nombreController.text.isNotEmpty &&
                  seriesController.text.isNotEmpty &&
                  repeticionesController.text.isNotEmpty) {
                // Crear nuevo ejercicio
                final ejercicio = Ejercicio(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nombre: nombreController.text,
                  dia: selectedDay,
                  series: int.tryParse(seriesController.text) ?? 0,
                  repeticiones: repeticionesController.text,
                );
                controller.actualizarEjercicio(ejercicio);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Actualizar',
              style: subtitleStyle.copyWith(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Confirmar eliminación de un ejercicio
  void _confirmarEliminarEjercicio(BuildContext context, String ejercicioId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.secondaryContainer,
        title:
            Text('Eliminar Ejercicio', style: TextStyle(color: Colors.white)),
        content: Text('¿Estás seguro de que deseas eliminar este ejercicio?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              controller.eliminarEjercicio(ejercicioId);
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
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
}
