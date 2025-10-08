import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:b4sketball_app/login_screen.dart';

void main() {
  testWidgets('LoginScreen mostra o campo de licença', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verifica se o texto "Número de Licença" aparece
    expect(find.text('Número de Licença'), findsOneWidget);

    // Verifica se existe pelo menos 1 campo de texto
    expect(find.byType(TextField), findsWidgets);
  });
}
