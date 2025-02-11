import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/models/gif_model.dart';

class SimonSaysScreen extends StatefulWidget {
  @override
  _SimonSaysScreenState createState() => _SimonSaysScreenState();
}

class _SimonSaysScreenState extends State<SimonSaysScreen>
    with TickerProviderStateMixin {
  List<Gif> availableGifs = [];
  List<Gif> sequence = [];
  List<Gif> userSequence = [];
  List<Gif> currentOptions = [];
  String message = "Memoriza la secuencia";
  bool loading = true;
  int difficulty = 1; // Nivel inicial cambiado a 1
  bool showSequence = false;
  bool showStartScreen = true;
  int currentStep = 0;
  Timer? stepTimer;
  Timer? countdownTimer;
  int countdown = 15;
  late AnimationController _animationController;
  final double _memorizationGifSize = 0.6;
  final double _inputGifSize = 0.4;
  final int maxDifficulty = 5; // Dificultad máxima aumentada a 5

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    fetchGifs();
  }
  @override
  void dispose() {
    stepTimer?.cancel();
    countdownTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future fetchGifs() async {
    final baseUrl = dotenv.env['BASE_URL_DEV'];
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/gifs/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Gif> fetchedGifs = data.map((json) => Gif.fromJson(json)).toList();
        setState(() {
          availableGifs = fetchedGifs;
          generateSequence();
          loading = false;
        });
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando GIFs: $e")),
      );
    }
  }

