class Users {
  final int? usrId;
  final String? fullName;
  final String? email;
  final String password;
  final String? photo;

  Users({
    this.usrId,
    this.fullName,
    this.email,
    required this.password,
    this.photo,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    usrId: json["usrId"],
    fullName: json["fullName"],
    email: json["email"],
    password: json["usrPassword"],
    photo: json["photo"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "fullName": fullName,
    "email": email?.trim().toLowerCase(),
    "usrPassword": password,
    "photo": photo,
  };

  Users copyWith({String? photo}) {
    return Users(
      usrId: usrId,
      fullName: fullName,
      email: email,
      password: password,
      photo: photo ?? this.photo,
    );
  }
}

class Course {
  final int? id;
  final String cid;
  final String? name;
  final String? description;
  final int noOfChapters;
  final bool includeVideo;
  final String level;
  final String? category;
  final String? courseJson; // JSON string
  final String userEmail; // foreign key reference to Users.email
  final String? bannerImageURL;
  final String? courseContent;

  Course({
    this.id,
    required this.cid,
    this.name,
    this.description,
    required this.noOfChapters,
    this.includeVideo = false,
    required this.level,
    this.category,
    this.courseJson,
    required this.userEmail,
    this.bannerImageURL = '',
    this.courseContent,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      cid: map['cid'],
      name: map['name'],
      description: map['description'],
      noOfChapters: map['noOfChapters'],
      includeVideo: map['includeVideo'] == 1 || map['includeVideo'] == true,
      level: map['level'],
      category: map['category'],
      courseJson: map['courseJson'],
      userEmail: map['userEmail'],
      bannerImageURL: map['bannerImageURL'],
      courseContent: map['courseContent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cid': cid,
      'name': name,
      'description': description,
      'noOfChapters': noOfChapters,
      'includeVideo': includeVideo ? 1 : 0,
      'level': level,
      'category': category,
      'courseJson': courseJson,
      'userEmail': userEmail.trim().toLowerCase(),
      'bannerImageURL': bannerImageURL,
      'courseContent': courseContent,
    };
  }
}
