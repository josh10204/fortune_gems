import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class IconButton extends PositionComponent  with TapCallbacks {
  IconButton({super.size,super.position,required this.onTap,required this.iconPath,this.backgroundImagePath,this.textString}) : super();
  final void Function() onTap;
  final String iconPath;
  final String? backgroundImagePath;
  final String? textString;


  late SpriteComponent _backgroundSpriteComponent;
  late SpriteComponent _iconSpriteComponent;
  late TextComponent _textComponent;

  Future<void> updateIconPath(String path) async {
    _iconSpriteComponent.sprite = await Sprite.load(path);
  }
  void updateText(String text){
    _textComponent.text = text;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initBackgroundSpriteComponent();
    _initIconSpriteComponent();
    _initTextComponent();
  }

  Future<void> _initBackgroundSpriteComponent() async {
    String path = backgroundImagePath ??'';
    if(path.isEmpty){
     return;
    }
    _backgroundSpriteComponent = SpriteComponent(sprite: await Sprite.load(path),size: size);
    add(_backgroundSpriteComponent);

  }

  Future<void> _initIconSpriteComponent() async {
    _iconSpriteComponent = SpriteComponent(sprite: await Sprite.load(iconPath),size: size);
    add(_iconSpriteComponent);
  }

  void _initTextComponent(){
    String text = textString??'';
    double fontSize = 25;
    double positonX = localCenter.x ;
    double positonY = localCenter.y ;
    _textComponent = TextComponent(
      text:text,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color:Colors.black87,
        ),
      ),
      // size: size,// angle: Anchor.center,
      position: Vector2(positonX,positonY),
      anchor: Anchor.center,
      priority: 1,
    );
    add(_textComponent);
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
  }
  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    print('onTapUp');
    onTap.call();

  }


}