import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:fortune_gems/game_main.dart';

class FlameHome extends StatefulWidget {
  const FlameHome({super.key});

  @override
  State<FlameHome> createState() => _FlameHomeState();
}

class _FlameHomeState extends State<FlameHome> {


  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: GameMain(),
      backgroundBuilder: (context) {
        //這是目前試驗出來真正可以直接佔滿全銀幕不變形的方法。
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black38,
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage('assets/images/images/basic_background.jpg'),
            // ),
          ),
        );
      },
    );
  }
}
