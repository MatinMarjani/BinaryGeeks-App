import 'package:application/util/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:application/pages/widgets/myNotifCard.dart';
import 'package:application/pages/dashboard.dart';
import 'package:application/pages/BookMark.dart';
import 'package:application/pages/searchPage.dart';
import 'package:application/pages/widgets/myPostCard.dart';
import 'package:application/pages/widgets/myBidCard.dart';
import 'package:application/util/Post.dart';


void main() {
  testWidgets("Dashboard()", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DashBoard(),
    ),);

    await tester.pump();
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

  testWidgets("SearchPage()", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SearchPage(),
    ),);
    await tester.pump();
  });

  testWidgets("BookMarks()", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BookMarks(),
    ),);
    await tester.pump();
  });

  // testWidgets("BidCard()", (WidgetTester tester) async {
  //   dynamic acceptBid;
  //   dynamic deleteBid;
  //
  //   // await tester.pumpWidget(MaterialApp(
  //   //   home: BidCard(0,0,"username","email","first","last",null,"0","description",false,false,false,deleteBid,acceptBid),
  //   // ),);
  //
  //   List<Widget> myNotifications = [];
  //
  //   myNotifications.add(BidCard(0,0,"username","email","first","last",null,"0","description",false,false,false,deleteBid,acceptBid),);
  //   myNotifications.add(BidCard(0,0,"username","email","first","last",null,"0","description",false,false,false,deleteBid,acceptBid),);
  //
  //   await tester.pumpWidget(Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: myNotifications),);
  //   await tester.pump();
  // });


}