import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/services/Archivo api_service.dart';
import 'package:flutter_application_1/services/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() async {
  // Asegúrate de cargar las variables de entorno antes de correr la app.
  await dotenv.load(fileName: ".env");
  runApp(MyApp());

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignSpeak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1A1A2E),
        scaffoldBackgroundColor: Color(0xFF1A1A2E),
      ),
      home: CategoriesScreen(),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      "img": AssetImage("assets/images/numeros.png"),
      "title": "Números",
      "type": "numeros"
    },
    {
      "img": AssetImage("assets/images/colores.png"),
      "title": "Colores",
      "type": "colores"
    },
    {
      "img": AssetImage("assets/images/comidasbebidas.png"),
      "title": "Comidas y Bebidas",
      "type": "comidabenbidas"
    },
    {
      "img": AssetImage("assets/images/diasSemana.jpeg"),
      "title": "Días de la Semana",
      "type": "diassemana"
    },
    {
      "img": AssetImage("assets/images/preguntas.jpg"),
      "title": "Preguntas",
      "type": "preguntas"
    },
    {
      "img": AssetImage("assets/images/profesiones.jpg"),
      "title": "Profesiones",
      "type": "profesiones"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Color(0xFF1A1A2E), // Fondo azul oscuro
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWelcomeHeader(),
            _buildDescriptionInfo(),
            _buildVerticalCarousel(context),
          ],
        ),
      ),
    );
  }

  // Encabezado de bienvenida
  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        '¡Explora las categorías!',
        style: TextStyle(
          color: Color(0xFF0EA5E9), // Azul brillante
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Sección descriptiva de la pantalla
  Widget _buildDescriptionInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Text(
            'En ese carrusel tendrás diferentes categorías con los lenguajes de señas más comunes.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFA8B2D1), // Texto claro
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Divider(
            thickness: 2,
            color: Color(0xFF2A2D3E), // Divisor oscuro
          ),
        ],
      ),
    );
  }

  // Método del AppBar con colores combinados
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "SignSpeak",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black54,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
            TextSpan(
              text: "\nAprende Lengua de Señas",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)], // Degradado oscuro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 5,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  // Carrusel vertical
  Widget _buildVerticalCarousel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.5,
          scrollDirection: Axis.vertical,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          enlargeCenterPage: true,
          viewportFraction: 0.85,
        ),
        items: categories.map((category) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => _navigateToCategory(context, category),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image(
                          image: category['img'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.blueAccent.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              category['title'],
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  void _navigateToCategory(
      BuildContext context, Map<String, dynamic> category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => CategoryDetailScreen(
          categoryType: category['type'],
          categoryTitle: category['title'],
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

class CategoryDetailScreen extends StatefulWidget {
  final String categoryType;
  final String categoryTitle;

  const CategoryDetailScreen({
    required this.categoryType,
    required this.categoryTitle,
  });

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String? _usuarioId;
  List<Gif> gifs = [];
  List<Gif> filteredGifs = [];
  String? selectedGif;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchGifs();
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final usuario = await ApiService.getUsuario(user.uid);
        setState(() {
          _usuarioId = usuario.id.toString();
        });
      }
    } catch (e) {
      print('Error obteniendo usuario: $e');
    }
  }

  Future<void> fetchGifs() async {
    final baseUrl = dotenv.env['BASE_URL_DEV'];
    final response = await http.get(Uri.parse('$baseUrl/api/gifs/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        gifs = data.map((json) => Gif.fromJson(json)).toList();
        filteredGifs =
            gifs.where((gif) => gif.categoria == getCategoryId()).toList();
      });
    }
  }

  int getCategoryId() {
    switch (widget.categoryType.toLowerCase()) {
      case 'numeros':
        return 3;
      case 'colores':
        return 1;
      case 'comidabenbidas':
        return 2;
      case 'diassemana':
        return 4;
      default:
        return 0;
    }
  }
  // Modificar la definición del método
  Future<void> _guardarEnHistorial(BuildContext context, int gifId) async {
    if (_usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para guardar en el historial')),
      );
      return;
    }

    try {
      await ApiService.guardarEnHistorial(int.parse(_usuarioId!), gifId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando en historial: $e')),
      );
    }
  }

  void filterGifs(String query) {
    setState(() {
      filteredGifs = gifs.where((gif) {
        final categoryMatch = gif.categoria == getCategoryId();
        final nameMatch =
            gif.nombre.toLowerCase().contains(query.toLowerCase());
        return categoryMatch && nameMatch;
      }).toList();

      if (filteredGifs.isNotEmpty) {
        selectedGif = filteredGifs.first.archivo;
          _guardarEnHistorial(context, filteredGifs.first.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16213E),
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
        backgroundColor: Color(0xFF1A1A2E), // Fondo del AppBar
        iconTheme: IconThemeData(color: Colors.white), // Flecha en blanco
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildInfoCard(),
          _buildGifDisplayArea(),
          _buildGifButtons(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF2A2D3E), // Fondo oscuro
          hintText: 'Buscar GIF...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Color(0xFF0EA5E9), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        ),
        onChanged: filterGifs,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Color(0xFF2A2D3E), // Fondo oscuro
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                widget.categoryTitle,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Aquí aprenderás palabras en lengua de señas de esta categoría.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGifDisplayArea() {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: selectedGif != null
            ? Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25), // Radio aumentado
                  child: Image.network(
                    selectedGif!,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      );
                    },
                  ),
                ),
              )
            : Center(
                child: Text(
                  'Selecciona un GIF',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGifButtons() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E), // Fondo oscuro
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: filteredGifs.map((gif) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedGif == gif.archivo
                    ? Color(0xFF0EA5E9) // Azul brillante para selección
                    : Color(0xFF2A2D3E), // Fondo oscuro
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.3),
                side: BorderSide(
                  color: selectedGif == gif.archivo
                      ? Colors.white
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              onPressed: () {
                setState(() => selectedGif = gif.archivo);
                _guardarEnHistorial(context, gif.id);// Llamada al método de guardado
              },
              child: Text(
                gif.nombre,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Gif {
  final int id;
  final String nombre;
  final String archivo;
  final int categoria;

  Gif({
    required this.id,
    required this.nombre,
    required this.archivo,
    required this.categoria,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      id: json['id'],
      nombre: json['nombre'],
      archivo: json['archivo'],
      categoria: json['categoria'],
    );
  }
}
