import 'dart:convert';
import 'package:http/http.dart' as http;

class SimpleAIService {
  // Tu API key de Google Gemini
  static const String apiKey = 'AIzaSyCeCCwh9jbZwLNc5keYGL_kM1yXL_hV0Tk';

  // Método para generar una rutina personalizada basada en los requerimientos del usuario
  static Future<Map<String, dynamic>> generateWorkoutRoutine({
    required String
        level, // Nivel de experiencia (principiante, intermedio, avanzado)
    required String
        goal, // Objetivo (pérdida de peso, volumen, definición, etc.)
    required int daysPerWeek, // Días de entrenamiento por semana
    String? focusMuscleGroup, // Grupo muscular de enfoque (opcional)
    String? additionalDetails, // Detalles adicionales (opcional)
  }) async {
    try {
      // Construir el prompt para la IA
      final String prompt = _buildPrompt(
          level, goal, daysPerWeek, focusMuscleGroup, additionalDetails);

      // Llamar a la API de Gemini
      final Map<String, dynamic>? response = await _callGeminiAPI(prompt);

      // Si la respuesta es válida, devolverla
      if (response != null) {
        return response;
      }

      // Si no hay respuesta válida, mostrar mensaje de error
      throw Exception(
          'No se pudo generar la rutina. Por favor, intenta nuevamente.');
    } catch (e) {
      print('Error al generar rutina: $e');
      throw Exception('Error al generar la rutina: $e');
    }
  }

  static String _buildPrompt(
    String level,
    String goal,
    int daysPerWeek,
    String? focusMuscleGroup,
    String? additionalDetails,
  ) {
    return '''
    Eres un entrenador personal experto. Genera una rutina de entrenamiento en formato JSON siguiendo ESTRICTAMENTE el siguiente esquema:
    {
      "routineName": "Nombre descriptivo de la rutina",
      "description": "Descripción breve de la rutina",
      "level": "$level",
      "goal": "$goal",
      "daysPerWeek": $daysPerWeek,
      "workoutDays": [
        {
          "day": "Día o nombre del día",
          "focus": "Grupo muscular o enfoque del día",
          "exercises": [
            {
              "name": "Nombre del ejercicio",
              "muscle": "Músculos trabajados",
              "sets": 3,
              "reps": "Rango de repeticiones",
              "rest": "Tiempo de descanso",
              "notes": "Consejos técnicos (breve)"
            }
          ],
          "notes": "Notas generales para el día"
        }
      ],
      "nutritionTips": "Consejos nutricionales específicos",
      "restDayTips": "Recomendaciones para días de descanso"
    }
    
    INSTRUCCIONES MUY IMPORTANTES:
    - GENERA SOLO EL JSON sin ningún texto adicional antes o después
    - NO incluyas marcadores de código como ```json o ``` 
    - Asegúrate de que el JSON sea COMPLETAMENTE VÁLIDO y sin errores de sintaxis
    - Limita las descripciones a un máximo de 150 caracteres por campo
    - Mantén las notas de ejercicios a menos de 80 caracteres
    - NO uses comillas dentro de los textos, usa apóstrofes si es necesario
    - Mantén todo el documento por debajo de 8000 caracteres
    ${focusMuscleGroup != null && focusMuscleGroup != 'Todos' ? 'Enfócate específicamente en: $focusMuscleGroup' : ''}
    ${additionalDetails != null && additionalDetails.isNotEmpty ? 'Considera: $additionalDetails' : ''}
    ''';
  }

  static String? _extractJsonFromText(String text) {
    try {
      // Eliminar cualquier delimitador de markdown
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();

      // Encontrar el primer { y el último }
      final jsonStartIndex = text.indexOf('{');
      final jsonEndIndex = text.lastIndexOf('}') + 1;

      if (jsonStartIndex != -1 &&
          jsonEndIndex != -1 &&
          jsonEndIndex > jsonStartIndex) {
        // Extraer solo el texto que parece ser JSON
        text = text.substring(jsonStartIndex, jsonEndIndex);

        // Intentar parsear directamente primero
        try {
          json.decode(text);
          return text; // Si se puede parsear, está bien
        } catch (e) {
          // Si falla, intentar reparar
          print('Intentando reparar JSON: ${e.toString()}');
          return _repairJson(text);
        }
      } else {
        print('No se encontró estructura JSON válida');
        return null;
      }
    } catch (e) {
      print('Error al extraer JSON: $e');
      return null;
    }
  }

