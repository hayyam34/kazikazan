
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'audio_manager.dart';
import 'game_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});
  @override
  Widget build(BuildContext context) {
    AudioManager.instance.startBackground();
    return MaterialApp(debugShowCheckedModeBanner:false, home: const StartPage());
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Center(child: ElevatedButton(
        child: const Text("KAYBETMEYE HAZIRSAN TIKLA"),
        onPressed: ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const GamePage())),
      )),
    );
  }
}
