import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';


class WheelCenterLogoComponent extends PositionComponent {

  WheelCenterLogoComponent({
    super.size,
    super.position,
    super.anchor
  });

  late SpriteComponent _logoSpriteComponent;


  void startFadeOut({required double duration,required Function() onComplete}){
    ScaleEffect scaleOutEffect = ScaleEffect.to(Vector2(0,0), EffectController(duration:duration), onComplete: (){});
    add(scaleOutEffect);
  }
  void startFadeIn({required double duration,required Function() onComplete}){

    ScaleEffect scaleOutEffect = ScaleEffect.to(Vector2(2,2), EffectController(duration:duration*0.8,curve:Curves.easeInOutCubic), onComplete: (){});
    ScaleEffect scaleInEffect = ScaleEffect.to(Vector2(1,1), EffectController(duration:duration*0.4,curve:Curves.easeInOutCubic), onComplete: (){
      onComplete.call();
    });
    SequenceEffect effectSequence = SequenceEffect([
      scaleOutEffect,
      scaleInEffect,
    ]);
    add(effectSequence);

  }

  void closeFadeOut({required double duration,required Function() onComplete}){
    ScaleEffect scaleOutEffect = ScaleEffect.to(Vector2(1.3,1.3), EffectController(duration:duration*0.8,curve:Curves.easeInOutCubic), onComplete: (){});
    ScaleEffect scaleInEffect = ScaleEffect.to(Vector2(1,1), EffectController(duration:duration*0.4,curve:Curves.easeInOutCubic), onComplete: (){
      onComplete.call();
    });
    SequenceEffect effectSequence = SequenceEffect([
      scaleOutEffect,
      scaleInEffect,
    ]);
    add(effectSequence);
  }
  void closeFadeIn({required double duration,required Function() onComplete}){}


  @override
  void onLoad() async {
    super.onLoad();

    _initLogoSpriteComponent();

  }

  Future<void> _initLogoSpriteComponent() async {
    _logoSpriteComponent  = SpriteComponent(sprite: await Sprite.load('images/wheel_center_logo.png'),size:size);
    add(_logoSpriteComponent);

  }

  @override
  void update(double dt) {

    super.update(dt);
  }

}
