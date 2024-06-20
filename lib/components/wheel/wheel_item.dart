import 'package:flame/components.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_component.dart';

class WheelItem extends PositionComponent {
  WheelItem({required this.type,required this.betNumber}) : super(size: Vector2(100, 50));

  WheelItemType type;
  double betNumber;
  late NumberSpriteComponent _numberSpriteComponent ;


  void updateBetNumber(double number){
    remove( _numberSpriteComponent);
    _numberSpriteComponent = NumberSpriteComponent(position: Vector2.zero(),size: Vector2(width,height),number:number*type.multiple,fontScale: 0.75);
    add(_numberSpriteComponent);
  }
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initNumberSpriteComponent();
  }

  void _initNumberSpriteComponent(){
    _numberSpriteComponent = NumberSpriteComponent(position: Vector2.zero(),number:betNumber*type.multiple,size: Vector2(width,height),fontScale: 0.75);
    add(_numberSpriteComponent);
  }
}


enum WheelItemType{

  item1(serial: 0,multiple:100,centerAngle: 0 ,startAngle: -15 * 3.14 / 180,endAngle: 15 * 3.14 / 180,numberAngle: 90 * 3.14 /180,numberPositionAngle: -86 * 3.14 /180),
  item2(serial: 1,multiple:8,centerAngle: 30 * 3.14 / 180 ,startAngle: 15 * 3.14 / 180,endAngle: 45 * 3.14 / 180,numberAngle: 120 * 3.14 /180,numberPositionAngle: -56 * 3.14 /180),
  item3(serial: 2,multiple:1,centerAngle: 60 * 3.14 / 180 ,startAngle: 45 * 3.14 / 180,endAngle: 75 * 3.14 / 180,numberAngle: 150 * 3.14 /180,numberPositionAngle: -26 * 3.14 /180),
  item4(serial: 3,multiple:20,centerAngle: 90 * 3.14 / 180 ,startAngle: 75 * 3.14 / 180,endAngle: 105 * 3.14 / 180,numberAngle: 180 * 3.14 /180,numberPositionAngle: 4 * 3.14 /180),
  item5(serial: 4,multiple:3,centerAngle: 120 * 3.14 / 180,startAngle: 105 * 3.14 / 180,endAngle: 135 * 3.14 / 180,numberAngle: 210 * 3.14 /180,numberPositionAngle: 34 * 3.14 /180),
  item6(serial: 5,multiple:30,centerAngle: 150 * 3.14 / 180,startAngle: 135 * 3.14 / 180,endAngle: 165 * 3.14 / 180,numberAngle: 240 * 3.14 /180,numberPositionAngle: 64 * 3.14 /180),
  item7(serial: 6,multiple:200,centerAngle: 180 * 3.14 / 180,startAngle: 165 * 3.14 / 180,endAngle: 195 * 3.14 / 180,numberAngle: 270 * 3.14 /180,numberPositionAngle: 94 * 3.14 /180),
  item8(serial: 7,multiple:10,centerAngle: 210 * 3.14 / 180,startAngle: 195 * 3.14 / 180,endAngle: 225 * 3.14 / 180,numberAngle: 300 * 3.14 /180,numberPositionAngle: 124 * 3.14 /180),
  item9(serial: 8,multiple:1000,centerAngle: 240 * 3.14 / 180,startAngle: 225 * 3.14 / 180,endAngle: 255 * 3.14 / 180,numberAngle: 330 * 3.14 /180,numberPositionAngle: 154 * 3.14 /180),
  item10(serial: 9,multiple:5,centerAngle: 270 * 3.14 / 180,startAngle: 255 * 3.14 / 180,endAngle: 285 * 3.14 / 180,numberAngle: 0 * 3.14 /180,numberPositionAngle: 184 * 3.14 /180),
  item11(serial: 10,multiple:50,centerAngle: 300 * 3.14 / 180,startAngle: 285 * 3.14 / 180,endAngle: 315 * 3.14 / 180,numberAngle: 30 * 3.14 /180,numberPositionAngle: 214 * 3.14 /180),
  item12(serial: 11,multiple:15,centerAngle: 330 * 3.14 / 180,startAngle: 315 * 3.14 / 180,endAngle: 345 * 3.14 / 180,numberAngle: 60 * 3.14 /180,numberPositionAngle: 244 * 3.14 /180);


  final int serial;
  final int multiple;//倍數
  final double centerAngle;
  final double startAngle;
  final double endAngle;
  final double numberAngle;
  final double numberPositionAngle;

  const WheelItemType(
      {required this.serial,
        required this.multiple,
      required this.centerAngle,
      required this.startAngle,
      required this.endAngle,
      required this.numberAngle,
      required this.numberPositionAngle});
}