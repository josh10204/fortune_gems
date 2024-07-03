
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_component.dart';
import 'package:fortune_gems/model/wheel_item_model.dart';

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
    double positionX = basicCenter.x + radius * 0.65 * cos(theta); // 調整0.7以確保數字在扇區內
    double positionY = basicCenter.y + radius * 0.65 * sin(theta);
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