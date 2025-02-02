import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    // Agregar más categorías
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCategoryGrid(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "SignSpeak",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black12,
                    offset: Offset(1, 1),
                  )
                ],
              ),
            ),
            TextSpan(
              text: "\nAprende Lengua de Señas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[800]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 5,
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos columnas
        crossAxisSpacing: 16, // Espacio horizontal entre elementos
        mainAxisSpacing: 16, // Espacio vertical entre elementos
        childAspectRatio: 1.2, // Relación de aspecto (ancho/alto)
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(index, context);
      },
    );
  }

  Widget _buildCategoryCard(int index, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailScreen(
                categoryType: categories[index]['type'],
                categoryTitle: categories[index]['title'],
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: categories[index]['img'],
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            SizedBox(height: 10),
            Text(
              categories[index]['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
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
  List<Gif> gifs = [];
  List<Gif> filteredGifs = [];
  String? selectedGif;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGifs();
  }

  Future<void> fetchGifs() async {
    final response = await http.get(Uri.parse('http://192.168.52.56:8000/api/gifs/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        gifs = data.map((json) => Gif.fromJson(json)).toList();
        filteredGifs = gifs.where((gif) => gif.categoria == getCategoryId()).toList();
      });
    }
  }

  int getCategoryId() {
    switch (widget.categoryType.toLowerCase()) {
      case 'numeros':
        return 3;
      case 'colores':
        return 1;
      default:
        return 0;
    }
  }

  void filterGifs(String query) {
    setState(() {
      filteredGifs = gifs.where((gif) {
        final categoryMatch = gif.categoria == getCategoryId();
        final nameMatch = gif.nombre.toLowerCase().contains(query.toLowerCase());
        return categoryMatch && nameMatch;
      }).toList();
      
      if (filteredGifs.isNotEmpty) {
        selectedGif = filteredGifs.first.archivo;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
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
        decoration: InputDecoration(
          hintText: 'Buscar GIF...',
          prefixIcon: Icon(Icons.search, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        onChanged: filterGifs,
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
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
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
                    color: Colors.grey[600],
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
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
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
                    ? Colors.blue[800]
                    : Colors.blue[400],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              onPressed: () {
                setState(() {
                  selectedGif = gif.archivo;
                });
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