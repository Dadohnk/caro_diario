import 'package:flutter/services.dart';
import 'package:caro_diario/screens/edit_diary_screen.dart';
import 'package:caro_diario/widgets/diary_list.dart';
import 'package:caro_diario/widgets/diary_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import './screens/main_diary_screen.dart';
import './screens/page_details_screen.dart';
import './screens/edit_diary_screen.dart';
import './screens/auth_screen.dart';
import './screens/settings_screen.dart';
import './screens/privacy_policy_screen.dart';
import './widgets/bottom_nav_bar.dart';

bool _isLocked = false;

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('is_locked') == null)
  {
    prefs.setBool('is_locked', false);
  }
  else
  _isLocked = prefs.getBool('is_locked')!;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        fontFamily: 'OpenSans',
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.black),
          bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
          bodyText2: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black),
          subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black54),
          headline1: TextStyle(fontSize: 26, fontFamily: 'Tomatoes', color: Colors.black),
      ),),
      dark: ThemeData(
        primaryColor: Colors.black54,
        brightness: Brightness.dark,
        backgroundColor: Colors.black54,
        fontFamily: 'OpenSans',
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
          bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white),
          bodyText2: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
          subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),
          headline1: TextStyle(fontSize: 26, fontFamily: 'Tomatoes', color: Colors.white),)
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => ChangeNotifierProvider.value(
        value: DiaryList(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Caro Diario',
          color: Colors.green,
          theme: theme,
          darkTheme: darkTheme,
          home: _isLocked ? AuthScreen() : BottomNavBar(),
          routes: {
            MainDiaryScreen.routeName: (ctx) => MainDiaryScreen(),
            DiaryPage.routeName: (ctx) => DiaryPage(),
            EditDiaryScreen.routeName: (ctx) => EditDiaryScreen(null, null, null, null),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            BottomNavBar.routeName: (ctx) => BottomNavBar()
          },
        ),
      ),
    );
  }
}
