import 'package:flutter/material.dart';
import 'package:how_far_from_metide/presentation/home_page.dart';
import 'package:how_far_from_metide/config.dart' as config;
import 'package:how_far_from_metide/service_locator.dart' as di;
import 'package:splash_screen_view/SplashScreenView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: withSplash(HomePage()),
    );
  }

  static Widget withSplash(Widget child) {
    return SplashScreenView(
      navigateRoute: child,
      duration: 3000,
      imageSrc: "assets/splash.png",
      backgroundColor: const Color.fromARGB(255, 62, 74, 74),
    );
  }
}
