import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';


class WheelPointerComponent extends PositionComponent {

  WheelPointerComponent({
    super.size,
    super.position,
    super.anchor
  });

  late SpriteComponent _pointerSpriteComponent;


  void startFadeOut({required double duration,required Function() onComplete}){
    ScaleEffect scaleDownEffect = ScaleEffect.to(Vector2(0,0), EffectController(duration:duration), onComplete: (){
      MoveToEffect moveEffect = MoveToEffect(Vector2(position.x, position.y - 80), EffectController(duration: duration),);
      _pointerSpriteComponent.opacity = 0;
      add(moveEffect);
      onComplete.call();
    });
    add(scaleDownEffect);
  }
  void startFadeIn({required double duration,required Function() onComplete}){
    ScaleEffect scaleDownEffect = ScaleEffect.to(Vector2(1,1), EffectController(duration:duration*0.1), onComplete: (){});
    OpacityEffect fadeIntEffect = OpacityEffect.fadeIn(EffectController(duration: duration));
    MoveToEffect moveEffect = MoveToEffect(Vector2(position.x, position.y + 80), EffectController(duration: duration,curve: Curves.easeInBack),onComplete: (){
      onComplete.call();
    });
    add(scaleDownEffect);
    _pointerSpriteComponent.add(fadeIntEffect);
    add(moveEffect);
  }
  void closeFadeOut({required double duration,required Function() onComplete}){
    MoveToEffect moveEffect = MoveToEffect(Vector2(position.x, position.y + 40), EffectController(duration: duration,curve: Curves.easeInBack,),onComplete: () async {
      onComplete.call();
    });
    add(moveEffect);
  }
  void closeFadeIn({required double duration,required Function() onComplete}){}


  void startLottery({required double duration,required Function() onComplete}){
    MoveToEffect bounceEffect = MoveToEffect(Vector2(position.x, position.y  - 40), EffectController(duration: duration,curve: Curves.elasticInOut),onComplete: (){
      onComplete.call();
    });
    add(bounceEffect);
  }

  @override
  void onLoad() async {
    super.onLoad();

    _initPointerSpriteComponent();

  }

  Future<void> _initPointerSpriteComponent() async {
    _pointerSpriteComponent  = SpriteComponent(sprite: await Sprite.load('images/wheel_select_frame.png'),size:size);
    add(_pointerSpriteComponent);

  }

  @override
  void update(double dt) {

    super.update(dt);
  }

}
