import 'package:http/http.dart' as http;
import 'dart:convert';

class AyahModel {
  SurahModel surah;
  int numAyah;
  String textAyah;
  int position;

  AyahModel({this.surah, this.numAyah, this.textAyah, this.position});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      surah: SurahModel.fromJson(json['surah']),
      numAyah: json['numberInSurah'],
      textAyah: json['text'],
    );
  }

  static Future<AyahModel> fetchData(String numOfAyah) async {
    final response =
        await http.get('http://api.alquran.cloud/v1/ayah/' + numOfAyah);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonObject = json.decode(response.body);
      var jsonData = jsonObject['data'];
      return AyahModel.fromJson(jsonData);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ayah');
    }
  }
}

class SurahModel {
  String nameEnglish;
  String nameEnglishTranslation;
  int numberOfAyahs;

  SurahModel(
      {this.nameEnglish, this.numberOfAyahs, this.nameEnglishTranslation});

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      nameEnglish: json['englishName'],
      nameEnglishTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
    );
  }
}
