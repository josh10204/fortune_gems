import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/widget/machine_raise_menu_button.dart';

class MachineRaiseMenu extends SpriteComponent  with HasVisibility{
  MachineRaiseMenu({super.position,super.size,required this.onTap}) : super();
  final void Function() onTap;


  List<MachineRaiseMenuButton> _raiseMenuButtonList = [];
  late MachineRaiseMenuButton _currentRaiseButton;
  RaiseItems _currentRaiseItems = RaiseItems.item1;


  void _selectRaiseButton(RaiseItems raiseItems){
    List<MachineRaiseMenuButton> buttonList = _raiseMenuButtonList.where((button) => button.raiseItems.serial == raiseItems.serial).toList() ;
    MachineRaiseMenuButton button = buttonList[0];
    button.updateSelect (true);

    if(raiseItems.serial != _currentRaiseItems.serial){
      _currentRaiseButton.updateSelect(false);
      _currentRaiseButton = button;
      _currentRaiseItems = raiseItems;
    }
  }
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('images/raise_menu_background.png');
    _initRaiseButton();
    super.onLoad();
  }

  void _initRaiseButton(){

    for(RaiseItems item in RaiseItems.values){
      bool isSelect = _currentRaiseItems == item;
      MachineRaiseMenuButton button = MachineRaiseMenuButton(
        raiseItems: item,
        isSelectItem: isSelect,
        position: Vector2(item.positionX, item.positionY),
        onTap: (raiseItems) {
          _selectRaiseButton(raiseItems);
        },
      );
      if(isSelect) _currentRaiseButton = button;
      _raiseMenuButtonList.add(button);
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

enum RaiseItems{

  item1(serial:1,raiseAmount:1000,positionX:0,positionY: 0),
  item2(serial:2,raiseAmount:700,positionX:0,positionY: 120),
  item3(serial:3,raiseAmount:500,positionX:0,positionY: 240),
  item4(serial:4,raiseAmount:400,positionX:0,positionY: 360),
  item5(serial:5,raiseAmount:300,positionX:0,positionY: 480),

  item6(serial:6,raiseAmount:200,positionX:210,positionY: 0),
  item7(serial:7,raiseAmount:100,positionX:210,positionY: 120),
  item8(serial:8,raiseAmount:50,positionX:210,positionY: 240),
  item9(serial:9,raiseAmount:20,positionX:210,positionY: 360),
  item10(serial:10,raiseAmount:10,positionX:210,positionY: 480),

  item11(serial:11,raiseAmount:8,positionX:420,positionY: 0),
  item12(serial:12,raiseAmount:5,positionX:420,positionY: 120),
  item13(serial:13,raiseAmount:3,positionX:420,positionY: 240),
  item14(serial:14,raiseAmount:2,positionX:420,positionY: 360),
  item15(serial:15,raiseAmount:1,positionX:420,positionY: 480);

  final int serial;
  final int raiseAmount;
  final double positionX;
  final double positionY;


  const RaiseItems({required this.serial, required this.raiseAmount, required this.positionX,required this.positionY});


}