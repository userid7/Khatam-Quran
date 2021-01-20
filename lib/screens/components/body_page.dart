import 'package:flutter/material.dart';
import 'package:pocket_quran/model/ayah_model.dart';
import 'package:pocket_quran/provider/app_position.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodyPage extends StatelessWidget {
  const BodyPage({
    Key key,
  }) : super(key: key);

  Future<int> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var pos = pref.getInt('IndexPosition') ?? 0;
    return pos;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[50],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Consumer<Position>(
              builder: (context, appPosition, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('Juz ' + appPosition.currentJuz.toString()),
                  ),
                  Expanded(
                    flex: 6,
                    child: LinearProgressIndicator(
                      value: appPosition.currentProgress,
                      // (appPosition.position + 1) /
                      //     6236, //TODO ; change to appPosition.calculateIndicator()
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Provider.of<Position>(context).pageController =
                      PageController(
                    initialPage: snapshot.data,
                  );
                  return Consumer<Position>(
                    builder: (context, appPosition, _) => PageView.builder(
                      onPageChanged: (position) {
                        Provider.of<Position>(context)
                            .countProgressInJuz(position);
                        appPosition.position = position;
                        appPosition.stopAudio();
                      },
                      itemCount: 6236,
                      itemBuilder: (context, position) {
                        return PageViewOfAyah(
                          position: position,
                        );
                      },
                      //TODO : check this logic. maybe need to wrap widget in consumer
                      controller: appPosition.pageController,
                      // PageController(
                      //   initialPage: snapshot.data,
                      // ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PageViewOfAyah extends StatelessWidget {
  final int position;

  const PageViewOfAyah({Key key, this.position}) : super(key: key);

  void setData(int positionValue) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('IndexPosition', positionValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: FutureBuilder(
        future: AyahModel.fetchData((position + 1).toString()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            Provider.of<Position>(context).isConnected = false;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 40.0,
                    color: Colors.grey[500],
                  ),
                  Text("Failed to connect")
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            Provider.of<Position>(context).isConnected = true;
            if (Provider.of<Position>(context).isSaved) {
              Provider.of<Position>(context).saved = snapshot.data;
              Provider.of<Position>(context).saved.position = position;
              setData(position);
            }
            // Provider.of<Position>(context).englishName =
            //     snapshot.data.surah.nameEnglish;
            // Provider.of<Position>(context).englishNameTranslation =
            //     snapshot.data.surah.nameEnglish;
            // Provider.of<Position>(context).numAyah = snapshot.data.numAyah;
            return Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('${snapshot.data.surah.nameEnglish}' +
                        ' - ' +
                        '${snapshot.data.numAyah}'),
                  ),
                  Divider(),
                  Expanded(
                    flex: 18,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          '${snapshot.data.textAyah}',
                          style: TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
