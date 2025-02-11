import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/models/gif_model.dart';
import 'dart:async';

class UnlockGameScreen extends StatefulWidget {
  @override
  _UnlockGameScreenState createState() => _UnlockGameScreenState();
}

class _UnlockGameScreenState extends State<UnlockGameScreen>
    with SingleTickerProviderStateMixin {
  List<Gif> availableGifs = [];
  List<Gif> gameCards = [];
  List<bool> cardStates = [];
  List<bool> matched = [];
  String message = "Encuentra las parejas";
  bool loading = true;
  int pairs = 3;
  int score = 0;
  Timer? timer;
  int timeLeft = 30;
  int playerPosition = 0;

  // Controladores para animaciones
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    fetchGifs();

    // Configurar animaciones
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchGifs() async {
    final baseUrl = dotenv.env['BASE_URL_DEV'];
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/gifs/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        List<Gif> fetchedGifs = data.map((json) => Gif.fromJson(json)).toList();
        setState(() {
          availableGifs = fetchedGifs;
          _setupGame();
          loading = false;
        });
      } else {
        throw Exception("Error al cargar los GIFs");
      }
    } catch (e) {
      setState(() {
        loading = false;
        message = "Error al cargar los GIFs. Inténtalo de nuevo.";
      });
    }
  }

  void _setupGame() {
    if (availableGifs.isNotEmpty && availableGifs.length >= pairs) {
      Random random = Random();
      List<Gif> selected = [];
      while (selected.length < pairs) {
        Gif candidate = availableGifs[random.nextInt(availableGifs.length)];
        if (!selected.any((gif) => gif.id == candidate.id)) {
          selected.add(candidate);
        }
      }
      gameCards = [...selected, ...selected];
      gameCards.shuffle(random);
      cardStates = List<bool>.filled(gameCards.length, false);
      matched = List<bool>.filled(gameCards.length, false);
      message = "Encuentra las parejas";
      score = 0;
      timeLeft = 30;
      _startTimer();
    } else {
      setState(() {
        message = "No hay suficientes GIFs disponibles para jugar.";
      });
    }
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        timer.cancel();
        _endGame();
      }
    });
  }

  void revealCard(int index) async {
    if (!matched[index] &&
        !cardStates[index] &&
        cardStates.where((state) => state).length < 2) {
      // Iniciar animación de giro
      await _animationController.forward();
      _animationController.reset();

      setState(() {
        cardStates[index] = true;
      });
      checkForMatch();
    }
  }

  void checkForMatch() async {
    List<int> revealedIndices = [];
    for (int i = 0; i < cardStates.length; i++) {
      if (cardStates[i] && !matched[i]) revealedIndices.add(i);
    }

    if (revealedIndices.length == 2) {
      if (gameCards[revealedIndices[0]].id ==
          gameCards[revealedIndices[1]].id) {
        // Animación de éxito
        _playSuccessAnimation();

        setState(() {
          score += timeLeft;
          message = "¡Pareja encontrada!";
          matched[revealedIndices[0]] = true;
          matched[revealedIndices[1]] = true;
          // Resetear estados para permitir nuevas selecciones
          cardStates[revealedIndices[0]] = false;
          cardStates[revealedIndices[1]] = false;
        });

        if (matched.every((state) => state)) {
          _endGameWithWin();
        }
      } else {
        // Animación de error
        _playErrorAnimation(revealedIndices);

        setState(() => message = "No coinciden. Inténtalo de nuevo.");
        await Future.delayed(Duration(milliseconds: 800));
        setState(() {
          cardStates[revealedIndices[0]] = false;
          cardStates[revealedIndices[1]] = false;
          message = "Encuentra las parejas";
        });
      }
    }
  }

  void _playSuccessAnimation() {
    // Animación de escala para parejas encontradas
    for (int i = 0; i < matched.length; i++) {
      if (matched[i]) {
        _animationController
            .forward()
            .then((_) => _animationController.reverse());
      }
    }
  }

  void _playErrorAnimation(List<int> indices) {
    // Animación de vibración para errores
    _animationController.repeat(
        reverse: true, period: Duration(milliseconds: 100));
    Future.delayed(
        Duration(milliseconds: 300), () => _animationController.stop());
  }

  void _endGameWithWin() {
    timer?.cancel();
    playerPosition = calculatePlayerPosition(score);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Text(
                  "¡Felicidades!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Text(
                  "Tu puntaje: $score",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              RotationTransition(
                turns: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Text(
                  "Quedaste en el puesto: $playerPosition",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.amberAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Jugar de nuevo",
              style: TextStyle(
                fontSize: 16,
                color: Colors.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    ).then((_) {
      // Reiniciar el juego automáticamente cuando el diálogo se cierra
      _setupGame();
    });
  }

  void _endGame() {
    timer?.cancel();
    playerPosition = calculatePlayerPosition(score);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Fin del juego",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Text(
                "Se acabó el tiempo. Intenta de nuevo.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: Text(
                "Tu puntaje: $score",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Text(
                "Quedaste en el puesto: $playerPosition",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amberAccent,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _setupGame();
            },
            child: Text(
              "Jugar de nuevo",
              style: TextStyle(
                fontSize: 16,
                color: Colors.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    ).then((_) {
      _animationController.forward(); // Iniciar animación al mostrar el diálogo
    });
  }

  int calculatePlayerPosition(int score) {
    // Lógica de ejemplo para posición
    return Random().nextInt(10) + 1;
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
    double cardSize = MediaQuery.of(context).size.width * 0.4;
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.cyan)))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Tiempo: $timeLeft segundos",
                          style:
                              TextStyle(fontSize: 20, color: Colors.cyanAccent),
                        ),
                        SizedBox(height: 10),
                        Text(
                          message,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: gameCards.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => revealCard(index),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return Rotation3DTransition(
                                animation: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildCard(index, cardSize),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Puntaje: $score",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          "Puesto: $playerPosition",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCard(int index, double size) {
    final isRevealed = cardStates[index] || matched[index];
    return Container(
      key: ValueKey<bool>(isRevealed),
      decoration: BoxDecoration(
        color: isRevealed ? Colors.white : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isRevealed
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  gameCards[index].archivo,
                  width: size * 0.8,
                  height: size * 0.8,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 4),
                Text(
                  gameCards[index].nombre,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Center(
              child: Icon(Icons.question_mark, size: 40, color: Colors.white),
            ),
    );
  }
}

// Animación personalizada para efecto 3D
class Rotation3DTransition extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  Rotation3DTransition({
    required this.animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final angle = animation.value * pi;
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle)
        // Aplicar escalado inverso en X cuando el ángulo supera 90 grados (mitad de la animación)
        ..scale(angle > pi / 2 ? -1.0 : 1.0, 1.0),
      alignment: Alignment.center,
      child: child,
    );
  }
}
