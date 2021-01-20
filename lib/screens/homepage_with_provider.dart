import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pocket_quran/provider/app_position.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/body_page.dart';
import 'components/modal_bottom_list.dart';

class HomePageProvider extends StatefulWidget {
  const HomePageProvider({Key key}) : super(key: key);

  @override
  _HomePageProviderState createState() => _HomePageProviderState();
}

class _HomePageProviderState extends State<HomePageProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Khatam Quran',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BodyPage(),
      floatingActionButton: Consumer<Position>(
        builder: (context, appPosition, _) => FloatingActionButton(
          onPressed: () {
            appPosition.doAudio();
          },
          tooltip: 'Play Audio',
          backgroundColor: appPosition.audioColor,
          child: appPosition.audioIcons,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 45.0,
                    width: 45.0,
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return ModalBottomList();
                          },
                        );
                      },
                      icon: const Icon(Icons.playlist_play),
                    ),
                  ),
                  // Consumer<Position>(
                  //   builder: (context, appPosition, _) => Text(
                  //     appPosition.position.toString(),
                  //   ),
                  // ),
                ],
              ),
              Consumer<Position>(
                builder: (context, appPosition, _) => IconButton(
                  icon: appPosition.iconSaved,
                  color: appPosition.colorSaved,
                  onPressed: () {
                    appPosition.isSaved
                        ? appPosition.isSaved = false
                        : appPosition.isSaved = true;
                  },
                ),
              ),
            ],
          )),
    );
  }
}
