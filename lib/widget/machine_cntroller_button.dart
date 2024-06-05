import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class MachineControllerButton extends SpriteComponent  with TapCallbacks {
  MachineControllerButton({super.size,super.position,required this.onTap,required this.iconPath}) : super();
  final void Function() onTap;
  final String iconPath;


  Future<void> updateIconPath(String path) async {

    sprite = await Sprite.load(path);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(iconPath);
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
    print('onTapDown');
    onTap.call();
  }

}