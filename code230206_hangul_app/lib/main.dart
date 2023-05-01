// *** main.dart 파일 ***
// 페이지 간 이동을 위한 routes 정의

// 페이지 순서
// 어플 실행: main.dart
// [1](메인 홈 스크린) screen_home.dart 스크린 보여짐

// (1) 글자인식 기능-> (메인 홈 스크린: 카메라 버튼 클릭) screen_Camera.dart로 이동 -> (카메라 스크린: 촬영 버튼 클릭) screen_Camera_result.dart로 이동
//    (1-1) -> (카메라 결과 스크린: 사전 버튼 클릭) screen_dic.dart로 이동 -> (사전 스크린: 단어 버튼 클릭) screen_dic_oepn.dart로 이동
//    (1-2) -> (카메라 결과 스크린: 음성 버튼 클릭) screen_tts.dart로 이동

// (2) 학습 게임 기능 -> 아직 X

import 'package:code230206_hangul_app/screen/snackBarWidget.dart';
import 'package:flutter/material.dart';
import 'screen/screen_dic.dart';
import 'screen/screen_dic_open.dart';
import 'screen/screen_tts.dart';
import 'screen/screen_auth_Login.dart';
import 'screen/screen_game_result.dart';
import 'screen/screen_game_wrongWordList.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String DicScreenText = '';
  String TTSScreenText = '';
  String DicOpenScreenText= '';
  List<List<dynamic>>  GameResultScreenText = [];
  List<List<dynamic>>  GameWrongWordListScreenText = [];


  runApp(MaterialApp(
    scaffoldMessengerKey: SnackBarWidget.messengerKey,
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,

    // login, sign up 화면 prefix icon color 위해 추가
    theme: ThemeData().copyWith(
      colorScheme: ThemeData().colorScheme.copyWith(
        primary: Color(0xFFC0EB75),
      ),
    ),
    title: 'GP App',
    initialRoute: '/',
    routes: {
      '/':(context) => LoginScreen(),

      '/DicScreen':(context) => DicScreen(DicScreenText: DicScreenText),
      '/TTSScreen':(context) => TTSScreen(TTSScreenText: TTSScreenText),
      '/DicOpenScreen':(context) => DicOpenScreen(DicOpenScreenText: DicOpenScreenText),
      '/GameResultScreen':(context) => GameResultScreen(GameResultScreenText: GameResultScreenText),
      '/GameWrongWordListScreen':(context) => GameWrongWordListScreen(GameWrongWordListScreenText: GameWrongWordListScreenText),

    },
  ));
}

//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// FlutterTts flutterTts = FlutterTts();
//
// Future<void> speak(String text) async {
//   await flutterTts.speak(text);
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//
//   String a = 'hi';
//   String b = 'this';
//   String c = 'is';
//   String d = 'book';
//
//   bool isPlaying = false;
//
//   @override
//   void dispose() {
//     super.dispose();
//     flutterTts.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Text-to-Speech Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Press the button to start'),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   setState(() {
//                     isPlaying = true;
//                   });
//                   await flutterTts.awaitSpeakCompletion(true);
//                   await speak(a);
//                   // await flutterTts.awaitSpeakCompletion(true);
//                   await speak(b);
//                   await speak(c);
//                   await speak(d);
//                   setState(() {
//                     isPlaying = false;
//                   });
//                 },
//                 child: Text('Start'),
//               ),
//               SizedBox(height: 20),
//               isPlaying ? CircularProgressIndicator() : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
