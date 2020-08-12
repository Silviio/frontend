import 'dart:async';

import 'package:avaliacao/models/course.dart';
import 'package:avaliacao/views/course_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final StreamController<List<Course>> _streamController =
      StreamController<List<Course>>();

  final CourseModel _courseModel = CourseModel();

  final _searchController = TextEditingController();

  StreamSubscription<ConnectivityResult> _subscription;
  bool _hasConnection = true;

  List<Course> _courses = List<Course>();

  @override
  void initState() {
    super.initState();
    _getCourses();
    _checkConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          title: Text("Cast Avalição",
              style: TextStyle(
                  fontFamily: 'Spartan MB',
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold))),
      backgroundColor: Color(0xFFF2F3F8),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search, color: Colors.black87, size: 30.0),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: TextField(
                      enabled: _hasConnection,
                      controller: _searchController,
                      onChanged: _onTextChanged,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        hintStyle: TextStyle(
                            color: _hasConnection
                                ? Colors.grey[800]
                                : Colors.red[400]),
                        hintText: _hasConnection
                            ? "Pesquisar"
                            : "Sem conexão com a internet",
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Separator
            Padding(
              padding: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    width: double.maxFinite,
                    height: 1.8,
                    color: Colors.grey[300],
                  )),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      "Cursos",
                      style: TextStyle(
                          fontFamily: 'Spartan MB',
                          color: Colors.grey[800],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    width: double.maxFinite,
                    height: 1.8,
                    color: Colors.grey[300],
                  )),
                ],
              ),
            ),
            //Lista com os cursos
            Expanded(
              child: StreamBuilder<List<Course>>(
                stream: _streamController.stream,
                builder: (context, snap) {
                  if (snap.hasData) {
                    var courses = snap.data;
                    return ListView(
                      children: ListTile.divideTiles(
                              context: context,
                              tiles: List.generate(courses.length, (index) {
                                var course = courses[index];

                                return Dismissible(
                                  key: Key(course.id.toString()),
                                  direction: DismissDirection.startToEnd,
                                  background: Container(
                                    color: Colors.red,
                                    child: Align(
                                      alignment: Alignment(-0.9, 0.0),
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _courses.removeAt(index);
                                    _courseModel.deleteCourse(course.id);
                                    _streamController.sink.add(_courses);
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      child: Text(
                                          course.category.description
                                              .substring(0, 1),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                              color: Colors.white)),
                                    ),
                                    title: Text(course.descriptionSubject),
                                    subtitle: Text(_showFormattedStarAndEndDate(
                                        course.startDate, course.endDate)),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black45,
                                      ),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseView(course: course)),
                                        );
                                        _getCourses();
                                      },
                                    ),
                                  ),
                                );
                              }),
                              color: Colors.grey)
                          .toList(),
                    );
                  }

                  if (snap.hasError) {
                    return Center(
                        child: Text("Erro ao se comunicar com o servidor",
                            style: TextStyle(
                                fontFamily: 'Spartan MB',
                                color: Colors.grey[800],
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold)));
                  }

                  return Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseView()),
          );

          _getCourses();
        },
        tooltip: 'add',
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add),
      ),
    );
  }

  _getCourses() async {
    _courses.clear();
    try {
      _courses = await _courseModel.getCourses().timeout(Duration(seconds: 5));
      _streamController.sink.add(_courses);
    } catch (e) {
      _streamController.addError(e.toString());
    }
  }

  _showFormattedStarAndEndDate(DateTime start, DateTime end) {
    var startDate = start.toString().substring(0, 10).replaceAll("-", "/");
    var endDate = end.toString().substring(0, 10).replaceAll("-", "/");

    return "$startDate - $endDate";
  }

  _checkConnectivity() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          _hasConnection = true;
          _getCourses();
        } else {
          _hasConnection = false;
        }
      });
    });
  }

  void _onTextChanged(String value) {
    if (value.length == 0 || value == null || value == "") {
      _getCourses();
      return;
    }

    value = value.toUpperCase();

    var filteredCourses = _courses.where((course) {
      if (course.descriptionSubject.toUpperCase().contains(value) ||
          course.category.description.toUpperCase().contains(value))
        return true;
      else
        return false;
    }).toList();

    _streamController.sink.add(filteredCourses);
  }
}
