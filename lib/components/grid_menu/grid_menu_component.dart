import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/components/grid_menu/grid_menu_item.dart';

class GridTextMenuComponent extends SpriteComponent  with HasVisibility{
  GridTextMenuComponent({super.position,super.size,required this.defaultGridItems, required this.onSelectCallBack}) : super();
  final void Function(GridItems gridItems) onSelectCallBack;
  GridItems defaultGridItems;

  List<GridMenuItem> _gridMenuButtonList = [];
  late GridMenuItem _currentGridItem;
  GridItems? _currentGridItems;


  void _selectGridItems(GridItems items){
    List<GridMenuItem> buttonList = _gridMenuButtonList.where((button) => button.gridItems.serial == items.serial).toList() ;
    GridMenuItem item = buttonList[0];
    item.updateSelect (true);

    if(items.serial != _currentGridItems?.serial){
      _currentGridItem.updateSelect(false);
      _currentGridItem = item;
      _currentGridItems = items;
    }
  }
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('images/bet_menu_background.png');
    _currentGridItems = defaultGridItems;
    _initGridItem();
    super.onLoad();
  }

  void _initGridItem(){

    for(GridItems item in GridItems.values){
      bool isSelect = _currentGridItems == item;
      GridMenuItem button = GridMenuItem(
        gridItems: item,
        isSelectItem: isSelect,
        position: Vector2(item.positionX, item.positionY),
        onTap: (gridItems) {
          _selectGridItems(gridItems);
          onSelectCallBack.call(gridItems);
        },
      );
      if(isSelect) _currentGridItem = button;
      _gridMenuButtonList.add(button);
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

enum GridItems{

  ///第1行
  item1(serial:1,text:'1000',positionX:0,positionY: 0),
  item2(serial:2,text:'700',positionX:0,positionY: 120),
  item3(serial:3,text:'500',positionX:0,positionY: 240),
  item4(serial:4,text:'400',positionX:0,positionY: 360),
  item5(serial:5,text:'300',positionX:0,positionY: 480),
  ///第2行
  item6(serial:6,text:'200',positionX:210,positionY: 0),
  item7(serial:7,text:'100',positionX:210,positionY: 120),
  item8(serial:8,text:'50',positionX:210,positionY: 240),
  item9(serial:9,text:'20',positionX:210,positionY: 360),
  item10(serial:10,text:'10',positionX:210,positionY: 480),
  ///第3行
  item11(serial:11,text:'8',positionX:420,positionY: 0),
  item12(serial:12,text:'5',positionX:420,positionY: 120),
  item13(serial:13,text:'3',positionX:420,positionY: 240),
  item14(serial:14,text:'2',positionX:420,positionY: 360),
  item15(serial:15,text:'1',positionX:420,positionY: 480);

  final int serial;
  final String text;
  final double positionX;
  final double positionY;
  const GridItems({required this.serial, required this.text, required this.positionX,required this.positionY});
}