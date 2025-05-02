import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/controllers/historyTraining.controller.dart';
import 'package:flutter/services.dart';
import 'package:nebula/src/widgets/routines/routines_widgets.dart';

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

  static const Color appBackground = Color(0xFF121016);
  static const Color appSurface = Color(0xFF1E1728);
  static const Color appOnBackground = Colors.white70;

  // Esquema de colores refinado sin las propiedades obsoletas
  final ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF6A3DE8),
    primaryContainer: Color(0xFF53379B),
    secondary: Color(0xFF8C65F7),
    secondaryContainer: Color(0xFF35244F),
    surface: appSurface,
    error: Color(0xFFFF5252),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
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

  Routinespage({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuración del sistema para UI inmersiva
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: appBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Instanciar clase de widgets
    final routineWidgets = RoutineWidgets(
      controller: controller,
      hcontroller: hcontroller,
      colorScheme: colorScheme,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      bodyStyle: bodyStyle,
      diasSemanaCortos: diasSemanaCortos,
      diasSemanaCompletos: diasSemanaCompletos,
    );

    return Scaffold(
      backgroundColor: appBackground,
      resizeToAvoidBottomInset: false, // Soluciona el problema de la navbar
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appBackground,
              appBackground.withValues(alpha: 0.85),
              colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                  color: colorScheme.primary.withValues(alpha: 0.04),
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
                  color: colorScheme.primary.withValues(alpha: 0.05),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  routineWidgets.buildEnhancedAppBar(context),
                  Expanded(
                    child: GetBuilder<EntrenamientoController>(
                      init: controller,
                      builder: (controller) {
                        // Si está en proceso de carga, mostrar indicador
                        if (controller.cargando) {
                          return routineWidgets.buildEnhancedLoadingState();
                        }

                        // Si hay error, limpiar y reintentar
                        if (controller.tieneError) {
                          controller.limpiarError();
                          controller.cargarEntrenamientos();
                          return routineWidgets
                              .buildEnhancedLoadingState(); // Mostrar carga mientras reintenta
                        }

                        // Si los datos ya se inicializaron pero están vacíos, mostrar estado vacío
                        if (controller.entrenamientos.isEmpty) {
                          return routineWidgets
                              .buildEnhancedEmptyState(context);
                        }

                        // Si hay datos, mostrar el contenido
                        return routineWidgets.buildEnhancedContent();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Modificado: Muestra el botón cuando hay entrenamientos disponibles
      floatingActionButton: controller.entrenamientos.isNotEmpty
          ? routineWidgets.buildEnhancedFloatingButton(context)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
