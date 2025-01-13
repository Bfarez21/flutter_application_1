import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart';

class HistorialView extends StatefulWidget {
  const HistorialView({Key? key}) : super(key: key);

  @override
  State<HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<HistorialView> {
  List<TraduccionHistorial> historial = [
    TraduccionHistorial(
      textoTraducido: "Hola, ¿cómo estás?",
      descripcion: "Saludo informal y pregunta de estado",
      fecha: "12 Ene 2025 15:30",
    ),
    TraduccionHistorial(
      textoTraducido: "Buenos días",
      descripcion: "Saludo formal para la mañana",
      fecha: "12 Ene 2025 10:15",
    ),
  ];

  void eliminarTraduccion(int index) {
    setState(() {
      historial.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historial",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: HistorialSearchDelegate(historial),
              );
            },
          ),
        ],
      ),
      backgroundColor: MaterialColors.bgColorScreen,
      drawer: MaterialDrawer(currentPage: "Historial"),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  final traduccion = historial[index];
                  return Dismissible(
                    key: Key(traduccion.fecha),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      eliminarTraduccion(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Elemento eliminado'),
                          action: SnackBarAction(
                            label: 'Deshacer',
                            onPressed: () {
                              setState(() {
                                historial.insert(index, traduccion);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    traduccion.textoTraducido,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red,
                                  onPressed: () => eliminarTraduccion(index),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: MaterialColors.bgColorScreen,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                traduccion.descripcion,
                                style: TextStyle(
                                  color: MaterialColors.muted,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: MaterialColors.muted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  traduccion.fecha,
                                  style: TextStyle(
                                    color: MaterialColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistorialSearchDelegate extends SearchDelegate {
  final List<TraduccionHistorial> historial;

  HistorialSearchDelegate(this.historial);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    final results = historial.where((traduccion) =>
        traduccion.textoTraducido.toLowerCase().contains(query.toLowerCase()) ||
        traduccion.descripcion.toLowerCase().contains(query.toLowerCase()));

    return ListView(
      children: results
          .map((traduccion) => ListTile(
                title: Text(traduccion.textoTraducido),
                subtitle: Text(traduccion.descripcion),
                trailing: Text(traduccion.fecha),
              ))
          .toList(),
    );
  }
}

class TraduccionHistorial {
  final String textoTraducido;
  final String descripcion;
  final String fecha;

  TraduccionHistorial({
    required this.textoTraducido,
    required this.descripcion,
    required this.fecha,
  });
}