
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_digits_item.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class NumberSpriteComponent extends PositionComponent {
  NumberSpriteComponent({super.position,super.size,required this.number}) : super();

  double number;

  late PositionComponent _basicnComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _basicnComponent = PositionComponent();

    String numberString = number.toString();
    List<String> numberList = numberString.split('');
    double positionX = 0;
    double positionY = 0;
    for(String number in numberList){
      List<NumberType> numberTypeList = NumberType.values.where((type) => type.number == number).toList() ;
      NumberType numberType = numberTypeList[0];
      double width = numberType.width;
      double height = numberType.height;
      _basicnComponent.add(NumberSpriteDigitsItem(numberType: numberType,size:Vector2(width,height),position: Vector2(positionX,positionY)));
      positionX += width;
    }

    _basicnComponent.size.x = positionX;
    //將數字置中
    _basicnComponent.position.x = localCenter.x - positionX/2;
    _basicnComponent.position.y = localCenter.y - 40;
    add(_basicnComponent);

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