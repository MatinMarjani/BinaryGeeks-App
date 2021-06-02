import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:application/pages/widgets/myPostCard.dart';
import 'package:application/util/Post.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {
  NavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets("PostCard()", (WidgetTester tester) async {
    Post post = Post(
      0,
      "email",
      null,
      0,
      "tile",
      "author",
      "publisher",
      0,
      "province",
      "city",
      "zone",
      "مبادله",
      "description",
      true,
      null,
      "categories",
      "createdAt",
      "exchangeAuthor",
      "exchangeTitle",
      "exchangePublisher",
    );
    await tester.pumpWidget(MaterialApp(
      home: PostCard(post),
    ),);
    await tester.pump();
  });

  testWidgets("PostCard page with مبادله", (WidgetTester tester) async {
    Post post = Post(
      0,
      "email",
      null,
      0,
      "tile",
      "author",
      "publisher",
      0,
      "province",
      "city",
      "zone",
      "مبادله",
      "description",
      true,
      null,
      "categories",
      "createdAt",
      "exchangeAuthor",
      "exchangeTitle",
      "exchangePublisher",
    );
    await tester.pumpWidget(MaterialApp(
      home: PostCard(post),
    ),);

    await tester.pump();

    expect(find.byType(GestureDetector), findsWidgets);
    expect(find.text("email"), findsNothing);
    expect(find.text("tile"), findsOneWidget);
    expect(find.text("author"), findsOneWidget);
    expect(find.text("publisher"), findsNothing);
    expect(find.text("مبادله"), findsOneWidget);

    expect(find.byKey(ValueKey("_cardTap")), findsOneWidget);
    expect(find.byKey(ValueKey("_title")), findsOneWidget);
    expect(find.byKey(ValueKey('_author')), findsOneWidget);
    expect(find.byKey(ValueKey('_categories')), findsOneWidget);
    expect(find.byKey(ValueKey('_province')), findsOneWidget);

    expect(find.byKey(ValueKey('_price')), findsNothing);
    expect(find.byKey(ValueKey('_currency')), findsNothing);

  });

  testWidgets("PostCard page without مبادله", (WidgetTester tester) async {
    Post post = Post(
      0,
      "email",
      null,
      0,
      "tile",
      "author",
      "publisher",
      0,
      "province",
      "city",
      "zone",
      "anythingElse",
      "description",
      true,
      null,
      "categories",
      "createdAt",
      "exchangeAuthor",
      "exchangeTitle",
      "exchangePublisher",
    );
    await tester.pumpWidget(MaterialApp(
      home: PostCard(post),
    ),);

    await tester.pump();

    expect(find.byType(GestureDetector), findsWidgets);
    expect(find.text("email"), findsNothing);
    expect(find.text("tile"), findsOneWidget);
    expect(find.text("author"), findsOneWidget);
    expect(find.text("publisher"), findsNothing);
    expect(find.text("مبادله"), findsNothing);

    expect(find.byKey(ValueKey("_cardTap")), findsOneWidget);
    expect(find.byKey(ValueKey("_title")), findsOneWidget);
    expect(find.byKey(ValueKey('_author')), findsOneWidget);
    expect(find.byKey(ValueKey('_categories')), findsOneWidget);
    expect(find.byKey(ValueKey('_province')), findsOneWidget);

    expect(find.byKey(ValueKey('_price')), findsOneWidget);
    expect(find.byKey(ValueKey('_currency')), findsOneWidget);

  });
}