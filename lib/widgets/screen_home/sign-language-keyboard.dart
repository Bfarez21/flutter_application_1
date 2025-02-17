import 'package:flutter/material.dart';

class SignLanguageInput extends StatefulWidget {
  final Function(String) onTextoDetectado;
  final VoidCallback toggleLayout;

  SignLanguageInput({
    required this.onTextoDetectado,
    required this.toggleLayout,
  });

  @override
  _SignLanguageInputState createState() => _SignLanguageInputState();
}

class _SignLanguageInputState extends State<SignLanguageInput> {
  final TextEditingController _controller = TextEditingController();
  String _lettersText = ''; // Para mantener el texto en letras

  final List<List<Map<String, String>>> keyboardLayout = [
    [
      {'letter': '1', 'sign': '1️⃣'},
      {'letter': '2', 'sign': '2️⃣'},
      {'letter': '3', 'sign': '3️⃣'},
      {'letter': '4', 'sign': '4️⃣'},
      {'letter': '5', 'sign': '5️⃣'},
      {'letter': '6', 'sign': '6️⃣'},
      {'letter': '7', 'sign': '7️⃣'},
      {'letter': '8', 'sign': '8️⃣'},
      {'letter': '9', 'sign': '9️⃣'},
      {'letter': '0', 'sign': '0️⃣'},
    ],
    [
      {'letter': 'Q', 'sign': '✌️'},
      {'letter': 'W', 'sign': '👐'},
      {'letter': 'E', 'sign': '🤟'},
      {'letter': 'R', 'sign': '🤘'},
      {'letter': 'T', 'sign': '👆'},
      {'letter': 'Y', 'sign': '👌'},
      {'letter': 'U', 'sign': '🤙'},
      {'letter': 'I', 'sign': '👍'},
      {'letter': 'O', 'sign': '✊'},
      {'letter': 'P', 'sign': '🤞'},
    ],
    [
      {'letter': 'A', 'sign': '👋'},
      {'letter': 'S', 'sign': '🖐️'},
      {'letter': 'D', 'sign': '✋'},
      {'letter': 'F', 'sign': '👊'},
      {'letter': 'G', 'sign': '🤚'},
      {'letter': 'H', 'sign': '🖖'},
      {'letter': 'J', 'sign': '👇'},
      {'letter': 'K', 'sign': '👉'},
      {'letter': 'L', 'sign': '👈'},
      {'letter': 'Ñ', 'sign': '🤝'},
    ],
    [
      {'letter': 'Z', 'sign': '💪'},
      {'letter': 'X', 'sign': '🙌'},
      {'letter': 'C', 'sign': '👏'},
      {'letter': 'V', 'sign': '🤲'},
      {'letter': 'B', 'sign': '✍️'},
      {'letter': 'N', 'sign': '👎'},
      {'letter': 'M', 'sign': '🤜'},
    ],
  ];

  // Mapa para convertir letras a signos
  Map<String, String> _letterToSign = {};

  @override
  void initState() {
    super.initState();
    // Inicializar el mapa de conversión
    for (var row in keyboardLayout) {
      for (var key in row) {
        _letterToSign[key['letter']!] = key['sign']!;
      }
    }
  }

  void _showKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1D1D1D),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: 265,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                ...keyboardLayout.map(_buildKeyboardRow),
                _buildBottomRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _convertTextToSigns(String text) {
    String result = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i].toUpperCase();
      if (_letterToSign.containsKey(char)) {
        result += _letterToSign[char]!;
      } else if (char == ' ') {
        result += ' ';
      } else if (char == '\n') {
        result += '\n';
      }
    }
    return result;
  }

  void _insertLetter(String letter) {
    final selection = _controller.selection;

    // Actualizar el texto en letras
    _lettersText = _lettersText.replaceRange(
      selection.start,
      selection.end,
      letter,
    );

    // Convertir a signos
    final signsText = _convertTextToSigns(_lettersText);

    // Actualizar el controlador con los signos
    _controller.value = TextEditingValue(
      text: signsText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + letter.length,
      ),
    );

    // Enviar el texto en letras al padre
    widget.onTextoDetectado(_lettersText);
  }

  void _handleBackspace() {
    if (_lettersText.isEmpty) return;

    final selection = _controller.selection;
    if (selection.baseOffset == 0) return;

    // Eliminar el último carácter del texto en letras
    _lettersText = _lettersText.substring(0, _lettersText.length - 1);

    // Convertir a signos
    final signsText = _convertTextToSigns(_lettersText);

    // Actualizar el controlador con los signos
    _controller.value = TextEditingValue(
      text: signsText,
      selection: TextSelection.collapsed(
        offset: signsText.length,
      ),
    );

    // Enviar el texto actualizado al padre
    widget.onTextoDetectado(_lettersText);
  }

  Widget _buildKeyboardRow(List<Map<String, String>> row) {
    double spacing = 6.0;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: spacing),
          ...row.map((key) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                child: Material(
                  color: const Color(0xFF363636),
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () => _insertLetter(key['letter']!),
                    child: Container(
                      height: 42,
                      child: Center(
                        child: Text(
                          key['sign']!,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          SizedBox(width: spacing),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      child: Row(
        children: [
          _buildSpecialKey('!#1', flex: 2),
          SizedBox(width: 6),
          _buildSpecialKey(',', flex: 1),
          SizedBox(width: 6),
          Expanded(
            flex: 5,
            child: Material(
              color: const Color(0xFF363636),
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                onTap: () => _insertLetter(" "),
                child: Container(
                  height: 42,
                  child: Center(
                    child: Text(
                      "espacio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          _buildSpecialKey('⌫', flex: 2, onTap: _handleBackspace),
          SizedBox(width: 6),
          _buildSpecialKey('↵', flex: 2, onTap: () {
            Navigator.pop(context);
            _insertLetter("\n");
          }),
        ],
      ),
    );
  }

  Widget _buildSpecialKey(String text, {int flex = 1, VoidCallback? onTap}) {
    return Expanded(
      flex: flex,
      child: Material(
        color: const Color(0xFF363636),
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onTap ?? () => _insertLetter(text),
          child: Container(
            height: 42,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 244, 246),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Escribe aquí...',
              hintStyle: TextStyle(
                color: Color.fromRGBO(155, 163, 209, 1),
              ),
            ),
            style: TextStyle(
              color: Color.fromRGBO(12, 12, 12, 1),
            ),
            maxLines: 3,
            showCursor: true,
            readOnly: true,
            onTap: () => _showKeyboard(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.grey),
                onPressed: widget.toggleLayout,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
