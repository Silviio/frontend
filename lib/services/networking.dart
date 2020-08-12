import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  Network(this._baseUrl);

  final String _baseUrl;
  var _header = {"Content-Type": "application/json"};

  Future<void> delete(String path) async {
    await http.delete(_baseUrl + path);
  }

  Future<dynamic> get(String path) async {
    try {
      http.Response response = await http.get(_baseUrl + path);

      if (response.statusCode == 200) {
        var data = response.body;

        var decodedData = jsonDecode(data);

        return decodedData;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    var body = jsonEncode(data);

    try {
      http.Response response =
          await http.post(_baseUrl + path, headers: _header, body: body);

      if (response.statusCode == 200) {
        var data = response.body;

        var decodedData = jsonDecode(data);

        return decodedData;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
