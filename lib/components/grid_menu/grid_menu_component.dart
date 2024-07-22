import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';
import 'package:fortune_gems/components/grid_menu/grid_menu_item.dart';

import '../../system/global.dart';

class GridTextMenuComponent extends PositionComponent {
  GridTextMenuComponent({super.position,super.size,required this.defaultGridItems, required this.onSelectCallBack}) : super();
  final void Function(GridItems gridItems) onSelectCallBack;
  GridItems defaultGridItems;


  final int horizontalGridCount = 3;// 水平格子數量
  final int verticalGridCount = 5; // 垂直格子數量

  late GridMenuItem _currentGridItem;
  List<GridMenuItem> _gridMenuButtonList = [];
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
    _currentGridItems = defaultGridItems;
    _initGridBackground();
    _initDividersComponent();
    _initGridItem();
    super.onLoad();
  }

  Future<void> _initGridBackground() async {
    Sprite sprite = await Sprite.load('images/bet_menu_background.png');
    Vector2 boxSize = size;
    NineTileBox nineTileBox = NineTileBox(sprite, destTileSize: 7);
    NineTileBoxComponent menuBackgroundComponent = NineTileBoxComponent(nineTileBox: nineTileBox, position: size / 2, size: boxSize, anchor: Anchor.center,);
    add(menuBackgroundComponent);
  }

  Future<void> _initDividersComponent() async {
    Sprite sprite = await Sprite.load('images/bet_menu_line.png');
    NineTileBox nineTileBox = NineTileBox(sprite, destTileSize: 1);
    List<NineTileBoxComponent> dividersList = [];

    //垂直線 數量與位置 依照 水平格子數
    Vector2 verticalLineSize = Vector2(2, size.y);
    for(int i = 1; i < horizontalGridCount; i++){
      Vector2 verticalLinePosition = Vector2(size.x / horizontalGridCount * i, 0);
      NineTileBoxComponent menuLineComponent = NineTileBoxComponent(nineTileBox: nineTileBox, position:verticalLinePosition , size: verticalLineSize);
      dividersList.add(menuLineComponent);
    }
    //水平線 數量與位置 依照 垂直格子數
    Vector2 horizontalLineSize = Vector2(size.x, 2);
    for(int i = 1; i < verticalGridCount; i++){
      Vector2 horizontalLinePosition = Vector2(0, size.y / verticalGridCount *i);
      NineTileBoxComponent menuLineComponent = NineTileBoxComponent(nineTileBox: nineTileBox, position:horizontalLinePosition , size: horizontalLineSize);
      dividersList.add(menuLineComponent);
    }
    addAll(dividersList);
  }

  void _initGridItem(){

    Vector2 itemSize = Vector2(size.x/horizontalGridCount, size.y/verticalGridCount);

    double positionX = 0;
    double positionY = 0;
    for(GridItems item in GridItems.values){
      bool isSelect = _currentGridItems == item;

      GridMenuItem button = GridMenuItem(
        gridItems: item,
        isSelectItem: isSelect,
        size: itemSize,
        position: Vector2(positionX, positionY),
        onTap: (gridItems) {
          _selectGridItems(gridItems);
          onSelectCallBack.call(gridItems);
        },
      );
      if(isSelect) _currentGridItem = button;
      _gridMenuButtonList.add(button);
      button.priority = 1;
      // 每 5 (垂直格子數量) 格換行
      if(item.serial % verticalGridCount == 0){
        positionX += itemSize.x;
        positionY = 0;
      }else{
        positionY += itemSize.y;
      }
    }
    addAll(_gridMenuButtonList);
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
  item1(serial:1,text:'1000'),
  item2(serial:2,text:'700'),
  item3(serial:3,text:'500'),
  item4(serial:4,text:'400'),
  item5(serial:5,text:'300'),
  ///第2行
  item6(serial:6,text:'200'),
  item7(serial:7,text:'100'),
  item8(serial:8,text:'50'),
  item9(serial:9,text:'20'),
  item10(serial:10,text:'10'),
  ///第3行
  item11(serial:11,text:'8'),
  item12(serial:12,text:'5'),
  item13(serial:13,text:'3'),
  item14(serial:14,text:'2'),
  item15(serial:15,text:'1');

  final int serial;
  final String text;
  const GridItems({required this.serial, required this.text});
}