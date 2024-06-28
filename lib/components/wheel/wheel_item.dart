
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';

class WheelItem extends PositionComponent {
  WheelItem({required this.type,required this.betAmount,required this.basicCenter}) : super(size: Vector2(100, 50));

  WheelItemType type;
  int betAmount;
  Vector2 basicCenter;
  late NumberSpriteComponent _numberSpriteComponent ;


  void closeEffect(){
    MoveToEffect moveEffect = MoveToEffect(
      _getClosePosition(),
      EffectController(duration: 0.4),
    );
    RotateEffect rotateEffect = RotateEffect.to(
      _getCloseAngle(),
      EffectController(duration: 0.4),
    );
    add(moveEffect);
    add(rotateEffect);
  }

  void openEffect(){
    MoveToEffect moveEffect = MoveToEffect(
      _getOpenPosition(),
      EffectController(duration: 0.8),
    );
    RotateEffect rotateEffect = RotateEffect.to(
      _getOpenAngle(),
      EffectController(duration: 0.8),
    );
    add(moveEffect);
    add(rotateEffect);
  }

  void updateBetNumber(double number){
    remove( _numberSpriteComponent);
    _numberSpriteComponent = NumberSpriteComponent(position: Vector2.zero(),size: Vector2(width,height),number:number*type.ratio,fontScale: 0.75);
    add(_numberSpriteComponent);
  }
  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = _getOpenPosition();
    angle = _getOpenAngle();
    _initNumberSpriteComponent();
  }

  void _initNumberSpriteComponent(){
    double number = betAmount.toDouble() * type.ratio;

    _numberSpriteComponent = NumberSpriteComponent(position: Vector2.zero(),number:number,size: Vector2(width,height),fontScale: 0.75);
    add(_numberSpriteComponent);
  }

  Vector2 _getOpenPosition(){
    double theta = type.numberPositionAngle; // 將角度轉為弧度
    double radius = min(basicCenter.x, basicCenter.y);
    double positionX = basicCenter.x + radius * 0.7 * cos(theta); // 調整0.7以確保數字在扇區內
    double positionY = basicCenter.y + radius * 0.7 * sin(theta);
    return Vector2(positionX,positionY);
  }

  Vector2 _getClosePosition(){
    double theta = type.numberPositionAngle; // 將角度轉為弧度
    double radius = min(basicCenter.x, basicCenter.y);
    double positionX = basicCenter.x + radius * 0.2 * cos(theta); // 調整0.7以確保數字在扇區內
    double positionY = basicCenter.y + radius * 0.2 * sin(theta);
    return Vector2(positionX,positionY);
  }

  double _getOpenAngle(){
    return type.numberAngle;
  }

  double _getCloseAngle(){
    return type.numberAngle + 60 * 3.14 /180;
  }

}


enum WheelItemType{

  item100x(serial: 0,ratio:100,centerAngle: 0 ,startAngle: -15 * 3.14 / 180,endAngle: 15 * 3.14 / 180,numberAngle: 90 * 3.14 /180,numberPositionAngle: -86 * 3.14 /180),
  item8x(serial: 1,ratio:8,centerAngle: 330 * 3.14 / 180 ,startAngle: 315 * 3.14 / 180,endAngle: 345 * 3.14 / 180,numberAngle: 120 * 3.14 /180,numberPositionAngle: -56 * 3.14 /180),
  item1x(serial: 2,ratio:1,centerAngle: 300 * 3.14 / 180 ,startAngle: 285 * 3.14 / 180,endAngle: 315 * 3.14 / 180,numberAngle: 150 * 3.14 /180,numberPositionAngle: -26 * 3.14 /180),
  item20x(serial: 3,ratio:20,centerAngle: 270 * 3.14 / 180 ,startAngle: 255 * 3.14 / 180,endAngle: 285 * 3.14 / 180,numberAngle: 180 * 3.14 /180,numberPositionAngle: 4 * 3.14 /180),
  item3x(serial: 4,ratio:3,centerAngle: 240 * 3.14 / 180,startAngle: 225 * 3.14 / 180,endAngle: 255 * 3.14 / 180,numberAngle: 210 * 3.14 /180,numberPositionAngle: 34 * 3.14 /180),

  item30x(serial: 5,ratio:30,centerAngle: 210 * 3.14 / 180,startAngle: 195 * 3.14 / 180,endAngle: 225 * 3.14 / 180,numberAngle: 240 * 3.14 /180,numberPositionAngle: 64 * 3.14 /180),
  item200x(serial: 6,ratio:200,centerAngle: 180 * 3.14 / 180,startAngle: 165 * 3.14 / 180,endAngle: 195 * 3.14 / 180,numberAngle: 270 * 3.14 /180,numberPositionAngle: 94 * 3.14 /180),
  item10x(serial: 7,ratio:10,centerAngle: 150 * 3.14 / 180,startAngle: 135 * 3.14 / 180,endAngle: 165 * 3.14 / 180,numberAngle: 300 * 3.14 /180,numberPositionAngle: 124 * 3.14 /180),
  item1000x(serial: 8,ratio:1000,centerAngle: 120 * 3.14 / 180,startAngle: 105 * 3.14 / 180,endAngle: 135 * 3.14 / 180,numberAngle: 330 * 3.14 /180,numberPositionAngle: 154 * 3.14 /180),

  item5x(serial: 9,ratio:5,centerAngle: 90 * 3.14 / 180,startAngle: 75 * 3.14 / 180,endAngle: 105 * 3.14 / 180,numberAngle: 0 * 3.14 /180,numberPositionAngle: 184 * 3.14 /180),
  item50x(serial: 10,ratio:50,centerAngle: 60 * 3.14 / 180,startAngle: 45 * 3.14 / 180,endAngle: 75 * 3.14 / 180,numberAngle: 30 * 3.14 /180,numberPositionAngle: 214 * 3.14 /180),
  item15x(serial: 11,ratio:15,centerAngle: 30 * 3.14 / 180,startAngle: 15 * 3.14 / 180,endAngle: 45 * 3.14 / 180,numberAngle: 60 * 3.14 /180,numberPositionAngle: 244 * 3.14 /180);



  final int serial;
  final int ratio;//倍數
  final double centerAngle;
  final double startAngle;
  final double endAngle;
  final double numberAngle;
  final double numberPositionAngle;

  const WheelItemType(
      {required this.serial,
        required this.ratio,
      required this.centerAngle,
      required this.startAngle,
      required this.endAngle,
      required this.numberAngle,
      required this.numberPositionAngle});
}