import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart'; // Importa el archivo principal de tu app

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialKitPROFlutter()); // Usamos el widget MaterialKitPROFlutter

    // Verifica que el contador comienza en 0 (esto depende de la implementación en la pantalla que estás probando).
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toca el ícono '+' y actualiza la vista.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador se haya incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
