import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Camara extends StatefulWidget {
  final Function(String) onTextoDetectado;
  final VoidCallback toggleLayout;

  Camara({
    required this.onTextoDetectado,
    required this.toggleLayout,
  });

  @override
  _CamaraState createState() => _CamaraState();
}

class _CamaraState extends State<Camara> {
  CameraController? cameraController;
  WebSocketChannel? _webSocket;
  bool _isProcessing = false;
  Timer? _frameTimer;
  String textoAcumulado = "";
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  static const int TARGET_FPS = 1;
  static const int FRAME_INTERVAL = 1000 ~/ TARGET_FPS;

  Future<void> initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraController!.initialize();
    await cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) return;

    setState(() {});

    _connectWebSocket();
    _startFrameCapture();
  }

  void _switchCamera() async {
    final cameras = await availableCameras();
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;

    if (cameraController != null) {
      await cameraController!.dispose();
    }

    cameraController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraController!.initialize();
    await cameraController!.setFlashMode(FlashMode.off);

    if (mounted) setState(() {});
  }

  void _connectWebSocket() {
    try {
      final wsUrl = dotenv.env['WS_URL'] ?? 'ws://192.168.52.39:8080/ws';
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
    // Calculamos el ancho de la visualización de la cámara
    final cameraWidth = MediaQuery.of(context).size.width -
        40; // Restamos el margen horizontal (20 + 20)

    return Column(
      children: [
        // Contenedor para la cámara (con espacio reducido arriba)
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 2), // Margen horizontal y reducido arriba
            /*decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.grey, width: 2), // Borde opcional
            )*/
            child: Stack(
              children: [
                if (cameraController != null &&
                    cameraController!.value.isInitialized)
                  CameraPreview(cameraController!),
                if (cameraController == null ||
                    !cameraController!.value.isInitialized)
                  Center(child: CircularProgressIndicator()),

                // Botón para cambiar cámara (dentro del frame de la cámara)
                Positioned(
                  top: 10,
                  right: 10,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _switchCamera,
                    child: Icon(Icons.flip_camera_ios),
                    backgroundColor: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Espacio para el botón del teclado (altura mínima, mismo ancho que la cámara)
        Container(
          margin: EdgeInsets.only(
              left: 20, right: 20, top: 5, bottom: 2), // Margen reducido
          height: 40, // Altura reducida para el botón del teclado
          width:
              cameraWidth - 65, // Mismo ancho que la visualización de la cámara
          alignment: Alignment.center,
          child: TextButton(
            onPressed: widget.toggleLayout,
            style: TextButton.styleFrom(
              backgroundColor: Colors.black54, // Color de fondo
              minimumSize: Size(cameraWidth - 65,
                  40), // Mismo ancho que la cámara y altura reducida
              padding: EdgeInsets.zero, // Eliminar padding interno
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Sin bordes redondeados
              ),
            ),
            child: Icon(Icons.keyboard,
                size: 18, color: Colors.white), // Icono del teclado
          ),
        ),
      ],
    );
  }
}
