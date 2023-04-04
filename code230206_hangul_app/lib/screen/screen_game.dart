import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'screen_game_result.dart';

final quizNumber = 2; // 전체 퀴즈수

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  // firestore 저장된 단어 가져오기
  late User user;
  late CollectionReference wordsRef;
  List<QueryDocumentSnapshot> starredWords = [];

  // gameWordList의 index 저장
  int index = 0;

  // 게임이 끝나는 시점을 알리는 변수
  bool endGameReady = false;

  // 게임에 사용할 단어 리스트. bool은 모두 false로 초기화
  List<List<dynamic>> gameWordList = List.generate(quizNumber, (_) => ['', '', false]);

  // 게임에 사용할 기본 단어 리스트. Firestore에 저장된 단어가 10개 이하일 경우 사용
  List<List<dynamic>> gameBasicWordList = [
    ['사과', 'mean1', false],
    ['바나나', 'mean2', false],
    ['딸기', 'mean3', false],
    ['포도', 'mean4', false],
    ['오렌지', 'mean5', false],
    ['배', 'mean6', false],
    ['키위', 'mean7', false],
    ['블루베리', 'mean8', false],
    ['복숭아', 'mean9', false],
    ['오렌지', 'mean10', false],
  ];

  int randomSend = 0;
  String _buttonText = 'hint 받기';
  int timesController = 0;
  final _controller = TextEditingController();

  void _initializeUserRef() {
    user = FirebaseAuth.instance.currentUser!;
    wordsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('words');
  }

  // Firestore에 저장된 단어 starredWords 리스트에 저장
  void _getStarredWords() async {
    final QuerySnapshot querySnapshot = await wordsRef.get();
    setState(() {
      starredWords = querySnapshot.docs;
      _generateGameWordList();
    });
  }

  // gameWordList 세팅. 랜덤으로 10개 저장
  void _generateGameWordList() {
    final random = Random();

    // 저장된 단어가 10개보다 많은 경우 starredWords에서 랜덤으로 단어 가져옴
    // 저장된 단어가 10개보다 적은 경우 gameBasicWordList 사용
    for (int i = 0; i < quizNumber; i++) {
      if (i < starredWords.length) {
        int index = random.nextInt(starredWords.length);
        gameWordList[i] = [
          starredWords[index]['word'],
          starredWords[index]['meaning'],
          false,
        ];
      } else {
        gameWordList[i] = gameBasicWordList[i];
      }
    }
    print('***  gameWordList  *** ' + gameWordList.toString());
    setState(() {});
  }

  void getCorrectAnswer() {
    setState(() {
      gameWordList[index][2] = true;
      _controller.clear();
      _buttonText = 'hint 받기';
      timesController = 0;
      if (index < quizNumber - 1 ){
        index++;
      } else {
        endGameReady = true;
      }

      if (endGameReady) {
        Navigator.pushReplacementNamed(
            context,
            GameResultScreen.GameResultScreenRouteName,
            arguments: GameResultScreen(GameResultScreenText: gameWordList)
        );
      }
    });
  }

  void getWrongAnswer() {
    if (timesController == 1) {
      setState(() {
        gameWordList[index][2] = false;
        _controller.clear();
        _buttonText = 'hint 받기';
        timesController = 0;

        if (index <quizNumber){
          index++;
        } else {
          endGameReady = true;
        }

        if (endGameReady) {
          Navigator.pushReplacementNamed(
              context,
              GameResultScreen.GameResultScreenRouteName,
              arguments: GameResultScreen(GameResultScreenText: gameWordList)
          );
        }}
      );
    }
    timesController++;

  }

  // 힌트
  void setHint() {
    _buttonText = gameWordList[index][0];
  }

  // 답 체크
  bool _checkAnswer(String input) {
    bool answer =
        isKorean(input) && _controller.text == gameWordList[index][0];
    print('***  answer  *** ' + answer.toString());
    print('***  index  *** ' + index.toString());
    print('***  _controller.text  *** ' + _controller.text.toString());
    print('***  isKorean  *** ' + isKorean(input).toString());
    print('***   ==  *** ' + _controller.text ==
        gameWordList[index][0].toString());
    return answer;
  }

  bool isKorean(String str) {
    final regex = RegExp('[\\uAC00-\\uD7AF]+');
    return regex.hasMatch(str);
  }

  // 초성 추출 함수
  String? getFirstConsonant(String str) {
    final Map<int, String> initialConsonants = {
      4352: 'ㄱ',
      4353: 'ㄲ',
      4354: 'ㄴ',
      4355: 'ㄷ',
      4356: 'ㄸ',
      4357: 'ㄹ',
      4358: 'ㅁ',
      4359: 'ㅂ',
      4360: 'ㅃ',
      4361: 'ㅅ',
      4362: 'ㅆ',
      4363: 'ㅇ',
      4364: 'ㅈ',
      4365: 'ㅉ',
      4366: 'ㅊ',
      4367: 'ㅋ',
      4368: 'ㅌ',
      4369: 'ㅍ',
      4370: 'ㅎ'
    };

    if (str == null) {
      throw Exception('한글이 아닙니다');
    } else {
      List<int> runes = str.runes.toList();
      String result = '';

      for (int i = 0; i < runes.length; i++) {
        int unicode = runes[i];
        if (unicode < 44032 || unicode > 55203) {
          throw Exception('한글이 아닙니다');
        }
        int index = (unicode - 44032) ~/ 588;
        result += initialConsonants[4352 + index]!;
      }

      return result;
    }

  }


  @override
  void initState() {
    super.initState();
    _initializeUserRef();
    _getStarredWords();
  }


  @override
  Widget build(BuildContext context) {
    // 스크린 사이즈 정의
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F3F3),
        elevation: 0.0,
        title: Text(
          "I HANGUL",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white)),
          width: width * 0.85,
          height: height * 0.7,
          child: Swiper(physics: NeverScrollableScrollPhysics(),
          loop: false,
          itemCount: 11,
          itemBuilder: (BuildContext context, int index) {
            return index < quizNumber
                ? _buildQuizCard(gameWordList, width, height)
                : Container(); // empty container to return nothing
          },
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(List gameWordList, double width, double height) {
    print('***  _buildQuizCard_index  *** ' + index.toString());
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFF3F3F3)),
            color: Color(0xFFF3F3F3),
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width*0.024, 0, width*0.024),
            child: Text(
              'Q' + (index+1).toString() + '.',
              style: TextStyle(
                fontSize: width*0.06,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Text(getFirstConsonant(gameWordList[index][0]) ?? '', style: TextStyle(fontSize: 48)),
          Text(gameWordList[index][1], style: TextStyle(fontSize: 20)),
          SizedBox(height: 30),
          TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: '정답을 입력해주세요.', hintStyle: TextStyle(fontSize: 24)),
              textAlign: TextAlign.center,

              onSubmitted: (input) {
                if (_checkAnswer(input)){
                  showDialog( // true - 정답인 경우
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('정답'),
                        content: Image.asset('assets/images/right.png', width: 100, height: 100,),
                        actions: [TextButton(child: Text('OK'),
                            onPressed: () {
                          Navigator.of(context).pop();
                          getCorrectAnswer();
                            })],));
                } else {
                  // print('***  timesController  *** ' + timesController.toString());
                  // print('***  _controller.text  *** ' + _controller.text);
                  // print('***  gameWordList[index].item1  *** ' + gameWordList[index][0]);
                  // print('***  index  *** ' + index.toString());

                  showDialog( // false - 오답인 경우
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('틀렸어요'),
                        content: Image.asset('assets/images/wrong.png', width: 100, height: 100,),
                        actions: [TextButton(child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getWrongAnswer();
                            })],));
                }
              }
          ),
          SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/key_color.png', height: 50, width: 50),
                SizedBox(width: 32),
                TextButton(
                  child: Text(_buttonText, style: TextStyle(fontSize: 32)),
                  onPressed: () => setState(setHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
