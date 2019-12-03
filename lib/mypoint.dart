import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String myPoint = "0";

class MyPoin extends StatefulWidget {
  @override
  _MyPoinState createState() => _MyPoinState();
}

class _MyPoinState extends State<MyPoin> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      // shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Petunjuk",
                style: TextStyle(
                    fontSize: 30.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto"),
              )
            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _gambar(myPoint),
            ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                myPointWidget(),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                  "kamu bisa dapat satu poin setiap kamu menggunakan fitur chat"),
              Text(
                  "Jika login dalam 2 hari berturut-turut , kamu akan mendapatkan 5 poin"),
              Text(
                  "Klik tombol give location information ketika kamu sedang berada di wilayah UNSRI Palembang, jalan Palembang-indralaya atau UNSRI indralaya untuk mendapatkan 5 poin disetiap posisi"),
            ],
          ),
        ),
        Divider(height: 15.0),
        Column(
          children: <Widget>[
            Text("Keterangan Badge",
                style: TextStyle(
                    fontSize: 20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w300,
                    fontFamily: "Roboto")),
            _badgeImage2(1),
            _badgeImage2(2),
            _badgeImage2(3),
            _badgeImage2(4),
            _badgeImage2(5),
            _badgeImage2(6),
            _badgeImage2(7),
            _badgeImage2(8),
            _badgeImage2(9),
            RaisedButton(
              onPressed: () => launch('https://forms.gle/5KDVkkgBLcDGx8Ju5'),
              child: const Text('Isi Survey'),
            ),
          ],
        ),
      ],
    ));
  }

  Widget myPointWidget() {
    _getPoin();
    return Text(
      "poin saya : " + myPoint,
      style: TextStyle(
          fontSize: 20.0,
          color: const Color(0xFF000000),
          fontWeight: FontWeight.w300,
          fontFamily: "Roboto"),
    );
  }

  Widget _gambar(String poin) {
    int poin2 = int.parse(poin);
    var level;
    level = poin2 / 20;
    level = level.toInt();
    if (level < 1) {
      level = 1;
    }
    if (level > 9) {
      level = 9;
    }
    return Image.asset(
      'badge/lvl' + level.toString() + '.png',
      width: 25.0,
    );
  }

  _getPoin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _point = prefs.getInt('point') ?? 1;
    setState(() {
      myPoint = _point.toString();
    });
  }
}

Widget _badgeImage2(int level) {
  var v = ((level) * 20);
  var v2 = v + 9;
  String v3 = v.toString() + " - " + v2.toString();
  if (level < 2) {
    v3 = "1 - 39";
  }
  if (level > 8) {
    v3 = "    > 180";
  }
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'badge/lvl' + level.toString() + '.png',
          width: 25.0,
        ),
        Text("Level $level"),
        Text(v3),
      ]);
}
