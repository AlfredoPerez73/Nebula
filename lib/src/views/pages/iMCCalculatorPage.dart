import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import 'package:nebula/src/views/pages/profileScreen.dart';
import '../../controllers/user.controller.dart';

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({Key? key}) : super(key: key);

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final AuthController authController = Get.find<AuthController>();

  double? _bmiResult;
  String _bmiCategory = '';
  Color _categoryColor = Colors.white;
  bool _hasUserData = false;
  double? _userHeight;
  double? _userWeight;

  @override
  void initState() {
    super.initState();
    // Cargar datos del usuario automáticamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDataAndCalculate();
    });
  }

  void _loadUserDataAndCalculate() {
    final user = authController.userModel.value;
    if (user != null && user.altura != null && user.peso != null) {
      setState(() {
        _userHeight = user.altura;
        _userWeight = user.peso;
        _hasUserData = true;
      });
      _calculateBMI();
    } else {
      // Mostrar mensaje si no hay datos disponibles
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'No se encontraron datos de altura y peso en tu perfil'),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          action: SnackBarAction(
            label: 'Actualizar perfil',
            textColor: Colors.white,
            onPressed: () {
              // Navegación a la página de perfil
              Get.to(() => ProfileScreen());
            },
          ),
        ),
      );
    }
  }

  void _calculateBMI() {
    if (_userHeight == null ||
        _userWeight == null ||
        _userHeight! <= 0 ||
        _userWeight! <= 0) {
      return;
    }

    // BMI formula: weight (kg) / (height (m))²
    final double heightInMeters = _userHeight! / 100; // Convert cm to m
    final double bmi = _userWeight! / (heightInMeters * heightInMeters);

    setState(() {
      _bmiResult = bmi;

      // Determine BMI category
      if (bmi < 18.5) {
        _bmiCategory = 'Bajo peso';
        _categoryColor = Colors.blue;
      } else if (bmi < 25) {
        _bmiCategory = 'Peso normal';
        _categoryColor = Colors.green;
      } else if (bmi < 30) {
        _bmiCategory = 'Sobrepeso';
        _categoryColor = Colors.orange;
      } else {
        _bmiCategory = 'Obesidad';
        _categoryColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1725),
      appBar: AppBar(
        backgroundColor: const Color(0xFF242038),
        title: Row(
          children: const [
            Icon(Icons.monitor_weight, color: Color(0xFF9067C6), size: 22),
            SizedBox(width: 10),
            Text(
              'Mi IMC',
              style: TextStyle(
                color: Color(0xFFF7ECE1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _hasUserData ? _buildContent() : _buildNoDataView(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitle(),
            const SizedBox(height: 20),
            _buildBMIGauge(),
            const SizedBox(height: 20),
            _buildUserStats(),
            const SizedBox(height: 20),
            _buildRecommendations(),
            const SizedBox(height: 20),
            _buildBMIRangeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 70,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin datos disponibles',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Necesitamos tu altura y peso para calcular tu IMC',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text('Actualizar mi perfil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9067C6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Navegar a la página de perfil
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tu Índice de Masa Corporal",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Basado en tus datos de perfil actuales",
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildBMIGauge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF242038),
            const Color(0xFF242038).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _bmiCategory,
                style: TextStyle(
                  color: _categoryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _categoryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _categoryColor, width: 1.5),
                ),
                child: Text(
                  "${_bmiResult?.toStringAsFixed(1)} IMC",
                  style: TextStyle(
                    color: _categoryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 30,
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.red,
                      ],
                    ),
                  ),
                ),
                if (_bmiResult != null)
                  Positioned(
                    left: (_bmiResult! / 40) *
                        MediaQuery.of(context).size.width *
                        0.8,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _categoryColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _categoryColor.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "15",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 12,
                ),
              ),
              Text(
                "18.5",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 12,
                ),
              ),
              Text(
                "25",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 12,
                ),
              ),
              Text(
                "30",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 12,
                ),
              ),
              Text(
                "40",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCategoryExplanation(),
        ],
      ),
    );
  }

  Widget _buildCategoryExplanation() {
    String explanation;
    IconData iconData;

    switch (_bmiCategory) {
      case 'Bajo peso':
        explanation =
            'Tu peso está por debajo del rango saludable. Considera aumentar tu ingesta calórica con alimentos nutritivos y consultar a un profesional de la salud.';
        iconData = Icons.trending_down;
        break;
      case 'Peso normal':
        explanation =
            '¡Excelente! Tu peso se encuentra en un rango saludable para tu altura. Mantén tus hábitos actuales de alimentación y ejercicio.';
        iconData = Icons.check_circle;
        break;
      case 'Sobrepeso':
        explanation =
            'Tu peso está ligeramente por encima del rango saludable. Considera ajustar tu dieta y aumentar tu actividad física regular.';
        iconData = Icons.warning;
        break;
      case 'Obesidad':
        explanation =
            'Tu peso está significativamente por encima del rango recomendado. Es importante consultar con un profesional de la salud para desarrollar un plan personalizado.';
        iconData = Icons.priority_high;
        break;
      default:
        explanation = 'No se pudo determinar tu categoría de IMC.';
        iconData = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _categoryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: _categoryColor,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              explanation,
              style: TextStyle(
                color: const Color(0xFFCAC4CE).withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF242038),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Amicons.iconly_add_user_curved_fill,
                color: Color(0xFF9067C6),
                size: 24,
              ),
              const SizedBox(width: 10),
              const Text(
                'Tus estadísticas',
                style: TextStyle(
                  color: Color(0xFFF7ECE1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                    'Altura',
                    '${_userHeight?.toStringAsFixed(1) ?? "N/A"} cm',
                    Icons.height,
                    const Color(0xFF8D86C9)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                    'Peso',
                    '${_userWeight?.toStringAsFixed(1) ?? "N/A"} kg',
                    Icons.fitness_center,
                    const Color(0xFF9067C6)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                    'IMC',
                    '${_bmiResult?.toStringAsFixed(1) ?? "N/A"}',
                    Icons.monitor_weight,
                    _categoryColor),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                    'Categoría', _bmiCategory, Icons.category, _categoryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF7ECE1),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    String recommendationText;
    List<String> actionItems;

    switch (_bmiCategory) {
      case 'Bajo peso':
        recommendationText = 'Aumentar peso de manera saludable';
        actionItems = [
          'Incrementa la ingesta calórica con alimentos nutritivos',
          'Incluye proteínas de calidad en cada comida',
          'Incorpora ejercicios de fuerza para ganar masa muscular',
          'Consulta con un nutricionista para un plan personalizado'
        ];
        break;
      case 'Peso normal':
        recommendationText = 'Mantener peso saludable';
        actionItems = [
          'Continúa con una dieta balanceada y variada',
          'Realiza actividad física regular (150 min/semana)',
          'Mantén un adecuado consumo de agua',
          'Prioriza el descanso y manejo del estrés'
        ];
        break;
      case 'Sobrepeso':
        recommendationText = 'Reducir peso gradualmente';
        actionItems = [
          'Crea un déficit calórico moderado y sostenible',
          'Aumenta el consumo de vegetales y proteínas magras',
          'Realiza ejercicio cardiovascular y de fuerza',
          'Limita el consumo de alimentos ultraprocesados'
        ];
        break;
      case 'Obesidad':
        recommendationText = 'Plan de acción para reducir peso';
        actionItems = [
          'Consulta con profesionales de salud (médico y nutricionista)',
          'Establece metas realistas de pérdida de peso (0.5-1kg/semana)',
          'Incrementa gradualmente la actividad física diaria',
          'Considera llevar un registro de alimentación y actividad'
        ];
        break;
      default:
        recommendationText = 'Recomendaciones generales';
        actionItems = [
          'Mantén una alimentación balanceada',
          'Realiza actividad física regularmente',
          'Consulta con profesionales de la salud',
          'Mantén hábitos saludables'
        ];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF242038),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF9067C6),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                recommendationText,
                style: const TextStyle(
                  color: Color(0xFFF7ECE1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...actionItems
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: _categoryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              color: const Color(0xFFCAC4CE).withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildBMIRangeInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF242038),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF9067C6),
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                'Rangos de IMC',
                style: TextStyle(
                  color: Color(0xFFF7ECE1),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildRangeRow('Bajo peso', 'Menos de 18.5', Colors.blue),
          _buildRangeRow('Peso normal', '18.5 - 24.9', Colors.green),
          _buildRangeRow('Sobrepeso', '25 - 29.9', Colors.orange),
          _buildRangeRow('Obesidad', '30 o más', Colors.red),
          const SizedBox(height: 15),
          Text(
            'El IMC es una herramienta de evaluación general y no considera otros factores como la composición corporal, distribución de grasa o masa muscular.',
            style: TextStyle(
              color: const Color(0xFFCAC4CE).withOpacity(0.7),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeRow(String category, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                color: Color(0xFFF7ECE1),
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              range,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
