// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

class KpopDancerController {
  final String baseUrl = 'http://rendel.mooo.com/api';

  Future<List<Map<String, dynamic>>?> fetchKpopDancers() async {
    final response = await http.get(Uri.parse('$baseUrl/kpop_dancers'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      return data;
    } else {
      throw Exception('Failed to load data from PHP API');
    }
  }

  Future<List<Map<String, dynamic>>?> searchKpopDancers(
      String stageName) async {
    final response = await http
        .get(Uri.parse('$baseUrl/kpop_dancers?stage_name=$stageName'));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      return data;
    } else {
      throw Exception('Failed to search Kpop dancers from PHP API');
    }
  }


  Future<Map<String, dynamic>?> insertKpopDancer(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kpop_dancers'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to insert Kpop dancer via PHP API');
    }
  }

  Future<Map<String, dynamic>?> updateKpopDancer(
    String id,
    newStageName,
    newName,
    newPhoto,
    newAge,
    newSex,
    newKgroup,
    newCompany,
    newDebutYear,
    newNationality,
  ) async {
    // Fetch the existing data first
    final existingData = await getKpopDancerById(id);

    // Build the updated data, preserving existing values if new values are null
    final Map<String, dynamic> data = {
      'stage_name': newStageName ?? existingData['stage_name'],
      'name': newName ?? existingData['name'],
      'photo': newPhoto ?? existingData['photo'],
      'age': newAge ?? existingData['age'],
      'sex': newSex ?? existingData['sex'],
      'kgroup': newKgroup ?? existingData['kgroup'],
      'company': newCompany ?? existingData['company'],
      'debut_year': newDebutYear ?? existingData['debut_year'],
      'nationality': newNationality ?? existingData['nationality'],
    };

    final response = await http.put(
      Uri.parse('$baseUrl/kpop_dancers?id=$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update Kpop dancer via PHP API');
    }
  }

  Future<Map<String, dynamic>> getKpopDancerById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/kpop_dancers?id=$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch Kpop dancer by ID via PHP API');
    }
  }

  Future<void> deleteKpopDancer(id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/kpop_dancers?id=$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete Kpop dancer via PHP API');
    }
  }
}
