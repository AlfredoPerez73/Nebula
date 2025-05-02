import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user.controller.dart';

class EditProfilePageSkills extends StatefulWidget {
  const EditProfilePageSkills({super.key});

  @override
  State<EditProfilePageSkills> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePageSkills> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  String selectedNivelExperiencia = 'Principiante';
  String selectedObjetivo = 'Perder peso';

  // Opciones para los dropdown
  final List<String> nivelesExperiencia = [
    'Principiante',
    'Intermedio',
    'Avanzado',
    'Experto'
  ];
  final List<String> objetivos = [
    'Perder peso',
    'Ganar masa muscular',
    'Mantener forma física',
    'Mejorar resistencia'
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los datos actuales del usuario
    nameController.text = authController.userModel.value?.nombre ?? '';
    emailController.text = authController.userModel.value?.email ?? '';

    // Inicializar los nuevos campos
    pesoController.text = authController.userModel.value?.peso.toString() ?? '';
    alturaController.text =
        authController.userModel.value?.altura.toString() ?? '';
    selectedNivelExperiencia =
        authController.userModel.value?.nivelExperiencia ?? 'Principiante';
    selectedObjetivo =
        authController.userModel.value?.objetivo ?? 'Perder peso';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF242038),
              Color(0xFF9067C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              _buildCustomAppBar(context),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile avatar
                          _buildProfileAvatar(),

                          const SizedBox(height: 30),

                          // Personal Information
                          _buildSectionTitle('Información Personal'),
                          _buildProfileInfoCard(),

                          const SizedBox(height: 30),

                          // Fitness Information
                          _buildSectionTitle('Información de Fitness'),
                          _buildFitnessInfoCard(),

                          const SizedBox(height: 30),

                          // Save button
                          _buildSaveButton(),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF242038),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFF7ECE1),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                "EDITAR PERFIL",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFFF7ECE1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF9067C6).withValues(alpha: 0.3),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Color(0xFFF7ECE1),
                    size: 60,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF9067C6),
                    border: Border.all(
                      color: const Color(0xFF242038),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFFF7ECE1),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Cambiar foto de perfil",
            style: TextStyle(
              color: Color(0xFFF7ECE1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF9067C6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: nameController,
            label: 'Nombre',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Por favor ingresa un email válido';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nivel de experiencia (dropdown)
          _buildDropdown(
            label: 'Nivel de Experiencia',
            icon: Icons.fitness_center,
            value: selectedNivelExperiencia,
            items: nivelesExperiencia,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedNivelExperiencia = value;
                });
              }
            },
          ),
          const SizedBox(height: 20),

          // Peso
          _buildTextField(
            controller: pesoController,
            label: 'Peso (kg)',
            icon: Icons.monitor_weight_outlined,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu peso';
              }
              if (double.tryParse(value) == null) {
                return 'Por favor ingresa un número válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Altura
          _buildTextField(
            controller: alturaController,
            label: 'Altura (cm)',
            icon: Icons.height,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu altura';
              }
              if (double.tryParse(value) == null) {
                return 'Por favor ingresa un número válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Objetivo (dropdown)
          _buildDropdown(
            label: 'Objetivo',
            icon: Icons.flag,
            value: selectedObjetivo,
            items: objetivos,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedObjetivo = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF8D86C9)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9067C6), width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      style: const TextStyle(
        color: Color(0xFFF7ECE1),
        fontSize: 16,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF8D86C9)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        style: const TextStyle(
          color: Color(0xFFF7ECE1),
          fontSize: 16,
        ),
        dropdownColor: const Color(0xFF242038),
        borderRadius: BorderRadius.circular(15),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9067C6)),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Color(0xFFF7ECE1)),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9067C6).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: authController.isLoading.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveChanges();
                    }
                  },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: const Color(0xFF9067C6),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 0,
            ),
            child: authController.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "GUARDAR CAMBIOS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),
        ));
  }

  Future<void> _saveChanges() async {
    try {
      final navigator = Navigator.of(context);
      // Parse numerical values
      double peso = double.tryParse(pesoController.text) ?? 0.0;
      double altura = double.tryParse(alturaController.text) ?? 0.0;

      // Actualizar los campos básicos (nombre, email)
      await authController.updateUserProfile(
        nameController.text,
        emailController.text,
      );

      // Actualizar los campos de fitness
      await authController.updateUserProfileSkills(
        selectedNivelExperiencia,
        peso,
        altura,
        selectedObjetivo,
      );

      await authController.refreshUserData();
      authController.notifyModelChanged();

      Get.snackbar(
        "¡Perfil Actualizado!",
        "Tus datos se han guardado correctamente",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 15,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      // Volver a la pantalla anterior
      navigator.pop();
    } catch (e) {
      Get.snackbar(
        "Error",
        "No se pudo actualizar el perfil. Inténtalo de nuevo.",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 15,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
