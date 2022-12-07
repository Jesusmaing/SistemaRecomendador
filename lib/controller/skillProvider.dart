import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SkillsProvider with ChangeNotifier {
  List<String> _skills = [];
  List<String> get skills => _skills;

  List<String> _jobRecomendation = [];

  List<String> get jobRecomendation => _jobRecomendation;

  void addSkill(String skill) {
    if (_skills.contains(skill)) {
      _skills.remove(skill);
      notifyListeners();
      return;
    }
    _skills.add(skill);
    notifyListeners();
  }

  void removeSkill(String skill) {
    _skills.remove(skill);
    notifyListeners();
  }

  Future<List<String>> fetchRecommendations() async {
    final url = Uri.parse(
        'https://sistema-recomendador.herokuapp.com/recommender?skills=${_skills.join(',')}');
    final response = await http.get(url);
    var _response = json.decode(response.body);
    var skills = json.decode(_response['data']) as List;
    return skills.map((e) => e.toString()).toList();
    //_jobRecomendation = skills.map((e) => e.toString()).toList();
  }

  String cleanedString(String string) {
    //replace ' for empty string

    return string.replaceAll('[', '').replaceAll(']', '').replaceAll("'", '');
  }

  Future<void> showRecommendationsDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Recomendacioes'),
            content: FutureBuilder(
                future: fetchRecommendations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                  if (snapshot.hasData) {
                    _jobRecomendation = snapshot.data as List<String>;
                    return SizedBox(
                      width: 600,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _jobRecomendation.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                "$index.${cleanedString(_jobRecomendation[index])}"),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          );
        });
  }
}
