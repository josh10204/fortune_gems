import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/components/machine_roller/machine_roller_symbol.dart';
import 'package:fortune_gems/system/global.dart';
import 'package:fortune_gems/system/mode_event.dart';

enum RollerType{
  common,
  ratio,
}

enum RollerStatus {
  starting,
  rolling,
  decelerating,
  rebound,
  stopping,
  stopped,
}
class MachineRollerComponent extends PositionComponent {
  MachineRollerComponent({super.position,super.priority,required this.rollerType,required this.onStopCallBack}) : super(size: Vector2(332.8,681.6));

  final void Function() onStopCallBack;

  RollerType rollerType;
  late Global _global;

  List<MachineRollerSymbol> _slotMachineRollerSymbolList = [];
  static const double _rollerHeight = 681.6;
  static const double _symbolHeight = 227.2;
  static const double _rollingSpeed= 5000;
  double _currentRollingSpeed = _rollingSpeed;

  RollerStatus _rollerState = RollerStatus.stopped;
  late MachineRollerSymbol firstRollerSymbol;

  final List<String> _blockList = ['W','H1','H2','H3','N1','N2','N3','N4'];
  final List<String> _ratioList = ['0','1','2','3','5','10','15'];

  late SpriteComponent _extraIconSpriteComponent ;

  /// 取得目前滾動狀態
  RollerStatus get currentState {
    return _rollerState;
  }
  /// 開始滾動
  void startRolling() {
    if (_rollerState == RollerStatus.stopped) {
      print('開始');
      _rollerState = RollerStatus.starting;
      for(MachineRollerSymbol symbol in _slotMachineRollerSymbolList){
        symbol.updateRollerSymbolStatus(MachineRollerSymbolStatus.general);
      }
    }
  }

  /// 停止滾動
  Future<void> stopRolling() async {
    if (_rollerState == RollerStatus.rolling) {
      if(_global.isEnableSpeedSpin){
        _rollerState = RollerStatus.rebound;
      }else{
        _rollerState = RollerStatus.decelerating;
      }
    }
  }

  /// 更新內容
  Future<void> updateRollerSymbolList({required List<RollerSymbolModel> modelList}) async {
    List<RollerSymbolModel> list = modelList;
    /// 倍率的輪盤，補齊剩餘兩個隨機顯示的內容
    if(rollerType == RollerType.ratio && modelList.length <3){
      list = _getRandomRollerSymbolList(list: _ratioList,total:2);
      list.insert(1, modelList[0]);
    }
    for(int i = 0;i<list.length;i++){
      MachineRollerSymbol symbol = _slotMachineRollerSymbolList[i];
      RollerSymbolModel model = list[i];
      bool isStopHeader = i==0?true:false;
      symbol.updateRollerSymbol(model: model, isStopHeader: isStopHeader);
    }
  }

  Future<void> updateExtraIcon({required isShow}) async {
    if(isShow){
      _extraIconSpriteComponent = SpriteComponent(
          sprite: await Sprite.load('icons/button_extra.png'),
          anchor: Anchor.center,
          size: Vector2(87, 66),

        position: Vector2(40, _symbolHeight * 1.5),
      );
      add(_extraIconSpriteComponent);
    }else{

      ScaleEffect scaleEffect = ScaleEffect.to(Vector2(0, 0), EffectController(duration: 1,curve: Curves.elasticIn),onComplete: (){
        remove(_extraIconSpriteComponent);
      });
      _extraIconSpriteComponent.add(scaleEffect);


    }


  }

  void showWinningSymbol({required List<int> indexList}){
    for(MachineRollerSymbol symbol in _slotMachineRollerSymbolList){
      int index = symbol.index;
      if (indexList.contains(index)) {
        symbol.updateRollerSymbolStatus(MachineRollerSymbolStatus.animation);
      }else{
        symbol.updateRollerSymbolStatus(MachineRollerSymbolStatus.mask);

      }
    }
  }


  @override
  void onLoad() async {
    _global = Global();
    _initRollerSymbolList();

    if(rollerType == RollerType.ratio){
      _initSelectFrame();
    }

    super.onLoad();
  }

  Future<void> _initSelectFrame() async {

    add(SpriteComponent(sprite: await Sprite.load('images/machine_select_frame.png'),size: Vector2(324.8,268.8),position: Vector2(-1,_symbolHeight-10)));
  }

  void _initRollerSymbolList(){
    Random random = Random();
    List<RollerSymbolModel> allSymbol =[];
    switch(rollerType){
      case RollerType.common:
        allSymbol = _getRandomRollerSymbolList(list: _blockList,total:5);
      case RollerType.ratio:
        allSymbol = _getRandomRollerSymbolList(list: _ratioList,total:5);
      default:
    }
    int symbolTotal = 5;
    for (int i = 0 ;i< symbolTotal;i++) {
      RollerSymbolModel symbol = allSymbol[random.nextInt(allSymbol.length)];
      MachineRollerSymbol rollerSymbol = MachineRollerSymbol(rollerSymbolModel: symbol,index:i,position: localCenter,anchor:Anchor.topCenter);
      _slotMachineRollerSymbolList.add(rollerSymbol);
    }
    firstRollerSymbol = _slotMachineRollerSymbolList[0];
    add(ClipComponent.rectangle(size: size, children: _slotMachineRollerSymbolList));
  }


