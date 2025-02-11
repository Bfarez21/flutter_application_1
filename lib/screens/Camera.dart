import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Camara extends StatefulWidget {
  final Function(String) onTextoDetectado;

  Camara({required this.onTextoDetectado});

  @override
  _CamaraState createState() => _CamaraState();
}

class _CamaraState extends State<Camara> {
  CameraController? cameraController;
  WebSocketChannel? _webSocket;
  bool _isProcessing = false;
  Timer? _frameTimer;
  String textoAcumulado = "";

  // Control de FPS para optimizar el rendimiento
  static const int TARGET_FPS = 1; // Un frame por segundo como tenías antes
  static const int FRAME_INTERVAL = 1000 ~/ TARGET_FPS;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraController!.initialize();
    await cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) return;

    setState(() {});

    // Iniciar WebSocket y captura de frames
    _connectWebSocket();
    _startFrameCapture();
  }

  void _connectWebSocket() {
    try {
      final wsUrl = dotenv.env['WS_URL'] ?? 'ws://192.168.0.102:8080/ws';
      _webSocket = WebSocketChannel.connect(Uri.parse(wsUrl));

      _webSocket!.stream.listen(
        (message) => _handleWebSocketMessage(message),
        onError: (error) {
          print('WebSocket error: $error');
          _reconnectWebSocket();
        },
        onDone: () => _reconnectWebSocket(),
      );
    } catch (e) {
      print('Error conectando WebSocket: $e');
      _reconnectWebSocket();
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      String prediccion = data['prediccion'] ?? '';

      if (prediccion.isNotEmpty) {
        setState(() {
          textoAcumulado += " " + prediccion;
          widget.onTextoDetectado(textoAcumulado);
        });
      }
    } catch (e) {
      print('Error procesando mensaje: $e');
    }
  }

  void _startFrameCapture() {
    _frameTimer = Timer.periodic(
      Duration(milliseconds: FRAME_INTERVAL),
      (_) => _captureAndSendFrame(),
    );
  }

  Future<void> _captureAndSendFrame() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        _isProcessing ||
        _webSocket == null) return;

    _isProcessing = true;

    try {
      final XFile imagen = await cameraController!.takePicture();
      final bytes = await imagen.readAsBytes();

      _webSocket!.sink.add(jsonEncode({
        'frame': base64Encode(bytes),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }));
    } catch (e) {
      print('Error capturando frame: $e');
    } finally {
      _isProcessing = false;
    }
  }

  void _reconnectWebSocket() {
    _webSocket?.sink.close();
    Future.delayed(Duration(seconds: 2), _connectWebSocket);
  }

  void _resetTexto() {
    setState(() {
      textoAcumulado = "";
      widget.onTextoDetectado(textoAcumulado);
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _webSocket?.sink.close();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (cameraController != null && cameraController!.value.isInitialized)
          CameraPreview(cameraController!),
        if (cameraController == null || !cameraController!.value.isInitialized)
          Center(child: CircularProgressIndicator())
      ],
    );
  }
}
