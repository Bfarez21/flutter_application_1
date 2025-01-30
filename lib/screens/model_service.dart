import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img; // Alias para evitar conflicto

class ModelService {
  late Interpreter _interpreter;

  // Constructor para cargar el modelo al inicializar la clase
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('nombre_del_modelo.tflite');
    print("Modelo cargado correctamente");
  }

  void processImage(img.Image image) {
    // Usar img.Image en lugar de Image
    if (_interpreter == null) {
      print("Error: El intérprete no está listo");
      return;
    }

    try {
      // Cambia el tamaño de la imagen
      image = img.copyResize(image, height: 224, width: 224);

      // Convierte la imagen a bytes normalizados
      var input = image.getBytes().map((pixel) => pixel / 255.0).toList();

      // Convertir a List<double> y ajustar la forma del tensor
      input = (input as List<double>);
      input.reshape([1, 224, 224, 3]);

      // Prepara la salida del modelo
      var output = List.filled(1 * 1001, 0.0).reshape([1, 1001]);

      // Ejecuta el modelo
      _interpreter.run(input, output);
      print("Predicción: $output");
    } catch (e) {
      print("Error procesando la imagen: $e");
    }
  }
}
