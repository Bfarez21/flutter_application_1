import 'package:flutter/material.dart';

// Widget del teclado de señas
class SignKeyboard extends StatelessWidget {
  final Function(String) onTextoDetectado;

  const SignKeyboard({
    Key? key,
    required this.onTextoDetectado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Ajusta esta altura según necesites
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // Campo de texto
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                'El texto aparecerá aquí...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Grid de señas
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 26, // Letras del alfabeto
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A-Z temporalmente
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ),

          // Barra de acciones
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Borrar'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onTextoDetectado('Texto ejemplo'),
                    child: Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget principal modificado
class OptionTranslate extends StatefulWidget {
  final Function(String)? onTextoDetectado;

  const OptionTranslate({
    Key? key,
    this.onTextoDetectado,
  }) : super(key: key);

  @override
  _OptionTranslateState createState() => _OptionTranslateState();
}

class _OptionTranslateState extends State<OptionTranslate> {
  bool showKeyboard = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    print("Abrir cámara");
                    setState(() {
                      showKeyboard = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Icon(Icons.camera_alt, size: 40),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showKeyboard = !showKeyboard;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: Icon(Icons.keyboard, size: 40),
                ),
              ),
            ],
          ),
        ),
        if (showKeyboard)
          SignKeyboard(
            onTextoDetectado: widget.onTextoDetectado ?? (_) {},
          ),
      ],
    );
  }
}
