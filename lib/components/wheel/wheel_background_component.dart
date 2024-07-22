import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';


class WheelBackgroundComponent extends PositionComponent {

  WheelBackgroundComponent({
    super.size,
    super.position,
    super.anchor
  });

  late SpriteComponent _wheelDecorateFrame;


  void startFadeOut({required double duration,required Function() onComplete}){
    ScaleEffect scaleDownEffect = ScaleEffect.to(Vector2(0,0), EffectController(duration:duration), onComplete: (){});
    add(scaleDownEffect);
  }
  void startFadeIn({required double duration,required Function() onComplete}){
    ScaleEffect scaleUpEffect = ScaleEffect.to(
        Vector2(1.5,1.5),
        EffectController(duration:duration*0.6,curve: Curves.easeInOut,),
    );

    ScaleEffect scaleBackEffect = ScaleEffect.to(
      Vector2(1,1),
      EffectController(duration:duration*0.4,curve: Curves.easeInOut,),
      onComplete: (){
        onComplete.call();
      }
    );
    SequenceEffect effectSequence = SequenceEffect([scaleUpEffect, scaleBackEffect]);
    add(effectSequence);

  }

  void closeFadeOut({required double duration,required Function() onComplete}){}
  void closeFadeIn({required double duration,required Function() onComplete}){}


  @override
  void onLoad() async {
    super.onLoad();

    _initWheelDecorateFrame();

  }

  Future<void> _initWheelDecorateFrame() async {
    _wheelDecorateFrame  = SpriteComponent(sprite: await Sprite.load('images/wheel_decorate_frame.png'),size: size,priority: 0);
    add(_wheelDecorateFrame);
  }


  @override
  void update(double dt) {

    super.update(dt);
  }

}
