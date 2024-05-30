import 'dart:math';

import 'package:flame/components.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/widget/machine_roller_symbol.dart';

enum RollerType{
  common,
  addition,
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

  List<MachineRollerSymbol> _slotMachineRollerSymbolList = [];
  static const double _rollerHeight = 681.6;
  static const double _symbolHeight = 227.2;
  static const double _rollingSpeed= 5000;
  double _currentRollingSpeed = _rollingSpeed;

  RollerStatus _rollerState = RollerStatus.stopped;
  late MachineRollerSymbol firstRollerSymbol;

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
      print('停止');
      await _updateRollerSymbolList();
      _rollerState = RollerStatus.decelerating;
    }
  }

  void showWinningSymbol(){
    for(MachineRollerSymbol symbol in _slotMachineRollerSymbolList){
      if(symbol.rollerSymbolModel.isWinningSymbol){
        symbol.updateRollerSymbolStatus(MachineRollerSymbolStatus.animation);
      }else{
        symbol.updateRollerSymbolStatus(MachineRollerSymbolStatus.mask);
      }
    }
  }



  @override
  void onLoad() async {
    _initRollerSymbolList();

    if(rollerType == RollerType.addition){
      _initSelectFrame();
    }

    super.onLoad();
  }

  Future<void> _initSelectFrame() async {

    add(SpriteComponent(sprite: await Sprite.load('images/machine_select_frame.png'),size: Vector2(324.8,268.8),position: Vector2(-1-0,_symbolHeight-10)));
  }

  void _initRollerSymbolList(){
    Random random = Random();
    List<RollerSymbolModel> allSymbol = _getAllRollerSymbol();
    int symbolTotal = 5;
    for (int i = 0 ;i< symbolTotal;i++) {
      RollerSymbolModel symbol = allSymbol[random.nextInt(allSymbol.length)];

      MachineRollerSymbol rollerSymbol = MachineRollerSymbol(rollerSymbolModel: symbol,index:i,position: localCenter,anchor:Anchor.topCenter);
      _slotMachineRollerSymbolList.add(rollerSymbol);
    }
    firstRollerSymbol = _slotMachineRollerSymbolList[0];
    add(ClipComponent.rectangle(size: size, children: _slotMachineRollerSymbolList));
  }

  Future<void> _updateRollerSymbolList() async {
    Random random = Random();
    List<RollerSymbolModel> allSymbol = _getAllRollerSymbol();
    // int randomIndex = random.nextInt(_slotMachineRollerBlock.length);
    int randomIndex = 1;
    int randomWinningTotleIndex = random.nextInt(2)+1;
    int i = 1;
    for(MachineRollerSymbol rollerSymbol in _slotMachineRollerSymbolList){
      bool isStopHeader = i == randomIndex? true:false ;
      bool isWinningTarget = i<=randomWinningTotleIndex ? true:false;
      RollerSymbolModel symbol = allSymbol[random.nextInt(allSymbol.length)];
      symbol.isWinningSymbol= isWinningTarget;
      await rollerSymbol.updateRollerSymbol(model:symbol ,isStopHeader:isStopHeader);
      if(i==3) break;
      i++;
    }
    await Future.delayed(const Duration(milliseconds: 500));

  }

  List<RollerSymbolModel> _getAllRollerSymbol(){
    List<RollerSymbolModel> list = [];
    if(rollerType == RollerType.common){
      list = [
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_01.png',unselectImageFilePath: 'icons/symbol_common_unselect_01.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_02.png',unselectImageFilePath: 'icons/symbol_common_unselect_02.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_03.png',unselectImageFilePath: 'icons/symbol_common_unselect_03.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_04.png',unselectImageFilePath: 'icons/symbol_common_unselect_04.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_05.png',unselectImageFilePath: 'icons/symbol_common_unselect_05.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_06.png',unselectImageFilePath: 'icons/symbol_common_unselect_06.png'),
        RollerSymbolModel(type:RollerSymbolType.common,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_07.png',unselectImageFilePath: 'icons/symbol_common_unselect_07.png'),
        RollerSymbolModel(type:RollerSymbolType.special,isWinningSymbol:false,imageFilePath: 'icons/symbol_common_08.png',unselectImageFilePath: 'icons/symbol_common_unselect_08.png'),
      ];

    }else{
      list = [
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_01.png',unselectImageFilePath: 'icons/symbol_addition_unselect_01.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_02.png',unselectImageFilePath: 'icons/symbol_addition_unselect_02.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_03.png',unselectImageFilePath: 'icons/symbol_addition_unselect_03.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_04.png',unselectImageFilePath: 'icons/symbol_addition_unselect_04.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_05.png',unselectImageFilePath: 'icons/symbol_addition_unselect_05.png'),
        RollerSymbolModel(type:RollerSymbolType.addition,isWinningSymbol:false,imageFilePath: 'icons/symbol_addition_06.png',unselectImageFilePath: 'icons/symbol_addition_unselect_06.png'),
      ];
    }

    return list;
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
        if(_currentRollingSpeed >2000){
          _currentRollingSpeed = _currentRollingSpeed-800;
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
          if(firstRollerSymbol.rollerSymbolModel.type == RollerSymbolType.special) {
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