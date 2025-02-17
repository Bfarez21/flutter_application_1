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
  String _lettersText = '';
  List<String> _signImages = [];

  final List<List<Map<String, String>>> keyboardLayout = [
    [
      {'letter': '1', 'sign': 'assets/keyboard-icon/1.png'},
      {'letter': '2', 'sign': 'assets/keyboard-icon/2.png'},
      {'letter': '3', 'sign': 'assets/keyboard-icon/3.png'},
      {'letter': '4', 'sign': 'assets/keyboard-icon/4.png'},
      {'letter': '5', 'sign': 'assets/keyboard-icon/5.png'},
      {'letter': '6', 'sign': 'assets/keyboard-icon/6.png'},
      {'letter': '7', 'sign': 'assets/keyboard-icon/7.png'},
      {'letter': '8', 'sign': 'assets/keyboard-icon/8.png'},
      {'letter': '9', 'sign': 'assets/keyboard-icon/9.png'},
      {'letter': '0', 'sign': 'assets/keyboard-icon/0.png'},
    ],
    [
      {'letter': 'Q', 'sign': 'assets/keyboard-icon/q.png'},
      {'letter': 'W', 'sign': 'assets/keyboard-icon/w.png'},
      {'letter': 'E', 'sign': 'assets/keyboard-icon/e.png'},
      {'letter': 'R', 'sign': 'assets/keyboard-icon/r.png'},
      {'letter': 'T', 'sign': 'assets/keyboard-icon/t.png'},
      {'letter': 'Y', 'sign': 'assets/keyboard-icon/y.png'},
      {'letter': 'U', 'sign': 'assets/keyboard-icon/u.png'},
      {'letter': 'I', 'sign': 'assets/keyboard-icon/i.png'},
      {'letter': 'O', 'sign': 'assets/keyboard-icon/o.png'},
      {'letter': 'P', 'sign': 'assets/keyboard-icon/p.png'},
    ],
    [
      {'letter': 'A', 'sign': 'assets/keyboard-icon/a.png'},
      {'letter': 'S', 'sign': 'assets/keyboard-icon/s.png'},
      {'letter': 'D', 'sign': 'assets/keyboard-icon/d.png'},
      {'letter': 'F', 'sign': 'assets/keyboard-icon/f.png'},
      {'letter': 'G', 'sign': 'assets/keyboard-icon/g.png'},
      {'letter': 'H', 'sign': 'assets/keyboard-icon/h.png'},
      {'letter': 'J', 'sign': 'assets/keyboard-icon/j.png'},
      {'letter': 'K', 'sign': 'assets/keyboard-icon/k.png'},
      {'letter': 'L', 'sign': 'assets/keyboard-icon/l.png'},
      {'letter': 'Ñ', 'sign': 'assets/keyboard-icon/enie.png'},
    ],
    [
      {'letter': 'Z', 'sign': 'assets/keyboard-icon/z.png'},
      {'letter': 'X', 'sign': 'assets/keyboard-icon/x.png'},
      {'letter': 'C', 'sign': 'assets/keyboard-icon/c.png'},
      {'letter': 'V', 'sign': 'assets/keyboard-icon/v.png'},
      {'letter': 'B', 'sign': 'assets/keyboard-icon/b.png'},
      {'letter': 'N', 'sign': 'assets/keyboard-icon/n.png'},
      {'letter': 'M', 'sign': 'assets/keyboard-icon/m.png'},
    ],
  ];

  Map<String, String> _letterToSign = {};

  @override
  void initState() {
    super.initState();
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

  void _insertLetter(String letter) {
    // Actualizar el texto en letras
    _lettersText += letter;

    // Actualizar el controlador de texto
    _controller.text = _lettersText;

    // Actualizar la lista de imágenes de señas
    if (letter != " " && letter != "\n") {
      String? signPath = _letterToSign[letter.toUpperCase()];
      if (signPath != null && signPath.isNotEmpty) {
        _signImages.add(signPath);
      }
    }

    setState(() {}); // Actualizar el estado

    // Notificar al padre
    widget.onTextoDetectado(_lettersText);
  }

  void _handleBackspace() {
    if (_lettersText.isEmpty) return;

    // Eliminar el último carácter del texto
    _lettersText = _lettersText.substring(0, _lettersText.length - 1);
    _controller.text = _lettersText;

    // Eliminar la última imagen si existe
    if (_signImages.isNotEmpty) {
      _signImages.removeLast();
    }

    setState(() {}); // Actualizar el estado

    // Notificar al padre
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
                        child: Image.asset(
                          key['sign']!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showKeyboard(context),
              child: Container(
                constraints: BoxConstraints(minHeight: 120),
                width: double.infinity,
                child: Stack(
                  children: [
                    if (_signImages.isEmpty)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Text(
                          'Escribe aquí...',
                          style: TextStyle(
                            color: Color.fromRGBO(155, 163, 209, 1),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Imágenes de señas
                          if (_signImages.isNotEmpty)
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: _signImages
                                  .map((imagePath) => Image.asset(
                                        imagePath,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.contain,
                                      ))
                                  .toList(),
                            ),
                          // TextField oculto para mantener el texto
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.transparent,
                              height: 0,
                            ),
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
