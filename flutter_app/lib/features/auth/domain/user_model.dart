class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'display_name': displayName,
    'photo_url': photoUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    email: json['email'],
    displayName: json['display_name'],
    photoUrl: json['photo_url'],
  );
}