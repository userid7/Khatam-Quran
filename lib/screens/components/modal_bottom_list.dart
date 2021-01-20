import 'package:flutter/material.dart';
import 'package:pocket_quran/model/list_of_surah.dart';
import 'package:pocket_quran/provider/app_position.dart';
import 'package:provider/provider.dart';

class ModalBottomList extends StatelessWidget {
  const ModalBottomList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            title: Text(
              'Your Surah',
            ),
          ),
          Divider(),
          ListTile(
            title: Text(Provider.of<Position>(context).saved.surah.nameEnglish),
            subtitle: Text(Provider.of<Position>(context)
                .saved
                .surah
                .nameEnglishTranslation),
            trailing:
                Text(Provider.of<Position>(context).saved.numAyah.toString()),
            onTap: () {
              Provider.of<Position>(context).isSaved = true;
              Provider.of<Position>(context)
                  .goToPage(Provider.of<Position>(context).saved.position);
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            dense: true,
            title: Text(
              'Find Surah',
            ),
          ),
          Divider(),
          ListViewOfSurah(),
        ],
      ),
    );
  }
}

class ListViewOfSurah extends StatelessWidget {
  const ListViewOfSurah({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: ListOfSurah.fetchData(),
        // DefaultAssetBundle.of(context)
        //     .loadString('asset/loadjson/surah.json'),
        builder: (context, snapshot) {
          // var listOfSurah = json.decode(snapshot.data.toString());
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: 114,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data.listOfSurah[index].englishName),
                      subtitle: Text(snapshot
                          .data.listOfSurah[index].englishNameTranslation),
                      trailing: Text(snapshot
                          .data.listOfSurah[index].numberOfAyahs
                          .toString()),
                      onTap: () {
                        Provider.of<Position>(context).stopAudio();
                        Provider.of<Position>(context).isSaved = false;
                        int number = snapshot.data.convertToNumber(0, index);
                        Provider.of<Position>(context).goToPage(number);
                        Navigator.pop(context);
                      },
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
