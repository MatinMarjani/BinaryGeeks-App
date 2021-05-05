class Post {
  int owner_id;
  String owner_email;
  String owner_profile_image;
  int id;
  String title;
  String author;
  String publisher;
  int price;
  String province;
  String city;
  String zone;
  String status;
  String description;
  bool is_active;
  String image; //url
  String categories;
  String created_at;

  Post(
    this.owner_id,
    this.owner_email,
    this.owner_profile_image,
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
