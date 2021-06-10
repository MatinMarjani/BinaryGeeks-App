class AppUrl {
  static const String liveBaseURL = 'http://37.152.176.11';
  //static const String localBaseURL = "  http://localhost:8000";
  static const String localBaseURL = "http://10.0.2.2:8000";
  // static const String ____localBaseURL = "http://127.0.0.1:8000";

  static const String baseURL = liveBaseURL;

  //Auth :
  static const String login = baseURL + "/api/auth/login"; //POST
  static const String register = baseURL + "/api/auth/register"; //POST
  static const String logout = baseURL + "/api/auth/logout"; //GET

  //User Profile :
  // + $id
  static const String Get_Profile = baseURL + "/api/users/"; //Get
  static const String Update_Profile = baseURL + "/api/users/"; //PUT
  static const String Delete_Profile = baseURL + "/api/users/"; //DEL
  // +$id + '/change-password'
  static const String Change_Password = baseURL + "/api/users/"; //PUT

  //Posts
  static const String Add_Post = baseURL + "/api/posts"; //POST
  static const String Get_Available_Categories = baseURL + "/api/categories"; //GET
  static const String Get_Post = baseURL + "/api/posts/"; // + $id  //GET
  static const String Update_Post = baseURL + "/api/posts/"; // + $id  //PUT
  static const String Delete_Post = baseURL + "/api/posts/"; // + $id  //DEL
  static const String Get_Post_Status = baseURL + "/api/posts/status"; // + $id  //DEL
  static const String Get_My_Posts = baseURL + "/api/posts/myposts"; //Headers token //GET

  //Search$Filter
  static const String Search = baseURL + "/api/filter/"; //+params  //GET

  //Bids
  static const String Post_Bid = baseURL + "/api/bids"; //post

  //BookMark
  static const String Get_BookMarks = baseURL + "/api/bookmarks/getmarks"; //Headers token //Get
  static const String Set_BookMarks = baseURL + "/api/bookmarks/setmark"; //Headers token //Body //Post
  static const String Is_BookMarks = baseURL + "/api/bookmarks/ismarked?postid="; //Headers token //params=postid //Get

  //Notifications
  static const String Get_Notifications = baseURL + "/api/notifications/getmynotifications"; //Headers token //Get

  //chat
  static const String Get_User_Chats = baseURL + "/api/users/chats"; //Headers token //Get
  static const String Get_Chat_Messages = baseURL + "/api/chat/"; //Headers token //threadID //Get
  static const String Send_Messages = baseURL + "/api/chat/"; //Headers token //threadID //POST
  static const String Get_Chat_ThreadId = baseURL + "/api/chat?other="; //Headers token //params + otherID
// Get

}