void generateSequence() {
  if (availableGifs.isNotEmpty) {
    Random random = Random();
    Set<Gif> uniqueGifs = Set();

    // Asegurar que no se superen 6 señas
    int gifsToMemorize = difficulty + 2; // Nivel 1: 3, Nivel 2: 4, ..., Nivel 4: 6
    if (gifsToMemorize > 6) {
      gifsToMemorize = 6; // Límite máximo de 6 señas
    }

    // Generar la secuencia sin repeticiones
    while (uniqueGifs.length < gifsToMemorize) {
      Gif randomGif = availableGifs[random.nextInt(availableGifs.length)];
      uniqueGifs.add(randomGif);
    }

    sequence = uniqueGifs.toList();
    currentStep = 0;

    // Tiempo de memorización proporcional al número de señas
    countdown = gifsToMemorize * (6 + difficulty); // 7 segundos por GIF en nivel 1
  }
}

  void startStepTimer() {
    int stepDuration = 3 + difficulty; // Duración por paso basada en dificultad
    stepTimer?.cancel();
    stepTimer = Timer.periodic(Duration(seconds: stepDuration), (timer) {
      if (currentStep < sequence.length - 1) {
        setState(() => currentStep++);
      } else {
        timer.cancel();
      }
    });
  }

  void startCountdownTimer() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        timer.cancel();
        handleTimeout();
      }
    });
  }

  void handleTimeout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("¡Tiempo agotado!")),
    );
    resetGame();
  }

  List<Gif> _getRandomizedGifs() {
    Set<Gif> filteredSet = Set.from(sequence);
    Random random = Random();
    while (
        filteredSet.length < 6 && filteredSet.length < availableGifs.length) {
      filteredSet.add(availableGifs[random.nextInt(availableGifs.length)]);
    }
    List<Gif> randomizedList = filteredSet.toList()..shuffle();
    return randomizedList;
  }

  void checkSequence() {
  bool correct = sequence.length == userSequence.length;

  // Verificar si la secuencia es correcta
  for (int i = 0; i < sequence.length && correct; i++) {
    if (sequence[i].id != userSequence[i].id) {
      correct = false;
    }
  }

  if (correct) {
    // Mostrar mensaje de felicitaciones
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          difficulty < maxDifficulty
              ? "¡Nivel completado!"
              : "¡Felicidades!",
          style: TextStyle(
            color: difficulty < maxDifficulty ? Colors.green : Colors.blue,
          ),
        ),
        content: Text(
          difficulty < maxDifficulty
              ? "Nivel $difficulty completado!\nSiguiente nivel: ${difficulty + 1}"
              : "¡Has completado todos los niveles!\n¡Eres un campeón!",
        ),
        actions: [
          TextButton(
            child: Text("Continuar"),
            onPressed: () {
              Navigator.of(context).pop();
              if (difficulty < maxDifficulty) {
                // Avanzar al siguiente nivel
                setState(() => difficulty++);
                resetGame();
              } else {
                // Reiniciar al primer nivel
                setState(() => difficulty = 1);
                resetGame();
              }
            },
          ),
        ],
      ),
    );
  } else {
    // Mostrar mensaje de error si la secuencia es incorrecta
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Secuencia incorrecta. Intenta de nuevo"),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => userSequence.clear());
  }
}

  void resetGame() {
    setState(() {
      userSequence.clear();
      showStartScreen = true;
      generateSequence();
    });
  }

  Widget _buildStartScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 4, 15, 32)!, // Azul más oscuro
            const Color.fromARGB(255, 7, 27, 50)!,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¡SIGUE LAS INDICACIONES!",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 49, 111, 27),
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Text("1- Memoriza el orden de las señas que se mostrarán",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              SizedBox(height: 15),
              Text("2- Reproduce la secuencia en el mismo orden",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              SizedBox(height: 15),
              Text("3- Tienes 15 segundos para completar cada nivel",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              SizedBox(height: 15),
              Text("4- Si fallas o se agota el tiempo, el juego reiniciará",
                  style: TextStyle(color: Colors.white70, fontSize: 18)),
              SizedBox(height: 15),
              Text("Dificultad: Nivel $difficulty",
                  style: TextStyle(color: Colors.amber, fontSize: 20)),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.play_arrow, size: 30),
                label: Text("INICIAR JUEGO", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  setState(() {
                    showStartScreen = false;
                    showSequence = true;
                  });
                  startStepTimer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildMemorizationScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 3, 11, 23)!,
            const Color.fromARGB(255, 6, 27, 51)!,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tiempo restante: $countdown",
            style: TextStyle(color: Colors.amber, fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Memoriza la secuencia (${sequence.length} señas)",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Center(
            child: Column(
              children: [
                _buildGifCard(
                  sequence[currentStep],
                  isMemorization: true,
                  showName: false,
                ),
                SizedBox(height: 20),
                Text(
                  sequence[currentStep].nombre.toUpperCase(),
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.replay,
                label: "Repetir",
                color: const Color.fromARGB(255, 98, 15, 9),
                onPressed: () {
                  setState(() => currentStep = 0);
                  startStepTimer();
                },
              ),
              SizedBox(width: 20),
              _buildActionButton(
                icon: Icons.arrow_forward,
                label: "Continuar",
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    showSequence = false;
                    currentOptions = _getRandomizedGifs();
                  });
                  startCountdownTimer();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 4, 12, 25)!,
            const Color.fromARGB(255, 7, 28, 53)!,
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Tiempo restante: $countdown",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Mostrar 2 elementos por fila
                childAspectRatio: 1.0,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final gif = currentOptions[index];
                return GestureDetector(
                  onTap: () {
                    if (userSequence.length < sequence.length) {
                      setState(() => userSequence.add(gif));
                    }
                  },
                  child: _buildGifCard(gif),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.refresh,
                  label: "Reiniciar",
                  color: Colors.orange,
                  onPressed: resetGame,
                ),
                SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.check_circle,
                  label: "Verificar",
                  color: Colors.green,
                  onPressed: checkSequence,
                ),
                SizedBox(width: 20),
                _buildActionButton(
                  icon: Icons.undo,
                  label: "Deshacer",
                  color: Colors.red,
                  onPressed: userSequence.isNotEmpty
                      ? () => setState(() => userSequence.removeLast())
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGifCard(Gif gif,
      {bool isMemorization = false, bool showName = false}) {
    final size = MediaQuery.of(context).size.width *
        (isMemorization ? _memorizationGifSize : _inputGifSize);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Forma circular para todos los GIFs
        border: Border.all(
          color: userSequence.contains(gif) ? Colors.green : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipOval(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              gif.archivo,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
            if (showName)
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  gif.nombre,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32),
          color: Colors.white,
          onPressed: onPressed,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32),
          color: color,
          onPressed: onPressed,
          disabledColor: Colors.grey,
        ),
        Text(label,
            style: TextStyle(
              color: color.withOpacity(onPressed != null ? 1.0 : 0.5),
              fontSize: 12,
            )),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "SignSpeak Juegos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black54,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            TextSpan(
              text: "\nDiviértete aprendiendo",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : showStartScreen
              ? _buildStartScreen()
              : showSequence
                  ? _buildMemorizationScreen()
                  : _buildInputScreen(),
    );
  }
}
