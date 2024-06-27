
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:fortune_gems/components/number_sprite/number_sprite_component.dart';
import 'package:fortune_gems/components/winning_component.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/system/global.dart';


enum ScoreBoardType{
  common(imagePath:'images/score_board_background.png',width:546,height:166),
  wheel(imagePath:'images/score_board_wheel_background.png',width:1018,height:172);
  final String imagePath;
  final double width;
  final double height;
  const ScoreBoardType({required this.imagePath, required this.width,required this.height});

}

class ScoreBoardComponent extends PositionComponent {
  ScoreBoardComponent({super.position,super.anchor,required this.type,required this.ratio,required this.luckyRatio, required this.scoreAmount,required this.onCallBack}) : super(size: Vector2(1290, 227.2));
  final void Function(double totalScoreAmount,WinningType winningType) onCallBack;
  ScoreBoardType type;
  double scoreAmount;
  int ratio;
  int luckyRatio;

  late Global _global;
  late SpriteComponent _frameSpriteComponent;
  late SpriteComponent _titleSpriteComponent;
  late SpriteComponent  _plusSpriteComponent;
  late NumberSpriteComponent  _numberSpriteComponent;
  late NumberSpriteComponent  _additionNumberSpriteComponent;
  late SpriteComponent _rollerSymbol;

  final Vector2 _commonContentPending  = Vector2(25, 15); // 數字顯示範圍的上下左右間距(依圖檔不同修改)
  final Vector2 _wheelContentPending  = Vector2(80, 20); // 數字顯示範圍的上下左右間距(依圖檔不同修改)

  late Vector2 _contentSize; // 數字顯示範圍的寬高

  double _totalScoreAmount = 0;

  Future<void> updateAdditionAmount(double number) async {
    _additionNumberSpriteComponent.resetNumber(number);
    _totalScoreAmount = scoreAmount + number;
    _updateScoreBoardStatus();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _global = Global();
    _global.gameStatus =GameStatus.startScoreBoard;
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
    _plusSpriteComponent.sprite =  await Sprite.load('icons/numbers/numbers_plus.png');
    _plusSpriteComponent.priority = 1;
    _frameSpriteComponent.add(_plusSpriteComponent);
  }

  Future<void> _initNumberSpriteComponent() async {
    if(type == ScoreBoardType.common){
      _initCommonNumberSpriteComponent();
      _initRatioRollerSymbol();
      await Future.delayed(const Duration(milliseconds: 1000));
      _showCommonScoreBoardEffect();
    }else{
      _initWheelNumberSpriteComponent();
      _initAdditionNumberSpriteComponent();
      _updateScoreBoardStatus();
    }
  }

  void _initCommonNumberSpriteComponent(){
    double positionX = _commonContentPending.x;
    double positionY = _frameSpriteComponent.localCenter.y - _contentSize.y/2;
    _totalScoreAmount = scoreAmount * ratio;
    _numberSpriteComponent = NumberSpriteComponent(position:Vector2(positionX,positionY),size:_contentSize,number:scoreAmount,fontScale: 1);
    _frameSpriteComponent.add(_numberSpriteComponent);
  }

  Future<void> _initRatioRollerSymbol() async {
    RollerSymbolType type = ratio.toString().getRollerSymbolType;
    double width = 278.4;
    double height = 227.2;
    double positionX = size.x - width*0.7;
    double positionY = height/2;
    _rollerSymbol = SpriteComponent(
        sprite: await Sprite.load(type.imagePath),
        size: Vector2(width, height),
        position: Vector2(positionX, positionY),
        anchor: Anchor.center);
    add(_rollerSymbol);
  }

  void _initWheelNumberSpriteComponent(){
    double width = _contentSize.x/2;
    double height = _contentSize.y;
    double positionX = _wheelContentPending.x;
    double positionY = _frameSpriteComponent.localCenter.y - height/2;
    _numberSpriteComponent = NumberSpriteComponent(position:Vector2(positionX,positionY),size: Vector2(width,height),number:scoreAmount,fontScale: 1);
    _frameSpriteComponent.add(_numberSpriteComponent);
  }

  void _initAdditionNumberSpriteComponent(){
    double width = _contentSize.x/2;
    double height = _contentSize.y;
    double positionX = width + _wheelContentPending.x;
    double positionY = _frameSpriteComponent.localCenter.y - height/2;
    _additionNumberSpriteComponent = NumberSpriteComponent(position:Vector2(positionX,positionY),size: Vector2(width,height),number:0,fontScale: 1);
    _frameSpriteComponent.add(_additionNumberSpriteComponent);
  }


  Future<void> _showCommonScoreBoardEffect() async {
    _numberSpriteComponent.resetNumber(_totalScoreAmount);
    ScaleEffect scaleEffect = ScaleEffect.to(Vector2(1.2,1.2), EffectController(duration: 1,curve: Curves.elasticOut),);
    MoveToEffect moveEffect = MoveToEffect(Vector2(localCenter.x, size.y/2), EffectController(duration: 1),);
    OpacityEffect opacityEffect = OpacityEffect.fadeOut(EffectController(duration: 1),);
    _rollerSymbol.add(scaleEffect);
    await Future.delayed(const Duration(seconds: 1));
    _rollerSymbol.add(moveEffect);
    _rollerSymbol.add(opacityEffect);
    _updateScoreBoardStatus();
  }

  Future<void> _updateScoreBoardStatus() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    WinningType winningType = _checkWinningType();
    if(type == ScoreBoardType.common){
      if(winningType != WinningType.none){
        _global.gameStatus = GameStatus.openBigWinning;
      }else{
        _global.gameStatus = GameStatus.stopScoreBoard;
      }

    }else{
      if(winningType != WinningType.none){
        _global.gameStatus = GameStatus.openBigWinning;
      }else{
        _global.gameStatus = GameStatus.openWheel;
      }
    }
    onCallBack.call(_totalScoreAmount,winningType);
  }

  WinningType _checkWinningType(){
    WinningType winningType = WinningType.none;
    for(WinningType type in WinningType.values){
      if(_totalScoreAmount >= _global.betAmount * type.ratio){
        winningType = type;
      }
    }
    return winningType;
  }
}