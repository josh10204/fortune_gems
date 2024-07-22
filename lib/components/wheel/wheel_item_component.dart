
import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';

class WheelItemComponent extends PositionComponent {
  WheelItemComponent({required this.type,required this.betAmount,required this.basicCenter}) : super(size: Vector2(256, 448));

  WheelItemType type;
  double betAmount;
  Vector2 basicCenter;

  late NumberSpriteComponent _numberSpriteComponent ;
  late SpriteComponent _extraBackgroundSpriteComponent;
  late SpriteComponent _additionsSpriteComponent;


  void closeEffect(){
    MoveToEffect moveEffect = MoveToEffect(
      _getCloseNumberPosition(),
      EffectController(duration: 0.4),
    );
    RotateEffect rotateEffect = RotateEffect.to(
      _getCloseNumberAngle(),
      EffectController(duration: 0.4),
    );
    _numberSpriteComponent.add(moveEffect);
    _numberSpriteComponent.add(rotateEffect);
  }

  void openEffect(){
    MoveToEffect moveEffect = MoveToEffect(
      _getOpenNumberPosition(),
      EffectController(duration: 0.8),
    );
    RotateEffect rotateEffect = RotateEffect.to(
      _getOpenNumberAngle(),
      EffectController(duration: 0.8),
    );
    _numberSpriteComponent.add(moveEffect);
    _numberSpriteComponent.add(rotateEffect);
  }

  Future<void> openExtraEffect({WheelAdditionType? additionType,required Function() onComplete}) async {
    OpacityEffect backgroundFadeInEffect = OpacityEffect.fadeIn(EffectController(duration: 0.9));
    _extraBackgroundSpriteComponent.add(backgroundFadeInEffect);
    Random random = Random();

    OpacityEffect additionFadeInEffect = OpacityEffect.fadeIn(EffectController(duration: 0.8));
    ScaleEffect scaleUpEffect = ScaleEffect.to(
      Vector2(2,2),
      EffectController(duration:0.6,curve: Curves.easeInOut,),
    );

    ScaleEffect scaleBackEffect = ScaleEffect.to(
        Vector2(1,1),
        EffectController(duration:0.4,curve: Curves.easeInOut,),
        onComplete:onComplete

    );
    SequenceEffect effectSequence = SequenceEffect([scaleUpEffect, scaleBackEffect]);
    WheelAdditionType type =  additionType ?? WheelAdditionType.values[random.nextInt(WheelAdditionType.values.length)];
    _additionsSpriteComponent.sprite =  await Sprite.load(type.imagePath);
    _additionsSpriteComponent.add(additionFadeInEffect);
    _additionsSpriteComponent.add(effectSequence);

  }

  void closeExtraEffect(){
    _extraBackgroundSpriteComponent.paint = Paint()..color = Colors.white.withOpacity(0); // 透明度设置为
    _additionsSpriteComponent.paint = Paint()..color = Colors.white.withOpacity(0); // 透明度设置为
  }

  void updateBetNumber(double number){
    remove( _numberSpriteComponent);
    _initNumberSpriteComponent(bet: number);
  }
  @override
  Future<void> onLoad() async {
    super.onLoad();
    anchor = Anchor.bottomCenter;
    position = basicCenter;
    angle = type.itemAngle;

    _initExBackgroundSpriteComponent();
    _initAdditionsSpriteComponent();
    _initNumberSpriteComponent(bet: betAmount.toDouble() );
  }

  Future<void> _initExBackgroundSpriteComponent() async {
    double width = 200 * 1.28;
    double height = 350 * 1.28;
    _extraBackgroundSpriteComponent = SpriteComponent(position:Vector2.zero(),sprite: await Sprite.load('images/wheel_item_ex_background.png'),size:Vector2(width,height));
    _extraBackgroundSpriteComponent.priority = 0;
    _extraBackgroundSpriteComponent.paint = Paint()..color = Colors.white.withOpacity(0); // 透明度设置为
    add(_extraBackgroundSpriteComponent);

  }

  Future<void> _initAdditionsSpriteComponent() async {
    double width = WheelAdditionType.addition2x.width;
    double height = WheelAdditionType.addition2x.height;
    double positionX = localCenter.x ;
    double positionY = localCenter.y*0.4;
    _additionsSpriteComponent = SpriteComponent(position:Vector2(positionX,positionY),size: Vector2(width,height),sprite: await Sprite.load(WheelAdditionType.addition2x.imagePath));
    _additionsSpriteComponent.priority = 1;
    _additionsSpriteComponent.anchor  = Anchor.center;
    _additionsSpriteComponent.paint = Paint()..color = Colors.white.withOpacity(0); // 透明度设置为
    add(_additionsSpriteComponent);
  }

  void _initNumberSpriteComponent({required double bet}){
    double number = bet * type.ratio;
    double width = 200;
    double height = 50;
    _numberSpriteComponent = NumberSpriteComponent(number:number,position: _getOpenNumberPosition(),size: Vector2(width,height),fontScale: 0.5);
    _numberSpriteComponent.priority = 2;
    _numberSpriteComponent.anchor  = Anchor.center;
    _numberSpriteComponent.angle = _getOpenNumberAngle();
    add(_numberSpriteComponent);
  }

  Vector2 _getOpenNumberPosition(){
    double positionX = localCenter.x ;
    double positionY = localCenter.y * 1.05;
    return Vector2(positionX,positionY);
  }

  Vector2 _getCloseNumberPosition(){
    double positionX = localCenter.x - 120 ;
    double positionY = localCenter.y * 1.6;
    return Vector2(positionX,positionY);
  }

  double _getOpenNumberAngle(){
    return 90 * 3.14 / 180;
  }

  double _getCloseNumberAngle(){
    return 140 * 3.14 / 180;
  }


}