class Chats {
  var threadId;
  var user;
  var message;

  Chats(this.threadId, this.user, this.message);
}

class Messages {
  var message;
  var senderID;
  bool isSender;

  Messages(this.message, this.senderID, this.isSender);
}