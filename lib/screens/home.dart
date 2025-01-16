import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
// Constante
import 'package:flutter_application_1/constants/text_to_sign.dart';
//widgets
import 'package:flutter_application_1/widgets/drawer.dart';
import 'package:flutter_application_1/widgets/slider-product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool isReversed = false;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  List<dynamic>? _recognitions; // Almacena los resultados del modelo
  String ingresoTexto = "";
  String? gifPath; // ruta del gifs

  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel(); // Carga el modelo TFLite
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.medium,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite", // Ruta del modelo TFLite
      labels: "assets/labels.txt", // Ruta del archivo de etiquetas
    );
    print("Modelo cargado: $res");
  }

  void runModelOnFrame() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final frame = await _cameraController!.takePicture(); // Captura un frame

      final recognitions = await Tflite.runModelOnImage(
        path: frame.path, // Ruta de la imagen
        numResults: 5, // Número máximo de resultados
        threshold: 0.5, // Umbral de confianza
      );

      setState(() {
        _recognitions = recognitions;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    Tflite.close(); // Libera los recursos del modelo
    super.dispose();
  }

  void toggleLayout() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para el carrusel
    List<Map<String, String>> exampleImages = [
      {
        "img": "assets/images/fondoManos.png",
        "title": "GIF 1",
        "description": "Sign for A"
      },
      {
        "img": "assets/images/user.png",
        "title": "GIF 2",
        "description": "Sign for B"
      },
      {
        "img": "assets/images/text_to_signs.jpeg",
        "title": "GIF 3",
        "description": "Sign for C"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: Navbar(
        title: "Traductor",
        searchBar: false,
      ),
      drawer: MaterialDrawer(currentPage: "Home"),
      body: isReversed
          ? Column(
              children: [
                // Barra de selección invertida
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(30), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Sombra ligera
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        value: "VLS",
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: "VLS",
                            child: Text(
                              "VLS",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "ALS",
                            child: Text(
                              "ALS",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                      GestureDetector(
                        onTap: toggleLayout,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                      ),
                      DropdownButton<String>(
                        value: "Español",
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "Español",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "English",
                            child: Text(
                              "English",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        ingresoTexto = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Escribe aquí...',
                    ),
                    maxLines: 5,
                  ),
                ),
                /*Expanded(
                  child: Center(
                    child: Icon(
                      Icons.back_hand_rounded,
                      size: 150,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                 Expanded(
            child: Center(
              child: ingresoTexto.isNotEmpty
                  ? Image.asset(
                      TextToSignLogic.getGifForText(ingresoTexto) ??
                          'assets/gifs/default.gif',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      child: Text(
                        "Ingresa una palabra para ver el GIF",
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
            ),
          ),*/
                // Agregar el carrusel debajo del TextField
                ProductCarousel(imgArray: exampleImages),
                Expanded(
                  child: Center(
                    child: ingresoTexto.isNotEmpty
                        ? FutureBuilder<Widget>(
                            future: Future(() {
                              List<String> gifs =
                                  TextToSignLogic.translateTextToGifs(
                                      ingresoTexto);
                              // Por ahora mostraremos solo el primer GIF
                              return gifs.isNotEmpty
                                  ? Image.asset(
                                      gifs.first,
                                      width: 215,
                                      height: 215,
                                      fit: BoxFit.cover,
                                    )
                                  : Text(
                                      "No se encontró traducción",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.7)),
                                    );
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!;
                              }
                              return CircularProgressIndicator();
                            },
                          )
                        : Container(
                            child: Text(
                              "Ingresa una palabra para ver ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                          ),
                  ),
                )
              ],
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        value: "Español",
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "Español",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "English",
                            child: Text(
                              "English",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                      GestureDetector(
                        onTap: toggleLayout,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                      ),
                      DropdownButton<String>(
                        value: "VLS",
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: "VLS",
                            child: Text(
                              "VLS",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "ALS",
                            child: Text(
                              "ALS",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.0), // Espacio lateral
                      height: MediaQuery.of(context).size.height *
                          0.5, // Mayor altura
                      child: _cameraController != null &&
                              _cameraController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _cameraController!.value.aspectRatio,
                              child: CameraPreview(_cameraController!),
                            )
                          : Icon(
                              Icons.camera_alt,
                              size: 120,
                              color: Colors.white.withOpacity(0.7),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 160,
                    child: Center(
                      child: Text(
                        _recognitions != null
                            ? _recognitions!.map((e) => e['label']).join(', ')
                            : "",
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
