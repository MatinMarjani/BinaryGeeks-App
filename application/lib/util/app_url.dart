class AppUrl {
  static const String liveBaseURL = 'http://37.152.176.11';
  //static const String localBaseURL = "  http://localhost:8000";
  static const String localBaseURL = "http://10.0.2.2:8000";
  static const String ____localBaseURL = "http://127.0.0.1:8000";

  static const String baseURL = liveBaseURL;

  //Auth :
  static const String login = baseURL + "/api/auth/login"; //POST
  static const String register = baseURL + "/api/auth/register"; //POST
  static const String logout = baseURL + "/api/auth/logout"; //GET

  //User Profile :
  // + $id
  static const String Get_Profile = baseURL + "/users/"; //Get
  static const String Update_Profile = baseURL + "/users/"; //PUT
  static const String Delete_Profile = baseURL + "/users/"; //DEL
  // +$id + '/change-password'
  static const String Change_Password = baseURL + "/users/"; //PUT

  //Posts
  static const String Add_Post = baseURL + "/posts"; //POST
  static const String Get_Available_Categories = baseURL + "/categories"; //GET
  static const String Get_Post = baseURL + "/posts/"; // + $id  //GET
  static const String Update_Post = baseURL + "/posts/"; // + $id  //PUT
  static const String Delete_Post = baseURL + "/posts/"; // + $id  //DEL
  static const String Get_Post_Status = baseURL + "/posts/status"; // + $id  //DEL


}
