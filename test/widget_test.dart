// Testes de widget do app da aula.
//
// O teste que vinha do `flutter create` era o do contador e falhava neste
// projeto, porque a MyApp abre a SplashScreen e não existe nenhum botão "+".

import 'package:aplicacao_aula/view/produtos_page.dart';
import 'package:aplicacao_aula/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a splash anima o logotipo', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.text('Meu App'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Busca por Key: o proprio MaterialApp cria FadeTransition na transicao
    // de rota, entao byType encontraria mais de um widget.
    double opacidade() => tester
        .widget<FadeTransition>(find.byKey(const Key('splash-fade')))
        .opacity
        .value;
    double escala() => tester
        .widget<ScaleTransition>(find.byKey(const Key('splash-escala')))
        .scale
        .value;

    // No primeiro quadro a animacao ainda nao avancou.
    expect(opacidade(), 0.0);
    expect(escala(), lessThan(1.0));

    // Meio segundo depois o logo ja apareceu e cresceu.
    await tester.pump(const Duration(milliseconds: 500));
    expect(opacidade(), greaterThan(0.0));
    expect(escala(), greaterThan(0.75));

    // Troca a árvore para descartar a SplashScreen: o dispose dela cancela o
    // Timer e o AnimationController. Sem isso o teste falha com
    // "Timer pendente" / "AnimationController não liberado".
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
