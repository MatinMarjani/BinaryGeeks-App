import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:application/util/Utilities.dart';
import 'package:application/util/User.dart';

//ignore: must_be_immutable
class BidCard extends StatelessWidget {
  final Color mainColor = Utilities().mainColor;
  final String myFont = Utilities().myFont;

  dynamic acceptBid;
  dynamic deleteBid;

  int bidID;
  int bidOwner;
  String userName;
  String email;
  String firstName;
  String lastName;
  String profileImage;

  String offeredPrice;
  String description;
  bool isAccepted;

  bool isPostOwner;
  bool isBidOwner = false;
  bool isExchange = false;

  BidCard(
      this.bidID,
      this.bidOwner,
      this.userName,
      this.email,
      this.firstName,
      this.lastName,
      this.profileImage,
      this.offeredPrice,
      this.description,
      this.isAccepted,
      this.isPostOwner,
      this.isExchange,
      this.deleteBid,
      this.acceptBid);

  @override
  Widget build(BuildContext context) {
    bool _noImage;
    var formatter = new NumberFormat('###,###');
    String price = Utilities().replaceFarsiNumber(formatter.format(int.parse(offeredPrice)));

    log(User.id);
    log(bidOwner.toString());

    if (User.id == bidOwner.toString())
      isBidOwner = true;
    else
      isBidOwner = false;

    if (profileImage == null)
      _noImage = true;
    else {
      _noImage = false;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            // Display the image in large form.
            print("Comment Clicked");
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: new BoxDecoration(color: Colors.blue, borderRadius: new BorderRadius.all(Radius.circular(50))),
            child: !_noImage
                ? CircleAvatar(radius: 50, backgroundImage: NetworkImage('http://37.152.176.11' + profileImage))
                : CircleAvatar(radius: 50),
          ),
        ),
        title: Text(
          firstName + " " + lastName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Column(
          children: <Widget>[
            Text(
              price + " تومان",
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 1),
            isPostOwner
                ? Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.green))),
                      ),
                      child: Icon(
                        Icons.check_outlined,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        acceptBid(bidID);
                      },
                    ),
                  )
                : SizedBox(height: 0),
            isBidOwner
                ? Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.red))),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteBid(bidID);
                        }),
                  )
                : SizedBox(height: 0),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
