
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class NumberSpriteDigitsItem extends PositionComponent {
  NumberSpriteDigitsItem({super.position,super.size,required this.numberType}) : super();

  NumberType numberType;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    double width = numberType.width;
    double height = numberType.height;
    double positionY = position.y;
    double positionX = 0;
    add(SpriteComponent(
      sprite: await Sprite.load(numberType.imagePath),
      size: Vector2(width, height),
      position: Vector2(positionX, positionY),
    ));
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

enum NumberType {
  zero(number: '0',imagePath: 'icons/numbers_0.png',width: 63,height: 73,),
  one(number: '1',imagePath: 'icons/numbers_1.png',width: 36,height: 73,),
  two(number: '2',imagePath: 'icons/numbers_2.png',width: 59,height: 73,),
  three(number:'3',imagePath: 'icons/numbers_3.png',width: 59,height: 73,),
  four(number: '4',imagePath: 'icons/numbers_4.png',width: 67,height: 73,),
  five(number: '5',imagePath: 'icons/numbers_5.png',width: 58,height: 73,),
  six(number: '6',imagePath: 'icons/numbers_6.png',width: 61,height: 73,),
  seven(number: '7',imagePath: 'icons/numbers_7.png',width: 59,height: 73,),
  eight(number: '8',imagePath: 'icons/numbers_8.png',width: 61,height: 73,),
  nine(number: '9',imagePath: 'icons/numbers_9.png',width: 58,height: 73,),
  point(number: '.',imagePath: 'icons/numbers_point.png',width: 27,height: 26),
  comma(number: ',',imagePath: 'icons/numbers_comma.png',width: 25,height: 34);

  final String number;
  final String imagePath;
  final double width;
  final double height;

  const NumberType({required this.number, required this.imagePath,required this.width,required this.height});

}