  List<RollerSymbolModel> _getRandomRollerSymbolList({required List<String> list,required int total}){
    List<RollerSymbolModel> rollerSymbolList =[];
    Random random = Random();
    for (int i = 0; i < total; i++) {
      int randomIndex = random.nextInt(list.length);
      String symbol = list[randomIndex];
      RollerSymbolType type = symbol.getRollerSymbolType;
      RollerSymbolModel model = RollerSymbolModel(type: type);
      rollerSymbolList.add(model);
    }
    return rollerSymbolList;
  }


  @override
  void update(double dt) {
    // print(dt);
    _updateState(dt);
    super.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
  }

  void _updateState(double dt) {

    switch (_rollerState) {
      case RollerStatus.starting:
        for(int i  =_slotMachineRollerSymbolList.last.index ; i > 2 ; i--){
          _slotMachineRollerSymbolList[i].updateRollerSymbolPositionY(firstRollerSymbol.position.y-_symbolHeight) ;
          firstRollerSymbol = _slotMachineRollerSymbolList[i];
        }
        _rollerState = RollerStatus.rolling;
        break;
      case RollerStatus.rolling:
        _rollingOffsetSymbolsY(dy: dt * _rollingSpeed);
        break;
      case RollerStatus.decelerating:
        if(_currentRollingSpeed >3800){
          _currentRollingSpeed = _currentRollingSpeed-1000;
          _rollingOffsetSymbolsY(dy:dt * _currentRollingSpeed);
        }else{
          _decelerateOffsetSymbolsY(dy: dt * _currentRollingSpeed);
        }
        break;
      case RollerStatus.rebound:
        _reboundOffsetSymbolsY(dy: dt*_currentRollingSpeed);
        break;
      case RollerStatus.stopping:
        _stopOffsetSymbolsY();
        onStopCallBack.call();
        break;
      case RollerStatus.stopped:
        _currentRollingSpeed = _rollingSpeed;
        firstRollerSymbol = _slotMachineRollerSymbolList[0];
        break;
    }
  }

  void _rollingOffsetSymbolsY({required double dy}) {

    for (MachineRollerSymbol slotMachineRollerSymbol in _slotMachineRollerSymbolList) {

      slotMachineRollerSymbol.position.y += dy;
    }
    for (MachineRollerSymbol slotMachineRollerSymbol in _slotMachineRollerSymbolList) {
      //如果方塊已超出滾動邊界（roller高度），則將方塊移動目前第一個方塊上方
      if (slotMachineRollerSymbol.position.y >= _rollerHeight*1.2) {
          //移動Ｙ軸為，目前第一個方塊Y軸 減去 方塊高度
          double positionY = firstRollerSymbol.position.y -_symbolHeight;
          //如果目前第一個方塊是特殊類型（老鷹圖案），因為尺寸不同，所以移動Ｙ軸，則需要加上特殊方塊的中心
          if(firstRollerSymbol.rollerSymbolModel.type == RollerSymbolType.blockWild) {
            positionY +=firstRollerSymbol.specialSymbolCenterY;
          }
          slotMachineRollerSymbol.updateRollerSymbolPositionY(positionY);
          firstRollerSymbol = slotMachineRollerSymbol;
          break;
        }
    }
  }

  void _decelerateOffsetSymbolsY({required double dy}){
    List<MachineRollerSymbol> startTargetSymbolList = _slotMachineRollerSymbolList.where((symbol) => symbol.isStopHeader).toList() ;
    MachineRollerSymbol startTargetSymbol = startTargetSymbolList[0];
    if(startTargetSymbol.position.y >= startTargetSymbol.size.y*0.2 && startTargetSymbol.position.y <= startTargetSymbol.size.y*0.5){
        _rollerState = RollerStatus.rebound;
    }else{
      _rollingOffsetSymbolsY(dy: dy);
    }

  }

  void _reboundOffsetSymbolsY({required double dy}){
    for (MachineRollerSymbol slotMachineRollerSymbol in _slotMachineRollerSymbolList) {
      slotMachineRollerSymbol.position.y -= dy;
    }
    List<MachineRollerSymbol> startTargetSymbolList = _slotMachineRollerSymbolList.where((symbol) => symbol.isStopHeader).toList();
    MachineRollerSymbol startTargetSymbol = startTargetSymbolList[0];
    if(startTargetSymbol.position.y < 0.01){
      _rollerState = RollerStatus.stopping;
    }
  }


  void _stopOffsetSymbolsY(){
    for (int i = 0 ; i < _slotMachineRollerSymbolList.length;i++) {
      _slotMachineRollerSymbolList[i].stopRollerSymbol(i);
    }
    _rollerState = RollerStatus.stopped;
  }
}