class User {
  int posts;
  int followers;
  int following;
  String account;
  String id;
  String username;
  String name;
  String profilePic;
  String bio;
  String joined;

  User({
    this.posts,
    this.followers,
    this.following,
    this.account,
    this.id,
    this.name,
    this.username,
    this.profilePic,
    this.bio,
    this.joined,
  });

  User.fromJson(Map<String, dynamic> json) {
    this.posts = json['posts'];
    this.followers = json['followers'];
    this.following = json['following'];
    this.account = json['account'];
    this.id = json['_id'];
    this.name = json['name'];
    this.username = json['username'];
    this.profilePic = json['profilePic'];
    this.bio = json['bio'];
    this.joined = json['created_at'];
  }
}
