import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/widget/machine_raise_menu.dart';

class MachineRaiseMenuButton extends PositionComponent  with TapCallbacks {
  MachineRaiseMenuButton({super.position,required this.raiseItems,required this.isSelectItem, required this.onTap}) : super();
  final void Function(RaiseItems) onTap;
  final RaiseItems raiseItems;

  bool isSelectItem;
  late RectangleComponent _backgroundComponent;
  late TextComponent _textComponent;


  void updateSelect(bool isSelect){
    isSelectItem = isSelect;
    if(isSelect){
      add(_backgroundComponent);
    }else{
      remove(_backgroundComponent);
    }

  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(210, 120);
    _initSelectBackground();
    _initText();
  }

  void _initText(){
    _textComponent = TextComponent(
      text:'${raiseItems.raiseAmount}',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 48.0,
          color: BasicPalette.white.color,
        ),
      ),
      // angle: Anchor.center,
      anchor: Anchor.center,
      position: size/2,
    );
    add(_textComponent);
  }

  void _initSelectBackground(){
    _backgroundComponent = RectangleComponent(size: size,position: localCenter, anchor: Anchor.center, paint: Paint()..color = Colors.yellow.withOpacity(0.3),);
    if(isSelectItem){
      add(_backgroundComponent);
    }
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
    print('${raiseItems.raiseAmount}');

    super.onTapDown(event);
    onTap.call(raiseItems);
  }

}