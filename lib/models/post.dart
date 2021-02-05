import 'package:simple_feed/models/user.dart';

class Post {
  String id;
  String username;
  String name;
  String image;
  String caption;
  String profileImage;
  String created;
  int likes;
  bool isLiked;
  Post({
    this.id,
    this.username,
    this.name,
    this.image,
    this.caption,
    this.profileImage,
    this.created,
    this.likes,
    this.isLiked,
  });
  Post.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json['user']);
    this.id = json['_id'];
    this.username = user.username;
    this.name = user.name;
    // this.image = json['image'];
    // this.profileImage = user.profilePic;
    this.image = 'assets/images/logo.png';
    this.profileImage = 'assets/images/logo.png';
    this.caption = json['caption'];
    this.created = json['created_at'];
    this.likes = json['likes'];
    this.isLiked = json['isLiked'];
  }
}
