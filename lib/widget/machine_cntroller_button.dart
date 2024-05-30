import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class MachineControllerButton extends SpriteComponent  with TapCallbacks{
  MachineControllerButton({required this.onTap}) : super(size: Vector2(154, 147));
  final void Function() onTap;
  late Function onTapCallbackHandler;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('icons/button01.png');
    super.onLoad();

  }
  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);

  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onTap();
  }

}