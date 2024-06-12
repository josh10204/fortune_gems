import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/test_particle_component.dart';


enum WinningType{
  bigWin,
  megaWin,
  superWin
}

class WinningComponent extends PositionComponent {
  WinningComponent({super.position,super.anchor,required this.onCallBack}) : super(size: Vector2(1290, 2796));
  final void Function() onCallBack;

  late TimerComponent _timerComponent;
  late ScaleEffect _scaleEffect ;
  late RectangleComponent _backgroundComponent;
  late SpriteComponent _titleSpriteComponent;
  late SpriteComponent _subtitleSpriteComponent;
  late SpriteComponent _leftBirdSpriteComponent;
  late SpriteComponent _rightBirdSpriteComponent;
  late RectangleComponent _amountBasicComponent;

  WinningType _currentWinningType = WinningType.bigWin;

  Future<void> _nextLevelWin() async {

    int index = _currentWinningType.index;
    index++;
    if(index < WinningType.values.length){
      _currentWinningType = WinningType.values[index];
      _titleSpriteComponent.sprite =  await Sprite.load(_getTitleSpriteImageString());
      _subtitleSpriteComponent.sprite =  await Sprite.load(_getSubtitleSpriteImageString());
      _scaleEffect.reset();
      add(_scaleEffect);
    }else{
      _scaleEffect.reset();
      onCallBack.call();
    }
  }

  String _getTitleSpriteImageString(){
    switch (_currentWinningType){
      case WinningType.bigWin:
        return 'images/win_big.png';
      case WinningType.megaWin:
        return 'images/win_mega.png';
      case WinningType.superWin:
        return 'images/win_super.png';
    }
  }

  String _getSubtitleSpriteImageString(){
    switch (_currentWinningType){
      case WinningType.bigWin:
        return 'images/win_big_win.png';
      case WinningType.megaWin:
        return 'images/win_mega_win.png';
      case WinningType.superWin:
        return 'images/win_super_win.png';
    }
  }


  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initBackgroundComponent();
    _initScaleEffect();
    _initTitleSpriteComponent();
    _initSubtitleSpriteComponent();
    _initLeftBirdSpriteComponent();
    _initRightBirdSpriteComponent();
    _initAmountBasicComponent();
    _showCoinParticleComponent();

  }
  void _initBackgroundComponent() {
    _backgroundComponent = RectangleComponent(size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.black.withOpacity(0.5),);
    add(_backgroundComponent);
  }

  void _initScaleEffect(){
    _scaleEffect = ScaleEffect.to(
      Vector2(1.2,1.2),
      EffectController(duration: 4, reverseDuration: 0.5,curve: Curves.easeInOut),
      onComplete: (){
        _nextLevelWin();
      }
    );
    add(_scaleEffect);
  }

  Future<void> _initTitleSpriteComponent() async {

    double width = 564*1.5;
    double height = 175*1.5;
    double positionX = localCenter.x ;
    double positionY = localCenter.y - height*1.2;

    _titleSpriteComponent = SpriteComponent(
        sprite: await Sprite.load(_getTitleSpriteImageString()),
        size: Vector2(width, height),
        position: Vector2(positionX,positionY),
        anchor: Anchor.center,
        priority: 2);
    add(_titleSpriteComponent);
  }

  Future<void> _initSubtitleSpriteComponent() async {
    double width = 606*0.8;
    double height = 273*0.8;
    double positionX = localCenter.x ;
    double positionY = localCenter.y -  height/2;
    _subtitleSpriteComponent = SpriteComponent(
        sprite: await Sprite.load(_getSubtitleSpriteImageString()),
        size: Vector2(width, height),
        position: Vector2(positionX,positionY),
        anchor: Anchor.center,
        priority: 2);
    add(_subtitleSpriteComponent);
  }

  Future<void> _initLeftBirdSpriteComponent() async {
    double width = 231*1.5;
    double height = 208*1.5;
    double positionX = localCenter.x - width*1.3;
    double positionY = localCenter.y - height/2;
    _leftBirdSpriteComponent = SpriteComponent(
        sprite: await Sprite.load('images/win_bird_left.png'),
        size: Vector2(width, height),
        position: Vector2(positionX,positionY),
        anchor: Anchor.center,
        priority: 1);
    add(_leftBirdSpriteComponent);
  }

  Future<void> _initRightBirdSpriteComponent() async {
    double width = 231*1.5;
    double height = 208*1.5;
    double positionX = localCenter.x + width*1.3;
    double positionY = localCenter.y - height/2;
    _rightBirdSpriteComponent = SpriteComponent(
        sprite: await Sprite.load('images/win_bird_right.png'),
        size: Vector2(width, height),
        position: Vector2(positionX,positionY),
        anchor: Anchor.center,
        priority: 1);
    add(_rightBirdSpriteComponent);
  }

  void _initAmountBasicComponent(){
    double width = 1200;
    double height = 150;
    double positionX = localCenter.x - width/2;
    double positionY = localCenter.y;
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.fromRGBO(50, 30, 22, 0.6),
          Color.fromRGBO(100, 30, 22, 0.7),
          Color.fromRGBO(135, 30, 22, 0.8),
          Color.fromRGBO(100, 30, 22, 0.7),
          Color.fromRGBO(50, 30, 22, 0.6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    _amountBasicComponent = RectangleComponent(
      size: Vector2(width, height),
      position: Vector2(positionX,positionY),
      paint: gradientPaint,
      priority: 1,
    );
    add(_amountBasicComponent);
  }

  void _showCoinParticleComponent(){
    add(TestParticleComponent(position: localCenter));
    _timerComponent = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        add(TestParticleComponent(position: localCenter));
      },
    );
    _timerComponent.priority = 0;
    add(_timerComponent);
  }


}