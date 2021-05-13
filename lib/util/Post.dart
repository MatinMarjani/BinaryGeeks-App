class Post {
  int ownerId;
  String ownerEmail;
  String ownerProfileImage;
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
  bool isActive;
  String image; //url
  String categories;
  String createdAt;

  Post(
    this.ownerId,
    this.ownerEmail,
    this.ownerProfileImage,
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
    this.isActive,
    this.image, //url
    this.categories,
    this.createdAt,
  );
}
