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
  bool _speechInitialized = false;
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
      // Verificar permisos de almacenamiento
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isDenied) {
        await Permission.storage.request();
      }

      // Verificar permisos de micrófono
      final micStatus = await Permission.microphone.status;
      if (micStatus.isDenied) {
        await Permission.microphone.request();
      }

      // Verificar permisos de reconocimiento de voz
      final speechStatus = await Permission.speech.status;
      if (speechStatus.isDenied) {
        await Permission.speech.request();
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
      // Asegurarse de que los permisos estén concedidos antes de inicializar
      if (Platform.isAndroid) {
        final micPermission = await Permission.microphone.status;
        final speechPermission = await Permission.speech.status;

        if (!micPermission.isGranted || !speechPermission.isGranted) {
          _showMessage('Se requieren permisos de micrófono y voz',
              isError: true);
          return;
        }
      }

      _speechInitialized = await _speech.initialize(
        onStatus: (status) {
          print('Status: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          print('Error: $errorNotification');
          setState(() => _isListening = false);
          _showMessage('Error: ${errorNotification.errorMsg}', isError: true);
        },
        debugLogging: true,
      );

      if (!_speechInitialized) {
        _showMessage('No se pudo inicializar el reconocimiento de voz',
            isError: true);
      }
    } catch (e) {
      print('Error al inicializar el reconocimiento de voz: $e');
      _showMessage('Error al inicializar el reconocimiento de voz',
          isError: true);
      _speechInitialized = false;
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
    if (!_speechInitialized) {
      await _initializeSpeech();
    }

    // Verificar permisos antes de iniciar el reconocimiento
    final micPermission = await Permission.microphone.status;
    if (!micPermission.isGranted) {
      _showMessage('Se requieren permisos de micrófono', isError: true);
      return;
    }

    try {
      if (!_isListening) {
        if (_speechInitialized) {
          setState(() => _isListening = true);

          await _speech.listen(
            onResult: (result) {
              setState(() {
                _currentText = result.recognizedWords;
                widget.onTextoEntered(_currentText);
              });

              if (result.finalResult) {
                setState(() {
                  _isListening = false;
                });
              }
            },
            localeId: 'es-419', // Usa el idioma correcto
            cancelOnError: true,
            listenMode: stt.ListenMode.dictation,
            partialResults: true,
            listenFor: Duration(seconds: 30),
            pauseFor: Duration(seconds: 3),
          );
        } else {
          _showMessage('Por favor, concede los permisos necesarios',
              isError: true);
        }
      } else {
        setState(() => _isListening = false);
        await _speech.stop();
      }
    } catch (e) {
      print('Error en el reconocimiento de voz: $e');
      setState(() => _isListening = false);
      _showMessage('Error en el reconocimiento de voz: $e', isError: true);
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
