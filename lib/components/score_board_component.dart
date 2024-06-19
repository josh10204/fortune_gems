import 'package:flame/components.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';


enum ScoreBoardType{
  common(imagePath:'images/score_board_background.png',width:546,height:166),
  wheel(imagePath:'images/score_board_wheel_background.png',width:1018,height:172);
  final String imagePath;
  final double width;
  final double height;
  const ScoreBoardType({required this.imagePath, required this.width,required this.height});

}

class ScoreBoardComponent extends PositionComponent {
  ScoreBoardComponent({super.position,required this.type}) : super(size: Vector2(1290, 220));

  ScoreBoardType type;

  late SpriteComponent _frameSpriteComponent;
  late SpriteComponent _titleSpriteComponent;
  late SpriteComponent  _plusSpriteComponent;
  late NumberSpriteComponent  _numberSpriteComponent;
  late NumberSpriteComponent  _additionNumberSpriteComponent;

  final Vector2 _commonContentPending  = Vector2(25, 15); // 數字顯示範圍的上下左右間距(依圖檔不同修改)
  final Vector2 _wheelContentPending  = Vector2(80, 20); // 數字顯示範圍的上下左右間距(依圖檔不同修改)

  late Vector2 _contentSize; // 數字顯示範圍的寬高


  void updateScoreBoard(){


  }


  @override
  Future<void> onLoad() async {
    super.onLoad();
    _loadData();
    await _initFrameSpriteComponent();
    await _initTitleSpriteComponent();
    await _initPlusNumberSpriteComponent();
    _initNumberSpriteComponent();
  }

  void _loadData(){
    double width ;
    double height;
    if(type == ScoreBoardType.common){
      width= type.width - _commonContentPending.x*2;
      height = type.height - _commonContentPending.y*2;
    }else{
      width= type.width - _wheelContentPending.x*2;
      height = type.height - _wheelContentPending.y*2;
    }
    _contentSize = Vector2(width, height);
  }

  Future<void> _initFrameSpriteComponent() async {
    double width = type.width;
    double height = type.height;
    double positionX = localCenter.x - width/2;
    double positionY = localCenter.y - height/2;
    _frameSpriteComponent = SpriteComponent();
    _frameSpriteComponent.size =  Vector2(width,height);
    _frameSpriteComponent.position =  Vector2(positionX, positionY);
    _frameSpriteComponent.sprite =  await Sprite.load(type.imagePath);
    add(_frameSpriteComponent);
  }

  Future<void> _initTitleSpriteComponent() async {
    if(type == ScoreBoardType.common) return;
    double width = 174;
    double height = 52;
    double positionX = _contentSize.x *0.75 + _wheelContentPending.x - width/2;
    double positionY = localTop.y - height/2;
    _titleSpriteComponent = SpriteComponent();
    _titleSpriteComponent.size =  Vector2(width,height);
    _titleSpriteComponent.position =  Vector2(positionX, positionY);
    _titleSpriteComponent.sprite =  await Sprite.load('images/score_board_wheel_title.png');
    _titleSpriteComponent.priority = 1;
    _frameSpriteComponent.add(_titleSpriteComponent);
  }

  Future<void> _initPlusNumberSpriteComponent() async {
    if(type == ScoreBoardType.common) return;
    double width = 56;
    double height = 58;
    double positionX = _contentSize.x/2 + _wheelContentPending.x - width/2;
    double positionY = _frameSpriteComponent.localCenter.y - height/2;
    _plusSpriteComponent = SpriteComponent();
    _plusSpriteComponent.size =  Vector2(width,height);
    _plusSpriteComponent.position =  Vector2(positionX, positionY);
    _plusSpriteComponent.sprite =  await Sprite.load('icons/numbers_plus.png');
    _plusSpriteComponent.priority = 1;
    _frameSpriteComponent.add(_plusSpriteComponent);
  }

  void _initNumberSpriteComponent(){
    if(type == ScoreBoardType.common){
      _initCommonNumberSpriteComponent();
    }else{
      _initWheelNumberSpriteComponent();
      _initAdditionNumberSpriteComponent();
    }
  }


  void _initCommonNumberSpriteComponent(){

    double positionX = _commonContentPending.x;
    double positionY = _frameSpriteComponent.localCenter.y - _contentSize.y/2;
    _numberSpriteComponent = NumberSpriteComponent(number:0,size:_contentSize,fontScale: 1);
    _numberSpriteComponent.position = Vector2(positionX,positionY);
    _frameSpriteComponent.add(_numberSpriteComponent);
  }

  void _initWheelNumberSpriteComponent(){
    double width = _contentSize.x/2;
    double height = _contentSize.y;
    double positionX = _wheelContentPending.x;
    double positionY = _frameSpriteComponent.localCenter.y - height/2;
    _numberSpriteComponent = NumberSpriteComponent(number:1025,size: Vector2(width,height),fontScale: 1);
    _numberSpriteComponent.position = Vector2(positionX,positionY);
    _frameSpriteComponent.add(_numberSpriteComponent);
  }

  void _initAdditionNumberSpriteComponent(){
    double width = _contentSize.x/2;
    double height = _contentSize.y;
    double positionX = width + _wheelContentPending.x;
    double positionY = _frameSpriteComponent.localCenter.y - height/2;
    _additionNumberSpriteComponent = NumberSpriteComponent(number:1,size: Vector2(width,height),fontScale: 1);
    _additionNumberSpriteComponent.position = Vector2(positionX,positionY);
    _frameSpriteComponent.add(_additionNumberSpriteComponent);
  }



}