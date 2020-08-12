import 'package:avaliacao/models/course.dart';
import 'package:avaliacao/resources/constants.dart';
import 'package:avaliacao/services/networking.dart';
import 'dart:async';

class CourseRepository {
  final network = Network(baseUrl);

  Future<Course> createCourse(Course course) async {
    var response = await network.post("/course", course.toJson());
    return Course.fromJson(response);
  }

  Future<List<Course>> getCourses() async {
    var response = await network.get("/courses");
    List<dynamic> data = response;
    List<Course> courses = data.map((e) => Course.fromJson(e)).toList();

    return courses;
  }

  Future<void> deleteCourse(int id) async {
    network.delete('/courses/$id');
  }
}
