class Post {

  int id;
  String title;
  String author;
  String publisher;
  int price;
  double province;
  String city;
  String zone;
  String status;
  String description;
  bool is_active;
  String image; //url
  String categories;
  String created_at;

  Post(
  this.id,
  this.title,
  this.author,
  this.publisher,
  this.price,
  this.province,
  this.city,
  this.zone,
  this.status,
  this.description,
  this.is_active,
  this.image, //url
  this.categories,
  this.created_at,
      );

}