import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/components/grid_menu/grid_menu_component.dart';
import 'package:fortune_gems/system/global.dart';

class GridMenuItem extends PositionComponent  with TapCallbacks {
  GridMenuItem({super.position,super.size,required this.gridItems,required this.isSelectItem, required this.onTap}) : super();
  final void Function(GridItems) onTap;
  final GridItems gridItems;
  late Global _global;

  bool isSelectItem;
  late NineTileBoxComponent _backgroundComponent;
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
    _global = Global();
    _initSelectBackground();
    _initText();
  }

  void _initText(){
    double bet = double.parse(gridItems.text);
    if(_global.isEnableExtraBet){
      bet = bet*_global.extraBetRatio;
    }

    _textComponent = TextComponent(
      text:bet.toString(),
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 25.0,
          color: BasicPalette.white.color,
        ),
      ),
      anchor: Anchor.center,
      position: size/2,
    );
    add(_textComponent);
  }

  Future<void> _initSelectBackground() async {
    Sprite sprite = await Sprite.load('images/bet_menu_choose.png');
    NineTileBox nineTileBox = NineTileBox(sprite, destTileSize: 7);
    _backgroundComponent = NineTileBoxComponent(nineTileBox: nineTileBox, position:localCenter , size: size,anchor: Anchor.center);
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
    print(gridItems.text);

    super.onTapDown(event);
    onTap.call(gridItems);
  }

}