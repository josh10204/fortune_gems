import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/widget/machine_bet_menu_button.dart';

class MachineBetMenu extends SpriteComponent  with HasVisibility{
  MachineBetMenu({super.position,super.size,required this.onSelectCallBack}) : super();
  final void Function(double betAmont) onSelectCallBack;


  List<MachineBetMenuButton> _betMenuButtonList = [];
  late MachineBetMenuButton _currentBetButton;
  BetItems _currentBetItems = BetItems.item1;


  void _selectBetButton(BetItems betItems){
    List<MachineBetMenuButton> buttonList = _betMenuButtonList.where((button) => button.betItems.serial == betItems.serial).toList() ;
    MachineBetMenuButton button = buttonList[0];
    button.updateSelect (true);

    if(betItems.serial != _currentBetItems.serial){
      _currentBetButton.updateSelect(false);
      _currentBetButton = button;
      _currentBetItems = betItems;
    }
  }
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('images/bet_menu_background.png');
    _initBetButton();
    super.onLoad();
  }

  void _initBetButton(){

    for(BetItems item in BetItems.values){
      bool isSelect = _currentBetItems == item;
      MachineBetMenuButton button = MachineBetMenuButton(
        betItems: item,
        isSelectItem: isSelect,
        position: Vector2(item.positionX, item.positionY),
        onTap: (betItems) {
          _selectBetButton(betItems);
          onSelectCallBack.call(betItems.betAmount);
        },
      );
      if(isSelect) _currentBetButton = button;
      _betMenuButtonList.add(button);
      add(button);
    }
    // addAll(_raiseMenuButtonList);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);

  }

}

enum BetItems{

  item1(serial:1,betAmount:1000,positionX:0,positionY: 0),
  item2(serial:2,betAmount:700,positionX:0,positionY: 120),
  item3(serial:3,betAmount:500,positionX:0,positionY: 240),
  item4(serial:4,betAmount:400,positionX:0,positionY: 360),
  item5(serial:5,betAmount:300,positionX:0,positionY: 480),

  item6(serial:6,betAmount:200,positionX:210,positionY: 0),
  item7(serial:7,betAmount:100,positionX:210,positionY: 120),
  item8(serial:8,betAmount:50,positionX:210,positionY: 240),
  item9(serial:9,betAmount:20,positionX:210,positionY: 360),
  item10(serial:10,betAmount:10,positionX:210,positionY: 480),

  item11(serial:11,betAmount:8,positionX:420,positionY: 0),
  item12(serial:12,betAmount:5,positionX:420,positionY: 120),
  item13(serial:13,betAmount:3,positionX:420,positionY: 240),
  item14(serial:14,betAmount:2,positionX:420,positionY: 360),
  item15(serial:15,betAmount:1,positionX:420,positionY: 480);

  final int serial;
  final double betAmount;
  final double positionX;
  final double positionY;


  const BetItems({required this.serial, required this.betAmount, required this.positionX,required this.positionY});


}