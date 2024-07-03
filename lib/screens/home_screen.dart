import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 10;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  int totalPomodoros = 0;

  // late modifier : 해당 property를 당장 초기화 하지 않아도 되도록 함
  // 사용하기 전에 초기화 필수
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    // duration : 해당 주기마다 함수 실행
    // 함수 선언 시 괄호를 붙이면 지금 실행한다는 뜻
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );

    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

// 코드 챌린지
// 시간 리셋
  void onResetPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds) {
    // duration : 시간 포맷
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Flexible : 하드코딩되는 값을 만들게 해줌
          // UI의 비례해서 비율을 설정해줌
          Flexible(
            flex: 1,
            child: Container(
              // alignment : 상단바에 가려지지 않게 조정
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 120,
                  color: Theme.of(context).cardColor,
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon:
                      Icon(isRunning ? Icons.pause : Icons.play_arrow_rounded),
                ),
                IconButton(
                    iconSize: 50,
                    color: Theme.of(context).textTheme.headlineLarge!.color,
                    onPressed: onResetPressed,
                    icon: const Icon(Icons.restore_rounded))
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                // expanded : 영역을 끝까지 확장시켜줌
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      // 테두리 설정
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
