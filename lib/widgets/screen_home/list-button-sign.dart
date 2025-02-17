import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ListButtonSign extends StatefulWidget {
  const ListButtonSign({
    super.key,
    required this.isButtonSign,
    required this.onTextoEntered,
  });

  final bool isButtonSign;
  final Function(String) onTextoEntered;

  @override
  State<ListButtonSign> createState() => _ListButtonSignState();
}

class _ListButtonSignState extends State<ListButtonSign> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isDownloading = false;
  bool _isSharing = false;
  String _currentText = '';
  final Dio _dio = Dio();

  final String testGifUrl =
      'https://media.giphy.com/media/3o7TKSjRrfIPjeiVyE/giphy.gif';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
      }
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();

      if (!status.isGranted) {
        _showMessage(
          'Se necesitan permisos para guardar archivos. Habilítalos en configuración.',
          isError: true,
        );

        await openAppSettings();
        return false;
      }
    }
    return true;
  }

  Future<void> _initializeSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          print('Error: $error');
          setState(() => _isListening = false);
          _showMessage('Error en el reconocimiento de voz', isError: true);
        },
      );
      if (!available) {
        _showMessage('El dispositivo no soporta reconocimiento de voz',
            isError: true);
      }
    } catch (e) {
      print('Error al inicializar el reconocimiento de voz: $e');
      _showMessage('Error al inicializar el reconocimiento de voz',
          isError: true);
    }
  }

  Future<void> _shareGif() async {
    if (_isSharing) return;

    try {
      setState(() => _isSharing = true);

      final response = await _dio.get(
        testGifUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/temp_sign_language.gif');
      await file.writeAsBytes(response.data);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Mira este signo en lenguaje de señas\n$_currentText',
      );

      await file.delete();
    } catch (e) {
      _showMessage('Error al compartir: $e', isError: true);
    } finally {
      setState(() => _isSharing = false);
    }
  }

  Future<void> _downloadGif() async {
    if (_isDownloading) return;

    if (!await _requestPermissions()) {
      return;
    }

    try {
      setState(() => _isDownloading = true);

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('No se pudo acceder al directorio de descargas');
      }

      final String fileName =
          'sign_language_${DateTime.now().millisecondsSinceEpoch}.gif';
      final String filePath = '${directory.path}/$fileName';

      final response = await _dio.get(
        testGifUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data);

      _showMessage('GIF guardado en Descargas: $fileName');
    } catch (e) {
      print('Error al descargar: $e');
      _showMessage('Error al descargar el GIF', isError: true);
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  Future<void> _listen() async {
    try {
      if (!_isListening) {
        bool available = await _speech.initialize();
        if (available) {
          setState(() => _isListening = true);
          await _speech.listen(
            onResult: (result) {
              setState(() {
                _currentText = result.recognizedWords;
                // Actualizar el texto en el padre inmediatamente cuando hay cambios
                widget.onTextoEntered(_currentText);
              });

              // Si es el resultado final, detener la escucha
              if (result.finalResult) {
                setState(() {
                  _isListening = false;
                });
                _speech.stop();
              }
            },
            localeId: 'es-ES',
            cancelOnError: true,
            listenMode: stt.ListenMode
                .dictation, // Cambiado a dictation para mejor respuesta
          );
        }
      } else {
        setState(() => _isListening = false);
        await _speech.stop();
      }
    } catch (e) {
      print('Error en el reconocimiento de voz: $e');
      setState(() => _isListening = false);
      _showMessage('Error en el reconocimiento de voz', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isButtonSign ? buttonSign() : buttonText();
  }

  Row buttonText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.draw, color: Colors.grey),
          onPressed: () {
            // Acción del botón de dibujo
          },
        ),
        IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening ? Colors.red : Colors.grey,
          ),
          onPressed: _listen,
          tooltip: 'Reconocimiento de voz',
        ),
      ],
    );
  }

  Container buttonSign() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: _isDownloading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  )
                : Icon(Icons.download, color: Colors.grey),
            onPressed: _isDownloading ? null : _downloadGif,
            tooltip: 'Guardar en Descargas',
          ),
          IconButton(
            icon: _isSharing
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  )
                : Icon(Icons.share, color: Colors.grey),
            onPressed: _isSharing ? null : _shareGif,
            tooltip: 'Compartir',
          ),
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.grey),
            onPressed: () {
              // Acción del botón de guardar
            },
            tooltip: 'Guardar',
          ),
        ],
      ),
    );
  }
}