  static String _repairJson(String text) {
    try {
      // Verificar si hay llaves y corchetes desbalanceados
      int openBraces = 0, closeBraces = 0;
      int openBrackets = 0, closeBrackets = 0;

      for (int i = 0; i < text.length; i++) {
        switch (text[i]) {
          case '{':
            openBraces++;
            break;
          case '}':
            closeBraces++;
            break;
          case '[':
            openBrackets++;
            break;
          case ']':
            closeBrackets++;
            break;
        }
      }

      // Crear una nueva cadena reparada
      String repairedJson = text;

      // Si hay problemas con corchetes no cerrados
      while (openBrackets > closeBrackets) {
        repairedJson += ']';
        closeBrackets++;
      }

      // Si hay problemas con llaves no cerradas
      while (openBraces > closeBraces) {
        repairedJson += '}';
        closeBraces++;
      }

      // Verificar comillas no cerradas
      repairedJson = _fixMissingQuotes(repairedJson);

      // Verificar campos obligatorios faltantes
      repairedJson = _ensureRequiredFields(repairedJson);

      // Verificar que termina correctamente
      if (!repairedJson.trim().endsWith('}')) {
        repairedJson = repairedJson.trim() + '}';
      }

      // Intentar parsear para validar - si falla, devolver null
      try {
        json.decode(repairedJson);
        return repairedJson;
      } catch (e) {
        print('Error al parsear JSON reparado: $e');
        print('JSON problemático reparado: $repairedJson');
        return _createFallbackWorkout(text);
      }
    } catch (e) {
      print('Error en la reparación de JSON: $e');
      return _createFallbackWorkout(text);
    }
  }

  static String _fixMissingQuotes(String jsonText) {
    // Patrón para encontrar posibles campos sin comillas de cierre
    RegExp keyPattern = RegExp(r'"([^"]+):\s*"([^"]+)(?=[,}])');
    Iterable<RegExpMatch> matches = keyPattern.allMatches(jsonText);

    String fixedJson = jsonText;
    for (RegExpMatch match in matches) {
      if (match.group(0) != null) {
        String original = match.group(0)!;
        String fixed = original + '"';
        fixedJson = fixedJson.replaceFirst(original, fixed);
      }
    }

    return fixedJson;
  }

  static String _ensureRequiredFields(String jsonText) {
    try {
      // Verificar si podemos decodificar como JSON parcial
      Map<String, dynamic> workout = json.decode(jsonText);

      // Lista de campos obligatorios en la raíz
      List<String> requiredRootFields = [
        'routineName',
        'description',
        'level',
        'goal',
        'daysPerWeek',
        'workoutDays',
        'nutritionTips',
        'restDayTips'
      ];

      // Agregar campos faltantes en la raíz
      bool needComma = false;
      String modifiedJson = jsonText;

      if (!modifiedJson.contains('"workoutDays"')) {
        // Si falta workoutDays, es un problema grave, añadirlo
        if (modifiedJson.lastIndexOf('}') > 0) {
          String toInsert = needComma ? ', ' : '';
          toInsert += '"workoutDays": []';
          modifiedJson =
              modifiedJson.substring(0, modifiedJson.lastIndexOf('}')) +
                  toInsert +
                  modifiedJson.substring(modifiedJson.lastIndexOf('}'));
          needComma = true;
        }
      }

      for (String field in requiredRootFields) {
        if (field != 'workoutDays' && !modifiedJson.contains('"$field"')) {
          if (modifiedJson.lastIndexOf('}') > 0) {
            String toInsert = needComma ? ', ' : '';
            toInsert += '"$field": "${_getDefaultValueForField(field)}"';
            modifiedJson =
                modifiedJson.substring(0, modifiedJson.lastIndexOf('}')) +
                    toInsert +
                    modifiedJson.substring(modifiedJson.lastIndexOf('}'));
            needComma = true;
          }
        }
      }

      return modifiedJson;
    } catch (e) {
      print('Error al asegurar campos requeridos: $e');
      return jsonText;
    }
  }

