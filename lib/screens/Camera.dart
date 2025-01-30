import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['BASE_URL_DEV']!;

class Camara extends StatefulWidget {
  final Function(String) onTextoDetectado;

  Camara({required this.onTextoDetectado});

  @override
  _CamaraState createState() => _CamaraState();
}

class _CamaraState extends State<Camara> {
  CameraController? cameraController;
  bool _isProcessing = false;
  Timer? _timer;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg, // 🔹 Asegurar formato JPEG
    );

    await cameraController!.initialize();

    // 🔹 Desactivar el flash
    await cameraController!.setFlashMode(FlashMode.off);
    if (!mounted) return;
    setState(() {});

    // 🔹 Capturar automáticamente cada 2 segundos
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      enviarImagenAlBackend();
    });
  }

  // Agrega una variable global para almacenar el texto acumulado
  String textoAcumulado = "";

  Future<void> enviarImagenAlBackend() async {
    if (cameraController == null || _isProcessing) return;

    try {
      _isProcessing = true;

      XFile? imagen = await cameraController!.takePicture();
      if (imagen == null) return;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict/'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imagen.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        String textoDetectado = jsonDecode(responseData)['prediccion'];

        // 🔹 Acumulamos el texto detectado en lugar de sobrescribirlo
        textoAcumulado += " " + textoDetectado;

        // 🔹 Actualizamos el estado con el texto acumulado
        widget.onTextoDetectado(textoAcumulado);
      } else {
        print("Error en la respuesta del backend: $responseData");
      }
    } catch (e) {
      print("Error al enviar la imagen: $e");
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _timer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cameraController != null && cameraController!.value.isInitialized
        ? CameraPreview(cameraController!)
        : Center(child: CircularProgressIndicator());
  }
}
