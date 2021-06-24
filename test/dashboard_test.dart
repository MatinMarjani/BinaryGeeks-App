import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:application/pages/dashboard.dart';
import 'package:application/util/Post.dart';


void main() {
  testWidgets("Dashboard()", (WidgetTester tester) async {
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
      home: DashBoard(),
    ),);

    await tester.pump();
  });
}