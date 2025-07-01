import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Course {
  final String? cid;
  final String? bannerImageURL;
  final CourseJson? courseJson;
  final List<dynamic>? courseContent;

  Course({this.cid, this.bannerImageURL, this.courseJson, this.courseContent});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      cid: json['cid'] as String?,
      bannerImageURL: json['bannerImageURL'] as String?,
      courseJson: json['courseJson'] != null
          ? CourseJson.fromJson(json['courseJson']['course'] ?? {})
          : null,
      courseContent: json['courseContent'] as List<dynamic>?,
    );
  }
}

class CourseJson {
  final String? name;
  final String? description;
  final int? noOfChapters;

  CourseJson({this.name, this.description, this.noOfChapters});

  factory CourseJson.fromJson(Map<String, dynamic> json) {
    return CourseJson(
      name: json['name'] as String?,
      description: json['description'] as String?,
      noOfChapters: json['noOfChapters'] as int? ?? 0,
    );
  }
}

class Enrollment {
  final int? id;
  final String? userEmail;
  final String? courseId;
  final Course? course;

  Enrollment({this.id, this.userEmail, this.courseId, this.course});

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    // The backend returns: { coursesTable: {...}, enrollmentsTable: {...} }
    final enroll = json['enrollmentsTable'] ?? json;
    return Enrollment(
      id: enroll['id'] as int?,
      userEmail: enroll['userEmail'] as String?,
      courseId: enroll['courseId'] as String?,
      course: json['coursesTable'] != null
          ? Course.fromJson(json['coursesTable'])
          : null,
    );
  }
}

Future<List<Course>> fetchEnrolledCourses() async {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";
  try {
    final response = await http.get(Uri.parse('$baseUrl/enrollments'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .where((e) => e != null && e['coursesTable'] != null)
          .map((e) => Course.fromJson(e['coursesTable']))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching courses: ${e.toString()}');
    return [];
  }
}

Future<List<Enrollment>> fetchEnrollments() async {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";
  try {
    final response = await http.get(Uri.parse('$baseUrl/enrollments'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .where((e) => e != null && e['coursesTable'] != null)
          .map((e) => Enrollment.fromJson(e))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching enrollments: ${e.toString()}');
    return [];
  }
}
