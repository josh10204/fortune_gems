
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_digits_item.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class NumberSpriteComponent extends PositionComponent {
  NumberSpriteComponent({super.position,super.size,required this.number,required this.fontScale}) : super();

  double number;
  double fontScale;

  late PositionComponent _basicComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _basicComponent = PositionComponent();
    add(_basicComponent);

    String numberString = number.toString();
    List<String> numberList = numberString.split('');
    double positionX = 0;
    double positionY = 0;
    double basicWidth = 0;
    double basicHeight = 0;
    for(String number in numberList){
      List<NumberType> numberTypeList = NumberType.values.where((type) => type.number == number).toList() ;
      NumberType numberType = numberTypeList[0];
      double width = numberType.width * fontScale;
      double height = numberType.height * fontScale;
      NumberSpriteDigitsItem digitsItem  = NumberSpriteDigitsItem(numberType: numberType,position: Vector2(positionX,positionY),size: Vector2(width,height));
      _basicComponent.add(digitsItem);
      basicWidth += width;
      basicHeight = height;
      positionX = basicWidth;
    }
    //將數字置中
    _basicComponent.position.x = localCenter.x - basicWidth/2;
    _basicComponent.position.y = localCenter.y - basicHeight/2;

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