  static String _getDefaultValueForField(String field) {
    switch (field) {
      case 'routineName':
        return 'Rutina personalizada';
      case 'description':
        return 'Rutina de entrenamiento generada automáticamente';
      case 'level':
        return 'Intermedio';
      case 'goal':
        return 'Acondicionamiento general';
      case 'daysPerWeek':
        return '3';
      case 'nutritionTips':
        return 'Mantén una dieta balanceada y bebe suficiente agua';
      case 'restDayTips':
        return 'Descansa adecuadamente y realiza estiramientos';
      default:
        return '';
    }
  }

  // Método de último recurso: crear una rutina sencilla predeterminada
  static String _createFallbackWorkout(String originalText) {
    try {
      // Intentar extraer el nivel y objetivo del texto original
      String level = 'Intermedio';
      String goal = 'Acondicionamiento general';
      int daysPerWeek = 3;

      // Buscar nivel en el texto original
      RegExp levelRegex = RegExp(r'"level":\s*"([^"]+)"');
      Match? levelMatch = levelRegex.firstMatch(originalText);
      if (levelMatch != null && levelMatch.group(1) != null) {
        level = levelMatch.group(1)!;
      }

      // Buscar objetivo en el texto original
      RegExp goalRegex = RegExp(r'"goal":\s*"([^"]+)"');
      Match? goalMatch = goalRegex.firstMatch(originalText);
      if (goalMatch != null && goalMatch.group(1) != null) {
        goal = goalMatch.group(1)!;
      }

      // Buscar días por semana en el texto original
      RegExp daysRegex = RegExp(r'"daysPerWeek":\s*(\d+)');
      Match? daysMatch = daysRegex.firstMatch(originalText);
      if (daysMatch != null && daysMatch.group(1) != null) {
        daysPerWeek = int.tryParse(daysMatch.group(1)!) ?? 3;
      }

      // Crear una rutina básica
      Map<String, dynamic> fallbackRoutine = {
        "routineName": "Rutina básica de $level para $goal",
        "description": "Rutina sencilla de $level enfocada en $goal",
        "level": level,
        "goal": goal,
        "daysPerWeek": daysPerWeek,
        "workoutDays": _generateBasicWorkoutDays(daysPerWeek),
        "nutritionTips":
            "Mantén una dieta balanceada con proteínas, carbohidratos y grasas saludables. Bebe suficiente agua.",
        "restDayTips":
            "Descansa adecuadamente entre entrenamientos. Puedes realizar caminatas ligeras y estiramientos."
      };

      return json.encode(fallbackRoutine);
    } catch (e) {
      print('Error al crear rutina de respaldo: $e');

      // Rutina absolutamente mínima si todo falla
      return '{"routineName":"Rutina básica","description":"Rutina general de entrenamiento","level":"Intermedio","goal":"Acondicionamiento general","daysPerWeek":3,"workoutDays":[{"day":"Día 1","focus":"Cuerpo completo","exercises":[{"name":"Sentadillas","muscle":"Piernas","sets":3,"reps":"10-12","rest":"60 segundos","notes":"Mantén la espalda recta"}],"notes":"Hidratarse bien"}],"nutritionTips":"Alimentación balanceada","restDayTips":"Descanso activo"}';
    }
  }

