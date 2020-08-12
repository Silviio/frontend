import 'dart:async';

import 'package:avaliacao/models/category.dart';
import 'package:avaliacao/models/course.dart';
import 'package:avaliacao/resources/string_value.dart';
import 'package:avaliacao/services/validator.dart';
import 'package:avaliacao/widgets/course_text_form_field.dart';
import 'package:avaliacao/widgets/internet_warning.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseView extends StatefulWidget {
  @override
  _CourseViewState createState() => _CourseViewState();

  CourseView({Key key, this.course}) : super(key: key);

  final Course course;
}

class _CourseViewState extends State<CourseView> {
  final _formKey = GlobalKey<FormState>();

  final CategoryModel _categoryModel = CategoryModel();
  final CourseModel _courseModel = CourseModel();

  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _studentAmount = TextEditingController();

  StreamSubscription<ConnectivityResult> _subscription;
  bool _hasConnection = true;

  List<Category> _categories;
  Category _pickedCategory;
  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _categories = _categoryModel.getCategories();
    _pickedCategory = _categories.first;
    _loadingData();
    _checkConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          title: Text("Novo Curso",
              style: TextStyle(
                  fontFamily: 'Spartan MB',
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold))),
      body: Builder(
        builder: (context) => _hasConnection
            ? SingleChildScrollView(
                child: _getForm(context),
              )
            : InternetWarning(),
      ),
    );
  }

  Future<DateTime> _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: DateTime.now(),
    );
    return date;
  }

  String _getFormattedDate(DateTime dateTime) {
    return dateTime.toString().substring(0, 10).replaceAll("-", "/");
  }

  bool _isStartDateBeforeEndDate(BuildContext context) {
    if (_startDate.isBefore(_endDate) ||
        _startDate.isAtSameMomentAs(_endDate)) {
      return true;
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Ops, a data final deve ser depois da inicial ')));
      return false;
    }
  }

  void _submit(Course course) {
    _courseModel.createCourse(course);
  }

  _showMessage(BuildContext context, String errorMsg) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
  }

  _loadingData() {
    if (widget.course != null) {
      setState(() {
        _descriptionController.text = widget.course.descriptionSubject;

        _startDate = widget.course.startDate;
        _startDateController.text =
            "Data Início: " + _getFormattedDate(widget.course.startDate);

        _endDate = widget.course.endDate;
        _endDateController.text =
            "Data Início: " + _getFormattedDate(widget.course.endDate);

        _studentAmount.text = widget.course.studentAmountPerClass.toString();
        _pickedCategory = widget.course.category;
      });
    }
  }

  _checkConnectivity() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          _hasConnection = true;
        } else {
          _hasConnection = false;
        }
      });
    });
  }

  Widget _getForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CourseTextFormField(
                controller: _descriptionController,
                hint: "Descrição do curso",
                validator: Validator.description),
            ListTile(
                leading: Icon(Icons.calendar_today),
                title: TextFormField(
                  enabled: false,
                  controller: _startDateController,
                  decoration: InputDecoration(
                      hintText: "Selecione a data Início",
                      errorStyle: TextStyle(color: Colors.red)),
                  validator: Validator.data,
                ),
                onTap: () async {
                  var date = await _pickDate();
                  if (date != null)
                    setState(() {
                      _startDate = date;
                      _startDateController.text =
                          "Data Início: " + _getFormattedDate(date);
                    });
                }),
            ListTile(
                leading: Icon(Icons.calendar_today),
                title: TextFormField(
                  enabled: false,
                  controller: _endDateController,
                  decoration: InputDecoration(
                      hintText: "Selecione a data término",
                      errorStyle: TextStyle(color: Colors.red)),
                  validator: Validator.data,
                ),
                onTap: () async {
                  var date = await _pickDate();
                  if (date != null)
                    setState(() {
                      _endDate = date;
                      _endDateController.text =
                          "Data Término: " + _getFormattedDate(date);
                    });
                }),
            ListTile(
              leading: Icon(Icons.accessibility),
              title: TextFormField(
                controller: _studentAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Quantidade de alunos",
                ),
                validator: Validator.studentAmount,
              ),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: DropdownButton<Category>(
                hint: Text("Selecione uma categoria"),
                value: _pickedCategory,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                items: _categories.map((Category value) {
                  return DropdownMenuItem<Category>(
                    value: value,
                    child: Text(value.description),
                  );
                }).toList(),
                onChanged: (Category newValue) {
                  setState(() {
                    _pickedCategory = newValue;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: RaisedButton(
                color: Colors.blue[800],
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState.validate() &&
                      _isStartDateBeforeEndDate(context)) {
                    try {
                      var course = Course(
                          descriptionSubject: _descriptionController.text,
                          startDate: _startDate,
                          endDate: _endDate,
                          studentAmountPerClass: int.parse(_studentAmount.text),
                          category: _pickedCategory);

                      //Verifica se é update ou create
                      if (widget.course != null) course.id = widget.course.id;

                      _submit(course);
                      _showMessage(
                          context,
                          widget.course != null
                              ? "Curso atualizado com sucesso"
                              : "Curso cadastrado");
                    } catch (e) {
                      _showMessage(context, e.toString());
                    }
                  }
                },
                child: Text('Cadastrar'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
