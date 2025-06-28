class Users {
  final int id;
  final String name;
  final String email;
  final String? photo;

  Users({
    required this.id,
    required this.name,
    required this.email,
    this.photo,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photo': photo,
  };
}
