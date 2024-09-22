import 'package:http/http.dart' as http;
import 'dart:convert';


String connection = 'http://rendel.mooo.com/api/';

Future<List<Map<String, dynamic>>?> fetchDataFromPHPApi() async {
  final response =
      await http.get(Uri.parse(connection));

  if (response.statusCode == 200) {
    // Parse the JSON response
    List<Map<String, dynamic>> data =
        (json.decode(response.body) as List).cast<Map<String, dynamic>>();
    return data;
  } else {
    throw Exception('Failed to load data from the PHP API');
  }
}


