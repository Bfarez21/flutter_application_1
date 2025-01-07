import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';

class ModeloIA {
  Interpreter? _interpreter;
  List<String> _labels = [];
  static const String modelPath = "assets/modeloTflite/model_unquant.tflite";
  static const String labelsPath = "assets/modeloTflite/labels.txt";

  /// Carga el modelo y las etiquetas desde los recursos.
  Future<void> cargarModelo() async {
    try {
      // Cargar el modelo TFLite desde los activos
      _interpreter = await Interpreter.fromAsset(modelPath);

      // Leer las etiquetas desde el archivo de activos
      final String labelsData = await rootBundle.loadString(labelsPath);
      _labels = labelsData
          .split('\n')
          .where((label) => label.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Error al cargar modelo o etiquetas: $e');
    }
  }

  /// Realiza una predicción con el modelo cargado.
  List<double> realizarPrediccion(List<int> inputBytes) {
    if (_interpreter == null) {
      throw Exception('Intérprete no inicializado');
    }

    // Crear la salida para almacenar los resultados
    final output = List<double>.filled(
      1 * _labels.length,
      0,
    ).reshape([1, _labels.length]);

    // Ejecutar la predicción
    _interpreter!.run(inputBytes, output);

    return output[0];
  }

  /// Interpreta las predicciones y devuelve las etiquetas con confianza.
  String interpretarPredicciones(List<double> predicciones) {
    return _labels.asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value;
      final confidence = (predicciones[index] * 100).toStringAsFixed(1);
      return '$label: $confidence%';
    }).join('\n');
  }

  /// Devuelve la etiqueta con mayor probabilidad.
  String obtenerPrediccionPrincipal(List<double> predicciones) {
    if (predicciones.isEmpty) {
      return "No se encontraron predicciones";
    }
    final maxIndex = predicciones.indexWhere(
      (value) => value == predicciones.reduce((a, b) => a > b ? a : b),
    );
    return _labels[maxIndex];
  }

  /// Libera los recursos del intérprete.
  void liberarRecursos() {
    _interpreter?.close();
  }
}