  static List<Map<String, dynamic>> _generateBasicWorkoutDays(int daysPerWeek) {
    List<Map<String, dynamic>> workoutDays = [];

    // Plantillas básicas para diferentes días
    List<Map<String, dynamic>> templates = [
      {
        "day": "Día 1",
        "focus": "Piernas y Core",
        "exercises": [
          {
            "name": "Sentadillas",
            "muscle": "Cuádriceps, Glúteos",
            "sets": 3,
            "reps": "10-12",
            "rest": "60 segundos",
            "notes":
                "Mantén la espalda recta y las rodillas alineadas con los pies"
          },
          {
            "name": "Plancha",
            "muscle": "Core, Abdominales",
            "sets": 3,
            "reps": "30 segundos",
            "rest": "45 segundos",
            "notes": "Mantén el cuerpo alineado y el core contraído"
          }
        ],
        "notes": "Hidratarse bien durante el entrenamiento"
      },
      {
        "day": "Día 2",
        "focus": "Pecho y Tríceps",
        "exercises": [
          {
            "name": "Flexiones",
            "muscle": "Pectoral, Tríceps",
            "sets": 3,
            "reps": "8-12",
            "rest": "60 segundos",
            "notes":
                "Mantén el cuerpo alineado desde la cabeza hasta los talones"
          },
          {
            "name": "Fondos de tríceps",
            "muscle": "Tríceps",
            "sets": 3,
            "reps": "10-15",
            "rest": "45 segundos",
            "notes": "Mantén los codos cerca del cuerpo"
          }
        ],
        "notes": "Calentar bien antes de comenzar"
      },
      {
        "day": "Día 3",
        "focus": "Espalda y Bíceps",
        "exercises": [
          {
            "name": "Dominadas o jalones",
            "muscle": "Espalda, Bíceps",
            "sets": 3,
            "reps": "8-10",
            "rest": "60 segundos",
            "notes": "Enfócate en contraer los omóplatos"
          },
          {
            "name": "Curl de bíceps",
            "muscle": "Bíceps",
            "sets": 3,
            "reps": "10-12",
            "rest": "45 segundos",
            "notes": "Mantén los codos fijos a los lados"
          }
        ],
        "notes": "Estira bien después del entrenamiento"
      },
      {
        "day": "Día 4",
        "focus": "Hombros y Core",
        "exercises": [
          {
            "name": "Press de hombros",
            "muscle": "Deltoides",
            "sets": 3,
            "reps": "10-12",
            "rest": "60 segundos",
            "notes": "Mantén el core contraído durante el ejercicio"
          },
          {
            "name": "Elevaciones laterales",
            "muscle": "Deltoides laterales",
            "sets": 3,
            "reps": "12-15",
            "rest": "45 segundos",
            "notes": "Elevación controlada, sin usar impulso"
          }
        ],
        "notes": "Enfócate en la técnica correcta"
      },
      {
        "day": "Día 5",
        "focus": "Piernas y Glúteos",
        "exercises": [
          {
            "name": "Peso muerto",
            "muscle": "Isquiotibiales, Glúteos, Espalda baja",
            "sets": 3,
            "reps": "8-10",
            "rest": "90 segundos",
            "notes":
                "Mantén la espalda recta y las rodillas ligeramente flexionadas"
          },
          {
            "name": "Zancadas",
            "muscle": "Cuádriceps, Glúteos",
            "sets": 3,
            "reps": "10-12 por pierna",
            "rest": "60 segundos",
            "notes": "Mantén el torso erguido"
          }
        ],
        "notes": "Buen calentamiento para evitar lesiones"
      }
    ];

    // Añadir días según la cantidad solicitada
    for (int i = 0; i < daysPerWeek; i++) {
      if (i < templates.length) {
        workoutDays.add(templates[i]);
      }
    }

    return workoutDays;
  }

  static Future<Map<String, dynamic>?> _callGeminiAPI(String prompt) async {
    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    try {
      // Aumentar el timeout para dar más tiempo a la respuesta
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0.1, // Reducida para mayor consistencia
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 4096, // Aumentado para evitar truncamientos
              }
            }),
          )
          .timeout(Duration(seconds: 30)); // Timeout aumentado

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final generatedText =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (generatedText != null) {
          // Imprimir para depuración
          print(
              'Respuesta recibida de Gemini (primeros 200 caracteres): ${generatedText.substring(0, min(200, generatedText.length))}...');

          final String? jsonStr = _extractJsonFromText(generatedText);

          if (jsonStr != null) {
            try {
              // Validar que es JSON válido
              return jsonDecode(jsonStr);
            } catch (e) {
              print('Error en la validación final del JSON: $e');
              return null;
            }
          } else {
            print('No se pudo extraer JSON válido de la respuesta');
          }
        } else {
          print('No se encontró texto generado en la respuesta');
        }
      } else {
        print('Error en la API: ${response.statusCode} - ${response.body}');
      }

      return null;
    } catch (e) {
      print('Error al llamar a la API: $e');
      return null;
    }
  }

  // Utilidad para obtener el mínimo de dos números
  static int min(int a, int b) {
    return a < b ? a : b;
  }
}
