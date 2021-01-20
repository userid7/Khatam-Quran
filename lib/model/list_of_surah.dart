import 'dart:convert';

import 'package:flutter/services.dart';

class Surah {
  String englishName;
  String englishNameTranslation;
  int numberOfAyahs;
  String revelationType;

  Surah({
    this.englishName,
    this.englishNameTranslation,
    this.numberOfAyahs,
    this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
    );
  }
}

class ListOfSurah {
  List<Surah> listOfSurah;

  ListOfSurah({this.listOfSurah});

  factory ListOfSurah.fromJson(List<dynamic> json) {
    List<Surah> listOfSurah = List<Surah>();
    listOfSurah = json.map((i) => Surah.fromJson(i)).toList();
    return ListOfSurah(
      listOfSurah: listOfSurah,
    );
  }

  static Future<ListOfSurah> fetchData() async {
    var jsonString = await rootBundle.loadString('asset/loadjson/surah.json');
    var jsonResponse = json.decode(jsonString);
    ListOfSurah data = ListOfSurah.fromJson(jsonResponse);
    return data;
  }

  int convertToNumber(int numAyah, int numSurah) {
    int number = 0;
    List<Surah> list = this.listOfSurah;
    for (var i = 0; i < numSurah; i++) {
      number += list[i].numberOfAyahs;
    }
    number += numAyah;
    return number;
  }
}
