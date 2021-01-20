import 'package:flutter/material.dart';
import 'package:pocket_quran/model/ayah_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PocKet Quran',
        ),
      ),
      body: Container(
          color: Colors.amber[50],
          child: PageView.builder(
            itemBuilder: (context, position) {
              return PageViewWidget(
                position: position,
              );
            },
            controller: PageController(
              initialPage: 4,
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Theme.of(context).primaryColor,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.playlist_play),
              )
            ],
          )),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  final int position;

  const PageViewWidget({Key key, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
          color: Colors.amber[100], borderRadius: BorderRadius.circular(40.0)),
      child: FutureBuilder(
        future: AyahModel.fetchData((position + 1).toString()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              // ? ListViewPosts(posts: snapshot.data) // return the ListView widget
              ? Center(
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
                        child: Text(
                          '${snapshot.data.textAyah}',
                          style: TextStyle(fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ))
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
