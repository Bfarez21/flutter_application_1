import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/constants/Theme.dart';
import 'package:camera/camera.dart';

//widgets
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/card-horizontal.dart';
import 'package:flutter_application_1/widgets/card-small.dart';
import 'package:flutter_application_1/widgets/card-square.dart';
import 'package:flutter_application_1/widgets/drawer.dart';

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

  @override
  void initState() {
    super.initState();
    initializeCamera();
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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void toggleLayout() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        value: "Sign",
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "Español",
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
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "VLS",
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                    maxLines: 5,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.back_hand_rounded,
                      size: 150,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
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
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "VLS",
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
                        value: "Sign",
                        underline: SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "Español",
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
                        "",
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
