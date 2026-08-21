// Testes de widget do app da aula.
//
// O teste que vinha do `flutter create` era o do contador e falhava neste
// projeto, porque a MyApp abre a SplashScreen e não existe nenhum botão "+".

import 'package:aplicacao_aula/view/produtos_page.dart';
import 'package:aplicacao_aula/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a splash exibe o nome do app', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.text('Meu App'), findsOneWidget);

    // Troca a árvore para descartar a SplashScreen: o dispose dela cancela o
    // Timer de 2 segundos. Sem isso o teste falha com "Timer pendente".
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('cadastra um produto pelo diálogo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProdutosPage()));

    expect(find.text('Nenhum produto cadastrado.'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Teclado');
    await tester.enterText(find.byType(TextField).at(1), 'ABNT2');
    await tester.enterText(find.byType(TextField).at(2), '150');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum produto cadastrado.'), findsNothing);
    expect(find.textContaining('Teclado'), findsOneWidget);
    expect(find.text('Preço: R\$ 150.00'), findsOneWidget);
  });

  testWidgets('remove o produto cadastrado', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProdutosPage()));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Mouse');
    await tester.enterText(find.byType(TextField).at(1), 'sem fio');
    await tester.enterText(find.byType(TextField).at(2), '99.90');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum produto cadastrado.'), findsOneWidget);
  });
}
