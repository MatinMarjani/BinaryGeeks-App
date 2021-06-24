import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:application/pages/widgets/myMessageCard.dart';
import 'package:application/util/Chats.dart';
import 'package:application/util/Utilities.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  NavigatorObserver mockObserver;

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  testWidgets("MessageCard() setup", (WidgetTester tester) async {
    var myUser;
    var myMessage;
    var message;

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

    message = {
      "id": 8,
      "message": "AAAAAAAAAAAAAA",
      "is_read": false,
      "created_at": "2021-05-21T20:35:15.988303Z",
      "reply_of": null,
      "thread": 1,
      "sender": 2
    };

    Chats myChat = Chats(0, myUser, myMessage);

    Messages test = Messages(message, 2, false);

    await tester.pumpWidget(
      MaterialApp(
        home: MessageCard(test, myChat, 0, 1),
      ),
    );
    await tester.pump();

    expect(find.byType(Padding), findsWidgets);
    expect(find.byType(TextMessage), findsWidgets);
  });

  testWidgets("TextMessage() isSender == false", (WidgetTester tester) async {
    var message;

    message = {
      "id": 8,
      "message": "AAAAAAAAAAAAAA",
      "is_read": false,
      "created_at": "2021-05-21T20:35:15.988303Z",
      "reply_of": null,
      "thread": 1,
      "sender": 2
    };

    Messages test = Messages(message, 2, false);

    await tester.pumpWidget(
      MaterialApp(
        home: TextMessage(test),
      ),
    );
    await tester.pump();

    expect(find.byType(Container), findsWidgets);
    final cardColor = tester.firstWidget(find.byType(Text)) as Text;
    expect((cardColor.style).color, Utilities().mainColor);
  });

  testWidgets("TextMessage() isSender == true", (WidgetTester tester) async {
    var message;

    message = {
      "id": 8,
      "message": "AAAAAAAAAAAAAA",
      "is_read": false,
      "created_at": "2021-05-21T20:35:15.988303Z",
      "reply_of": null,
      "thread": 1,
      "sender": 2
    };

    Messages test = Messages(message, 2, true);

    await tester.pumpWidget(
      MaterialApp(
        home: TextMessage(test),
      ),
    );
    await tester.pump();

    expect(find.byType(Container), findsWidgets);
    final cardColor = tester.firstWidget(find.byType(Text)) as Text;
    expect((cardColor.style).color, Colors.white);
  });
}
