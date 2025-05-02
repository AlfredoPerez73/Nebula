import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/views/pages/profile_screen.dart';
import 'package:nebula/src/views/pages/ia_excersis_page.dart';
import 'package:nebula/src/views/pages/routines_page.dart';
import 'package:nebula/src/widgets/home/home_bmi_card.dart';
import 'package:nebula/src/widgets/home/ia/home_ai_recommendation.dart';
import 'package:nebula/src/widgets/workout/workout_display_widget.dart';
import 'package:nebula/src/widgets/workout/workout_loading_dialog.dart';
import 'package:nebula/src/widgets/workout/workout_selector_dialog.dart';
import 'package:nebula/src/widgets/home/home_welcome.dart';
import 'package:nebula/src/widgets/home/home_user_profile.dart';
import 'package:nebula/src/widgets/home/home_progress_stats.dart';
import '../controllers/user.controller.dart';
import '../controllers/ai_exercise.controller.dart';
import '../utils/navigate_bar.dart';
import '../utils/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreen> {
  final WorkoutRoutineController workoutController =
      Get.put(WorkoutRoutineController());
  final AuthController authController = Get.find<AuthController>();
  final EntrenamientoController entrenamientoController =
      Get.find<EntrenamientoController>();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    entrenamientoController.cargarEntrenamientos();
  }

  // This method determines which content to show based on the selected index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        entrenamientoController.cargarEntrenamientos();
        return _buildHomeContent();
      case 1:
        return const Iaexcersispage();
      case 2:
        return Routinespage();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Elementos decorativos en el fondo
            Positioned(
              top: -120,
              right: -100,
              child: Container(
                height: 320,
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            Positioned(
              bottom: -70,
              left: -60,
              child: Container(
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.02),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.7,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Contenido principal
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  if (_selectedIndex == 0) _buildAppBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: _getPage(_selectedIndex),
                    ),
                  ),
                ],
              ),
            ),

            // Navegación inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavigation(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      flexibleSpace: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkPurple,
                  AppColors.darkPurple.withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Amicons.lucide_dumbbell,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "NEBULA",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              Text(
                "FITNESS APP IA",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.accentColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Logout button
        IconButton(
          icon: Icon(
            Amicons.iconly_logout_curved,
            color: AppColors.accentColor,
            size: 24,
          ),
          onPressed: () {
            authController.signOut();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // Home content for index 0
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            HomeWelcomeBanner(authController: authController),
            const SizedBox(height: 24),

            // User Profile Section
            HomeUserProfile(authController: authController),

            // AI Recommendation Section
            HomeAIRecommendation(
              authController: authController,
              showWorkoutSelector: _showWorkoutSelectorDialog,
            ),

            // BMI Card
            HomeBmiCard(authController: authController),

            // Progress and Stats
            HomeProgressStats(
                authController: authController,
                entrenamientoController: entrenamientoController),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showWorkoutSelectorDialog() {
    Get.dialog(
      WorkoutSelectorDialog(
        onGeneratePressed: (String level, String goal, int daysPerWeek,
            String? focusMuscleGroup, String? additionalDetails) {
          // Mostrar el diálogo de carga
          Get.dialog(
            const WorkoutLoadingDialog(),
            barrierDismissible: false,
          );

          // Llamar al controlador para generar la rutina
          workoutController
              .generateWorkout(
            level: level,
            goal: goal,
            daysPerWeek: daysPerWeek,
            muscleGroup: focusMuscleGroup,
            details: additionalDetails,
          )
              .then((_) {
            // Cerrar el diálogo de carga
            Get.back();

            // Verificar si se generó correctamente la rutina
            if (workoutController.hasWorkout.value) {
              // Mostrar la rutina generada
              _showWorkoutDisplay();
            }
          });
        },
      ),
    );
  }

  void _showWorkoutDisplay() {
    // Utilizar Get.to para navegar a la pantalla de rutina
    Get.to(
      () => Scaffold(
        body: Obx(() => WorkoutDisplayWidget(
              workoutData: workoutController.workoutData.value,
              onClose: () {
                // Limpiar la rutina al cerrar
                workoutController.clearWorkout();
                Get.back();
              },
            )),
      ),
      fullscreenDialog: true,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
