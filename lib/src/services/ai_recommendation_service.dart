// lib/src/services/simple_ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class SimpleAIService {
  // Tu API key de Google Gemini
  static const String apiKey = 'AIzaSyCeCCwh9jbZwLNc5keYGL_kM1yXL_hV0Tk';
  
  // Método para generar una rutina personalizada basada en los requerimientos del usuario
  static Future<Map<String, dynamic>> generateWorkoutRoutine({
    required String level,         // Nivel de experiencia (principiante, intermedio, avanzado)
    required String goal,          // Objetivo (pérdida de peso, volumen, definición, etc.)
    required int daysPerWeek,      // Días de entrenamiento por semana
    String? focusMuscleGroup,      // Grupo muscular de enfoque (opcional)
    String? additionalDetails,     // Detalles adicionales (opcional)
  }) async {
    try {
      // Construir el prompt para la IA
      final String prompt = _buildPrompt(level, goal, daysPerWeek, focusMuscleGroup, additionalDetails);
      
      // Llamar a la API de Gemini
      final Map<String, dynamic>? response = await _callGeminiAPI(prompt);
      
      // Si la respuesta es válida, devolverla
      if (response != null) {
        return response;
      }
      
      // Si no hay respuesta válida, mostrar mensaje de error
      throw Exception('No se pudo generar la rutina. Por favor, intenta nuevamente.');
      
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
  Eres un entrenador personal experto. Genera una rutina de entrenamiento EXACTAMENTE en este formato JSON sin ningún texto adicional:
  {
    "routineName": "Nombre descriptivo de la rutina",
    "description": "Descripción completa de la rutina",
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
            "notes": "Consejos técnicos"
          }
        ],
        "notes": "Notas generales para el día"
      }
    ],
    "nutritionTips": "Consejos nutricionales específicos",
    "restDayTips": "Recomendaciones para días de descanso"
  }
  
  Asegúrate de que:
  - El JSON sea COMPLETAMENTE VÁLIDO
  - Incluyas TODOS los campos
  - NO añadas texto fuera del JSON
  - Los valores sean coherentes y realistas
  ${focusMuscleGroup != null && focusMuscleGroup != 'Todos' ? 'Enfócate específicamente en: $focusMuscleGroup' : ''}
  ${additionalDetails != null && additionalDetails.isNotEmpty ? 'Considera: $additionalDetails' : ''}
  ''';
}
  
static String? _extractJsonFromText(String text) {
  try {
    // Eliminar los markdown delimiters
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();
    
    // Limpiar texto antes y después del JSON
    final jsonStartIndex = text.indexOf('{');
    final jsonEndIndex = text.lastIndexOf('}') + 1;
    
    if (jsonStartIndex != -1 && jsonEndIndex != -1) {
      text = text.substring(jsonStartIndex, jsonEndIndex);
    }
    
    // Intentar reparar JSON parcial
    text = _repairPartialJson(text);
    
    // Validar y devolver el JSON
    try {
      // Intentar parsear para validar
      final parsedJson = jsonDecode(text);
      return jsonEncode(parsedJson); // Recodificar para asegurar formato válido
    } catch (e) {
      print('Error al parsear JSON: $e');
      print('Texto problemático: $text');
      
      // Último intento de reparación
      text = _ultimoIntentoDeSalvacion(text);
      
      try {
        final parsedJson = jsonDecode(text);
        return jsonEncode(parsedJson);
      } catch (finalError) {
        print('Error final al parsear JSON: $finalError');
        return null;
      }
    }
  } catch (e) {
    print('Error al extraer JSON: $e');
  }
  
  return null;
}

static String _repairPartialJson(String text) {
  // Eliminar líneas incompletas o con errores
  final lines = text.split('\n');
  final cleanedLines = lines.where((line) {
    // Eliminar líneas vacías o con llaves mal formadas
    return line.trim().isNotEmpty && 
           !line.contains('}]') && 
           !line.contains('"{') &&
           !line.contains(':"');
  }).toList();
  
  // Reconstruir JSON
  text = cleanedLines.join('\n');
  
  // Asegurar que el JSON tenga todas las estructuras necesarias
  if (!text.contains('"nutritionTips"')) {
    // Añadir campos faltantes al final
    text = text.substring(0, text.lastIndexOf('}')) + 
           ', "nutritionTips": "Consejos nutricionales", ' +
           '"restDayTips": "Consejos para días de descanso"' +
           '}';
  }
  
  // Completar arrays y objetos
  text = _completeJsonStructures(text);
  
  return text;
}

static String _ultimoIntentoDeSalvacion(String text) {
  // Eliminar cualquier carácter después del último }
  final lastBraceIndex = text.lastIndexOf('}');
  if (lastBraceIndex != -1) {
    text = text.substring(0, lastBraceIndex + 1);
  }
  
  // Añadir campos faltantes si no existen
  if (!text.contains('"nutritionTips"')) {
    text = text.substring(0, text.lastIndexOf('}')) + 
           ', "nutritionTips": "Consejos nutricionales generales", ' +
           '"restDayTips": "Descanso activo y recuperación"' +
           '}';
  }
  
  // Completar estructuras de arrays
  if (text.contains('"workoutDays"') && !text.contains(']}')) {
    text = text.replaceAll('"workoutDays": [', '"workoutDays": [')
               .replaceAll('"exercises": [', '"exercises": [');
    
    // Contar y cerrar corchetes y llaves
    int openBrackets = '['.allMatches(text).length;
    int closeBrackets = ']'.allMatches(text).length;
    
    while (openBrackets > closeBrackets) {
      text += ']';
      closeBrackets++;
    }
    
    int openBraces = '{'.allMatches(text).length;
    int closeBraces = '}'.allMatches(text).length;
    
    while (openBraces > closeBraces) {
      text += '}';
      closeBraces++;
    }
  }
  
  return text;
}

static String _completeJsonStructures(String text) {
  // Contar llaves y corchetes
  int openBraces = '{'.allMatches(text).length;
  int closeBraces = '}'.allMatches(text).length;
  int openBrackets = '['.allMatches(text).length;
  int closeBrackets = ']'.allMatches(text).length;
  
  // Cerrar estructuras abiertas
  while (openBraces > closeBraces) {
    text += '}';
    closeBraces++;
  }
  
  while (openBrackets > closeBrackets) {
    text += ']'; 
    closeBrackets++;
  }
  
  return text;
}



static Future<Map<String, dynamic>?> _callGeminiAPI(String prompt) async {
  final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';
  
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{'parts': [{'text': prompt}]}],
        'generationConfig': {
          'temperature': 0.2,
          'topK': 32,
          'topP': 0.95,
          'maxOutputTokens': 2048,
        }
      }),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final generatedText = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      
      if (generatedText != null) {
        final String? jsonStr = _extractJsonFromText(generatedText);
        
        if (jsonStr != null) {
          return jsonDecode(jsonStr);
        }
      }
    }
    
    return null;
  } catch (e) {
    print('Error al llamar a la API: $e');
    return null;
  }
}}