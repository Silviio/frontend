import 'package:avaliacao/models/category.dart';
import 'package:avaliacao/repositories/course_repository.dart';

class Course {
  int id;
  String descriptionSubject;
  DateTime startDate;
  DateTime endDate;
  int studentAmountPerClass;
  Category category;

  Course(
      {this.id,
      this.descriptionSubject,
      this.startDate,
      this.endDate,
      this.studentAmountPerClass,
      this.category});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descriptionSubject = json['descriptionSubject'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    studentAmountPerClass = json['studentAmountPerClass'];
    category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': this.id,
        'descriptionSubject': this.descriptionSubject,
        'startDate': this.startDate.toString().substring(0, 10),
        'endDate': this.endDate.toString().substring(0, 10),
        'studentAmountPerClass': this.studentAmountPerClass,
        'category': this.category.toJson(),
      };
}

class CourseModel {
  final repository = CourseRepository();

  Future<Course> createCourse(Course course) async {
    return await repository.createCourse(course);
  }

  Future<List<Course>> getCourses() async {
    return await repository.getCourses();
  }

  Future<void> deleteCourse(int id) async {
    await repository.deleteCourse(id);
  }
}
