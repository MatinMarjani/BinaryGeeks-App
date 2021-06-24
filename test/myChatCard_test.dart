import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:application/pages/widgets/myChatCard.dart';
import 'package:application/util/Chats.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  NavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets("ChatCard() is Read == true", (WidgetTester tester) async {
    var myUser;
    var myMessage;

    myUser = {
      "id": 3,
      "username": "k1@gmail.com",
      "email": "k1@gmail.com",
      "first_name": "masih",
      "last_name": "bahmani",
      "phone_number": 166156534,
      "profile_image": null,
      "university": "iust",
      "field_of_study": "CE",
      "entry_year": 97
    };

    myMessage = {
      "id": 11,
      "message": "khobi?",
      "is_read": true,
      "created_at": "2021-05-21T21:04:51.075192Z",
      "reply_of": null,
      "thread": 0,
      "sender": 2
    };

    Chats myChat = Chats(0, myUser, myMessage);

    await tester.pumpWidget(
      MaterialApp(
        home: ChatCard(myChat),
      ),
    );
    await tester.pump();

    expect(find.byType(Material), findsWidgets);
    expect(find.byType(InkWell), findsWidgets);
    expect(find.byType(Padding), findsWidgets);
    final background = tester.firstWidget(find.byType(Material)) as Material;
    expect(background.color, Colors.white);

  });

  testWidgets("ChatCard() is Read == false", (WidgetTester tester) async {
    var myUser;
    var myMessage;

    myUser = {
      "id": 2,
      "username": "k1@gmail.com",
      "email": "k1@gmail.com",
      "first_name": "masih",
      "last_name": "bahmani",
      "phone_number": 166156534,
      "profile_image": null,
      "university": "iust",
      "field_of_study": "CE",
      "entry_year": 97
    };

    myMessage = {
      "id": 11,
      "message": "khobi?",
      "is_read": false,
      "created_at": "2021-05-21T21:04:51.075192Z",
      "reply_of": null,
      "thread": 0,
      "sender": 2
    };

    Chats myChat = Chats(0, myUser, myMessage);

    await tester.pumpWidget(
      MaterialApp(
        home: ChatCard(myChat),
      ),
    );
    await tester.pump();

    expect(find.byType(Material), findsWidgets);
    expect(find.byType(InkWell), findsWidgets);
    expect(find.byType(Padding), findsWidgets);
    final background = tester.firstWidget(find.byType(Material)) as Material;
    expect(background.color, Colors.redAccent[100]);

  });
}
