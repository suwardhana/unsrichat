import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fchat.dart';
import '../mypoint.dart';
import '../location_stream.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
final _auth = FirebaseAuth.instance;
GoogleSignInAccount user = _googleSignIn.currentUser;
String pageTitle = "Unsri Chat";
String username = "";
String _email = "";
String _photoUrl = "https://image.flaticon.com/icons/png/128/23/23171.png";

Future<void> handleSignIn() async {
  try {
    poinLogin();
    if (user == null) user = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await user.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user2 =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user2.displayName);
    await setUsername(user2.displayName);
    await setUserfoto(user2.photoUrl);
    username = user2.displayName;
    _email = user2.email;
    _photoUrl = user2.photoUrl;
    return user2;
  } catch (error) {
    print(error);
  }
}

Future<void> setUsername(String _x) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', _x);
}

// Future<void> _logOut() async {
//   user = null;
//   _googleSignIn.disconnect();
// }

Future<void> pop() async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
}

setUserfoto(String _foto) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('foto', _foto);
}

getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String a = prefs.getString('username');
  return a.toString();
}

class BottomWidget extends StatefulWidget {
  BottomWidget({Key key}) : super(key: key);

  @override
  _BottomWidgetState createState() {
    return _BottomWidgetState();
  }
}

class _BottomWidgetState extends State<BottomWidget> {
  int _selectedIndex = 0;

  @override
  initState() {
    super.initState();
    handleSignIn();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    LocationScreen(),
    MyPoin(),
  ];

  void _onItemTapped(int index) {
    var title = ["UnsriChat", "Riwayat Lokasi", "Bantuan"];
    setState(() {
      _selectedIndex = index;
      pageTitle = title[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(username),
      accountEmail: Text(_email),
      currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(_photoUrl) ?? FlutterLogo(size: 42.0)),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Text('Keluar'),
          onTap: () {
            // _logOut();
            pop();
          },
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text('Riwayat Lokasi'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            title: Text('Bantuan'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

poinLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var dateToday = DateTime.now();
  var lastlogin = prefs.getString('lastlogin').toString();
  if (lastlogin == "null") {
    lastlogin = dateToday.toString();
  }
  var dateFromPref = DateTime.parse(lastlogin);
  var selisih = dateFromPref.difference(dateToday).inDays;
  if (selisih == 1) {
    _poinPlus(howMuch: 5);
  }
  print(
      'selisih : $selisih ------- datetoday :  $dateToday ----- lastlogin : $dateFromPref .');
  await prefs.setString('lastlogin', dateToday.toString());
}

_poinPlus({int howMuch = 1}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int pointBefore = prefs.getInt('point') ?? 0;
  int currentPoint = pointBefore += howMuch;
  await prefs.setInt('point', currentPoint);
}
