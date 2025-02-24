import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart'; // Añadido para rootBundle
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ListButtonSign extends StatefulWidget {
  const ListButtonSign({
    super.key,
    required this.isButtonSign,
    required this.onTextoEntered,
    this.gifsTraducidos = const [],
    this.currentText = '', // Añadido para recibir el texto actual
  });

  final bool isButtonSign;
  final Function(String) onTextoEntered;
  final List<String> gifsTraducidos;
  final String currentText; // Nuevo parámetro

  @override
  State<ListButtonSign> createState() => _ListButtonSignState();
}

class _ListButtonSignState extends State<ListButtonSign> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isDownloading = false;
  bool _isSharing = false;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isDenied) {
        await Permission.storage.request();
      }

      final micStatus = await Permission.microphone.status;
      if (micStatus.isDenied) {
        await Permission.microphone.request();
      }

      final speechStatus = await Permission.speech.status;
      if (speechStatus.isDenied) {
        await Permission.speech.request();
      }
    }
  }

  Future<bool> _checkAndRequestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    // Para Android 10 (API 29) y superior
    if (await _isAndroid10OrHigher()) {
      return await _handleAndroid10Permissions();
    }
    // Para Android 9 y anterior
    else {
      return await _handleLegacyStoragePermissions();
    }
  }

  Future<bool> _isAndroid10OrHigher() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      return deviceInfo.version.sdkInt >= 29;
    }
    return false;
  }

  Future<bool> _handleAndroid10Permissions() async {
    // Primero intentamos con los permisos normales de almacenamiento
    var storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) return true;

    // Si no funciona, intentamos con MANAGE_EXTERNAL_STORAGE
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }

    // Si los permisos fueron denegados, mostramos el diálogo
    if (!mounted) return false;

    final shouldOpenSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permisos necesarios'),
            content: const Text(
              'Para guardar GIFs necesitamos acceso al almacenamiento. '
              'Por favor, concede el permiso en la configuración de la aplicación.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Abrir Configuración'),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldOpenSettings) {
      await openAppSettings();
    }

    return false;
  }

  Future<bool> _handleLegacyStoragePermissions() async {
    var status = await Permission.storage.status;
    if (status.isGranted) return true;

    status = await Permission.storage.request();
    return status.isGranted;
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
    print("Inicializando reconocimiento de voz");
    await _checkPermissions();

    bool available = await _speech.initialize(
      onStatus: (status) {
        print("Estado del reconocimiento: $status");
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (errorNotification) {
        print('Error en el reconocimiento de voz: $errorNotification');
        setState(() => _isListening = false);
        _showMessage('Error en el reconocimiento de voz', isError: true);
      },
    );

    if (!available) {
      print("El reconocimiento de voz no está disponible");
      _showMessage(
        'El reconocimiento de voz no está disponible en este dispositivo',
        isError: true,
      );
    }
  }

  Future<void> _shareGif() async {
    if (_isSharing || widget.gifsTraducidos.isEmpty) return;

    try {
      setState(() => _isSharing = true);

      final gifPath = widget.gifsTraducidos.first;

      // Cargar el asset
      final ByteData byteData = await rootBundle.load(gifPath);

      // Crear archivo temporal
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.gif');

      // Escribir los bytes del asset al archivo temporal
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Compartir el archivo
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: 'Traducción de "${widget.currentText}"',
      );

      // Limpiar
      await tempFile.delete();
      _showMessage('GIF compartido exitosamente');
    } catch (e) {
      print('Error al compartir: $e');
      _showMessage('Error al compartir el GIF', isError: true);
    } finally {
      setState(() => _isSharing = false);
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Verificar el estado actual del permiso
      final status = await Permission.storage.status;

      if (status.isDenied) {
        // Si está denegado, solicitar el permiso
        final result = await Permission.storage.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        // Si está permanentemente denegado, mostrar diálogo para ir a configuración
        _showMessage(
          'Permiso denegado permanentemente. Por favor, habilítalo en la configuración de la aplicación.',
          isError: true,
        );

        // Preguntar al usuario si quiere ir a la configuración
        final goToSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permisos necesarios'),
            content: Text(
                'Para guardar GIFs necesitamos acceso al almacenamiento. ¿Deseas ir a la configuración para habilitarlo?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text('Ir a Configuración'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );

        if (goToSettings == true) {
          await openAppSettings();
        }
        return false;
      }

      return status.isGranted;
    }
    return true; // En iOS retornamos true ya que manejamos diferente el almacenamiento
  }

  // Función mejorada para verificar y solicitar permisos

  // Función mejorada para descargar GIF
  Future<void> _downloadGif() async {
    if (_isDownloading || widget.gifsTraducidos.isEmpty) return;

    try {
      setState(() => _isDownloading = true);

      // Verificar permisos
      final hasPermission = await _checkAndRequestStoragePermission();
      if (!hasPermission) {
        _showMessage('Se necesitan permisos para guardar el GIF',
            isError: true);
        return;
      }

      // Obtener el directorio de descarga
      Directory? directory;
      if (Platform.isAndroid) {
        if (await _isAndroid10OrHigher()) {
          // Para Android 10 y superior, usamos el directorio de descargas público
          directory = Directory('/storage/emulated/0/Download');
        } else {
          // Para versiones anteriores, usamos getExternalStorageDirectory
          final baseDir = await getExternalStorageDirectory();
          directory = Directory('${baseDir?.path}/Download');
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('No se pudo acceder al directorio de descargas');
      }

      // Asegurar que el directorio existe
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Generar nombre de archivo único
      final String sanitizedText = widget.currentText
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
          .toLowerCase();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'signspeak_${sanitizedText}_$timestamp.gif';
      final String filePath = '${directory.path}/$fileName';

      // Cargar y guardar el GIF
      final ByteData data = await rootBundle.load(widget.gifsTraducidos.first);
      final File file = File(filePath);
      await file.writeAsBytes(
        data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        ),
      );

      if (await file.exists()) {
        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Descarga Exitosa!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('El GIF se ha guardado en:'),
                const SizedBox(height: 8),
                Text(
                  'Carpeta: Descargas',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Nombre: $fileName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        _showMessage(
          'GIF guardado en Descargas como: $fileName',
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception('Error al verificar el archivo guardado');
      }
    } catch (e) {
      print('Error al descargar GIF: $e');
      _showMessage(
        'Error al guardar el GIF. Por favor, intenta de nuevo.',
        isError: true,
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  // Actualizar la función _showMessage para permitir duración personalizada
  void _showMessage(String message,
      {bool isError = false, Duration? duration}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: duration ?? Duration(seconds: 2),
      ),
    );
  }

  Future<void> _startListening() async {
    print("Iniciando reconocimiento de voz");

    if (!_isListening) {
      final available = await _speech.initialize();

      if (available) {
        setState(() => _isListening = true);
        try {
          await _speech.listen(
            onResult: (result) {
              print("Texto reconocido: ${result.recognizedWords}");
              setState(() => _currentText = result.recognizedWords);

              if (result.finalResult) {
                print("Texto final: ${result.recognizedWords}");
                widget.onTextoEntered(result.recognizedWords);
              }
            },
            localeId: 'es-ES',
            listenMode: stt.ListenMode.confirmation,
            cancelOnError: true,
            partialResults: false,
          );
          _showMessage('Escuchando...', isError: false);
        } catch (e) {
          print("Error al escuchar: $e");
          setState(() => _isListening = false);
          _showMessage('Error al iniciar el reconocimiento', isError: true);
        }
      }
    }
  }

  void _stopListening() {
    print("Deteniendo reconocimiento de voz");
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _speech.stop();
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
        /*IconButton(
          icon: Icon(Icons.draw, color: Colors.grey),
          onPressed: () {
            // Acción del botón de dibujo
          },
        ),*/
        IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening ? Colors.red : Colors.grey,
          ),
          onPressed: _isListening ? _stopListening : _startListening,
          tooltip: 'Reconocimiento de voz',
        ),
      ],
    );
  }

  Container buttonSign() {
    bool isGifAvailable = widget.gifsTraducidos.isNotEmpty;

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
                : Icon(Icons.download,
                    color: isGifAvailable
                        ? Colors.grey
                        : Colors.grey.withOpacity(0.3)),
            onPressed: isGifAvailable && !_isDownloading ? _downloadGif : null,
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
                : Icon(Icons.share,
                    color: isGifAvailable
                        ? Colors.grey
                        : Colors.grey.withOpacity(0.3)),
            onPressed: isGifAvailable && !_isSharing ? _shareGif : null,
            tooltip: 'Compartir',
          ),
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.grey.withOpacity(0.3)),
            onPressed: null, // Deshabilitado por ahora
            tooltip: 'Guardar',
          ),
        ],
      ),
    );
  }
}
