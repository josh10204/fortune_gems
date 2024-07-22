

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';

class ExtraBetEnableEffectComponent extends PositionComponent{
  ExtraBetEnableEffectComponent({super.anchor,required this.onFinishCallBack}) : super(size: Vector2(900, 1600));

  final void Function() onFinishCallBack;

  final List<SpriteComponent> _additionList = [];
  final List<SpriteComponent> _symbolList = [];


  OpacityEffect fadeInEffect = OpacityEffect.fadeIn(EffectController(duration: 1),);

  final double _sizeScale = 2.5;

  Future<void> _enableEffectAnimation() async {
    _enableEffectAdditionAnimation();
    _enableEffectSymbolAnimation();
    await Future.delayed(const Duration(milliseconds: 2000));
    // onFinishCallBack.call();
  }

  Future<void> _enableEffectAdditionAnimation() async {
    for (SpriteComponent spriteComponent in _additionList) {
      OpacityEffect fadeInEffect = OpacityEffect.fadeIn(EffectController(duration: 0.4), onComplete: () {
        MoveToEffect moveEffect = MoveToEffect(Vector2(localCenter.x, size.y*0.4), EffectController(duration: 0.5),);
        OpacityEffect fadeOutEffect = OpacityEffect.fadeOut(EffectController(duration: 0.5),);
        ScaleEffect scaleEffect = ScaleEffect.to(Vector2(0.2, 0.2), EffectController(duration: 0.5),);
        spriteComponent.add(moveEffect);
        spriteComponent.add(fadeOutEffect);
        spriteComponent.add(scaleEffect);
      });
      spriteComponent.add(fadeInEffect);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _enableEffectSymbolAnimation() async {
    int i = 0;
    for(SpriteComponent spriteComponent in _symbolList){
      EnableEffectSymbolType type = EnableEffectSymbolType.values[i];
      double positionX = size.x * type.movePositionScaleX;
      double positionY = size.y * type.movePositionScaleY;
      MoveToEffect moveEffect = MoveToEffect(Vector2(positionX,positionY), EffectController(duration: 1.1,curve: Curves.easeInCubic),);
      OpacityEffect fadeOutEffect = OpacityEffect.fadeOut(EffectController(duration: 0.05),);
      SequenceEffect sequenceEffect = SequenceEffect([moveEffect,fadeOutEffect]);
      spriteComponent.add(sequenceEffect);
      await Future.delayed(const Duration(milliseconds: 150));
      i ++;
    }

  }

  @override
  Future<void> onLoad() async {
    await _initAdditionComponent();
    await _initSymbolComponent();
    _enableEffectAnimation();

  }

  Future<void> _initAdditionComponent() async {
    for(EnableEffectAdditionType additionType in EnableEffectAdditionType.values){
      double width = additionType.type.width * _sizeScale;
      double height = additionType.type.height * _sizeScale;
      double positionX = size.x * additionType.positionScaleX;
      double positionY = size.y * additionType.positionScaleY;
      SpriteComponent addition = SpriteComponent();
      addition.size =  Vector2(width,height);
      addition.position =  Vector2(positionX, positionY);
      addition.sprite =  await Sprite.load(additionType.type.imagePath);
      addition.paint = Paint()..color = Colors.white.withOpacity(0); // 透明度设置为
      _additionList.add(addition);
    }
    addAll(_additionList);
  }

  Future<void> _initSymbolComponent() async {
    for(EnableEffectSymbolType symbolType in EnableEffectSymbolType.values){
      double width = symbolType.width;
      double height = symbolType.height;
      double positionX = size.x * symbolType.positionScaleX;
      double positionY = size.y * symbolType.positionScaleY;
      SpriteComponent symbol = SpriteComponent();
      symbol.size =  Vector2(width,height);
      symbol.position =  Vector2(positionX, positionY);
      symbol.sprite =  await Sprite.load(symbolType.type.imagePath);
      _symbolList.add(symbol);
    }
    addAll(_symbolList);
  }
}



enum EnableEffectAdditionType{

  addition1(type:WheelAdditionType.addition2x,positionScaleX: 0.7,positionScaleY: 0.3),
  addition2(type:WheelAdditionType.addition2x,positionScaleX: 0.1,positionScaleY: 0.15),
  addition3(type:WheelAdditionType.addition15x,positionScaleX: 0.05,positionScaleY: 0.23),
  addition4(type:WheelAdditionType.addition15x,positionScaleX: 0.75,positionScaleY: 0.12),
  addition5(type:WheelAdditionType.addition5x,positionScaleX: 0.45,positionScaleY: 0.06),
  addition6(type:WheelAdditionType.addition10x,positionScaleX: 0.3,positionScaleY: 0.12),
  addition7(type:WheelAdditionType.addition10x,positionScaleX: 0.6,positionScaleY: 0.18),
  addition8(type:WheelAdditionType.addition1x,positionScaleX: 1,positionScaleY: 0.25),
  addition9(type:WheelAdditionType.addition5x,positionScaleX: 1.2,positionScaleY: 0.45),
  addition10(type:WheelAdditionType.addition3x,positionScaleX: -0.2,positionScaleY: 0.36);

  final WheelAdditionType type;
  final double positionScaleX;
  final double positionScaleY;

  const EnableEffectAdditionType({required this.type, required this.positionScaleX,required this.positionScaleY});
}

enum EnableEffectSymbolType{

  symbol1(type:RollerSymbolType.ratio3x,width:200,height: 160 ,positionScaleX: -0.3,positionScaleY: 0.38,movePositionScaleX: 0.74,movePositionScaleY: 0.5),
  symbol2(type:RollerSymbolType.ratio10x,width:200,height: 160,positionScaleX: -0.3,positionScaleY: 0.25,movePositionScaleX: 0.74,movePositionScaleY: 0.6),
  symbol3(type:RollerSymbolType.ratio15x,width:200,height: 160,positionScaleX: -0.3,positionScaleY: 0.315,movePositionScaleX: 0.74,movePositionScaleY: 0.65),
  symbol4(type:RollerSymbolType.wheelEX,width:200,height: 160,positionScaleX: -0.3,positionScaleY: 0.2,movePositionScaleX:0.74,movePositionScaleY: 0.7);


  final RollerSymbolType type;
  final double width;
  final double height;
  final double positionScaleX;
  final double positionScaleY;
  final double movePositionScaleX;
  final double movePositionScaleY;

  const EnableEffectSymbolType({required this.type, required this.width,required this.height, required this.positionScaleX,required this.positionScaleY,required this.movePositionScaleX,required this.movePositionScaleY});
}