import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/Archivo api_service.dart';
import 'package:flutter_application_1/models/historial_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter_application_1/constants/Theme.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart'; // Asegúrate de tener este import

class HistorialView extends StatefulWidget {
  const HistorialView({Key? key}) : super(key: key);

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  late Future<List<Historial>> _historialFuture;
  List<Historial> _historial = [];
  List<Historial> _filteredHistorial = [];
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _primaryColor = const Color(0xFF1A237E);
  final Color _accentColor = const Color(0xFF534BAE);

  @override
  void initState() {
    super.initState();
    _loadHistorial();
  }

  void _loadHistorial() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _historialFuture = ApiService.getHistorial(userId);
    _historialFuture.then((historial) {
      setState(() {
        _historial = historial;
        _filteredHistorial = historial;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando historial: $error')),
      );
    });
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString).toLocal();
      return DateFormat('dd MMM yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _filterHistorial(String query) {
    setState(() {
      _filteredHistorial = _historial
          .where((h) =>
              utf8
                  .decode(h.gifNombre.runes.toList())
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              utf8
                  .decode(h.categoriaNombre.runes.toList())
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showGifDialog(BuildContext context, String gifUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Vista de la seña',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    gifUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(color: _primaryColor),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Error al cargar el GIF',
                              style: TextStyle(color: _primaryColor),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cerrar',
                  style: TextStyle(color: _primaryColor, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteHistorial(int historialId, int index) async {
    try {
      await ApiService.deleteHistorial(historialId);
      setState(() {
        _historial.removeAt(index);
        _filteredHistorial = List.from(_historial);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro eliminado'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Historial",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(DateTime.now()),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: _primaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => showSearch(
              context: context,
              delegate: HistorialSearchDelegate(
                _filteredHistorial,
                context,
                _deleteHistorial,
                _primaryColor,
                _accentColor,
              ),
            ),
          ),
        ],
      ),
      // ESTA ES LA PARTE CRÍTICA QUE FALTABA
      drawer: MaterialDrawer(currentPage: "Historial"),
      backgroundColor: _backgroundColor,
      body: FutureBuilder<List<Historial>>(
        future: _historialFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: _primaryColor));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar el historial',
                style: TextStyle(color: _primaryColor, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No hay registros en el historial',
                style: TextStyle(color: _primaryColor, fontSize: 16),
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHistorial.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final historial = _filteredHistorial[index];
                return Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _formatDate(historial.fechaHora),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.visibility,
                                        color: _accentColor, size: 22),
                                    onPressed: () => _showGifDialog(
                                        context, historial.gifUrl),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent, size: 22),
                                    onPressed: () => _confirmDelete(
                                        context, historial.id, index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            utf8.decode(historial.gifNombre.runes.toList()),
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Categoría: ${utf8.decode(historial.categoriaNombre.runes.toList())}',
                            style: TextStyle(
                              color: _accentColor,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int historialId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Estás seguro de eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteHistorial(historialId, index);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class HistorialSearchDelegate extends SearchDelegate {
  final List<Historial> historial;
  final BuildContext parentContext;
  final Function(int, int) onDeleteHistorial;
  final Color primaryColor;
  final Color accentColor;

  HistorialSearchDelegate(
    this.historial,
    this.parentContext,
    this.onDeleteHistorial,
    this.primaryColor,
    this.accentColor,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildResults(context);

  Widget _buildResults(BuildContext context) {
    final results = historial
        .where((h) =>
            utf8
                .decode(h.gifNombre.runes.toList())
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            utf8
                .decode(h.categoriaNombre.runes.toList())
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    return Container(
      color: Colors.grey.shade50,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final historial = results[index];
          return Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _formatDate(historial.fechaHora),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility,
                                  color: accentColor, size: 22),
                              onPressed: () =>
                                  _showGifDialog(context, historial.gifUrl),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent, size: 22),
                              onPressed: () =>
                                  _confirmDelete(context, historial.id, index),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      utf8.decode(historial.gifNombre.runes
                          .toList()), // Manejo de tildes
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Categoría: ${utf8.decode(historial.categoriaNombre.runes.toList())}', // Manejo de tildes
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _confirmDelete(BuildContext context, int historialId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Estás seguro de eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDeleteHistorial(historialId, index);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showGifDialog(BuildContext context, String gifUrl) {
    print("URL del GIF: $gifUrl");
    print("Intentando cargar GIF desde: $gifUrl"); // Depuración
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Vista de seña',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    gifUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue[900],
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Error al cargar el GIF',
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
