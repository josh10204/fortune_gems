
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortune_gems/components/machine_banner_component.dart';
import 'package:fortune_gems/components/machine_roller/machine_roller_component.dart';
import 'package:fortune_gems/components/score_board_component.dart';
import 'package:fortune_gems/demo_data.dart';
import 'package:fortune_gems/extension/position_component_extension.dart';
import 'package:fortune_gems/extension/string_extension.dart';
import 'package:fortune_gems/model/rolller_symbol_model.dart';
import 'package:fortune_gems/model/slot_game_model.dart';
import 'package:fortune_gems/system/global.dart';



class MachineComponent extends PositionComponent with TapCallbacks{
  MachineComponent({required this.onCallBack}) : super(size: Vector2(1290, 2796),anchor: Anchor.topCenter);
  final void Function() onCallBack;

  late Global _global;
  late SpriteComponent _machineFrame;
  late MachineBannerComponent _machineBanner;
  late MachineRollerComponent _firstMachineRollerComponent;
  late MachineRollerComponent _secondMachineRollerComponent;
  late MachineRollerComponent _thirdMachineRollerComponent;
  late MachineRollerComponent _ratioMachineRollerComponent;
  late ScoreBoardComponent _scoreBoardComponent;

  final List<MachineRollerComponent> _rollers = [];
  // bool _isStartRolling = false;
  // bool _isEnableRolling = true;


  /// demo資料順序
  int _currentDemoIndex = 0;
  void startRollingMachine(){
    if(_global.gameStatus == GameStatus.idle){
      _startRolling();

    }
  }

  void autoRollingMachine(bool isEnable){}

  Future<void> _startRolling() async {
    _global.gameStatus = GameStatus.spinStopped;
    for(MachineRollerComponent machineRollerComponent in _rollers){
      machineRollerComponent.startRolling();
      await Future.delayed(const Duration(milliseconds: 400));
    }
    _updateRollerSymbol();
  }
  Future<void> _updateRollerSymbol() async {
    SlotGameModel gameModel = SlotGameModel.fromJson(DemoData().resultMap);
    List<Detail> detailList = gameModel.detail??[];
    /// 模擬資料
    Detail detail = detailList[_currentDemoIndex];
    String ratio = detail.ratio.toString() ??'1';
    List<String> panelList =detail.panel??[];
    List<String> firstList = [];
    List<String> secondList = [];
    List<String> thirdList = [];
    List<String> ratioList = [ratio];
    // 分別取出第 0、3、6 跟 1、4、7 以及 2、5、8
    for (int i = 0; i < panelList.length; i++) {
      if (i % 3 == 0) {
        firstList.add(panelList[i]);
      } else if (i % 3 == 1) {
        secondList.add(panelList[i]);
      } else if (i % 3 == 2) {
        thirdList.add(panelList[i]);
      }
    }


    List<RollerSymbolModel> firstModelList = _getRollerSymbolModelList(list: firstList);
    List<RollerSymbolModel> secondModelList = _getRollerSymbolModelList(list: secondList);
    List<RollerSymbolModel> thirdModelList = _getRollerSymbolModelList(list: thirdList);
    List<RollerSymbolModel> ratioModelList = _getRollerSymbolModelList(list: ratioList);
    _firstMachineRollerComponent.updateRollerSymbolList(modelList:firstModelList);
    _secondMachineRollerComponent.updateRollerSymbolList(modelList:secondModelList);
    _thirdMachineRollerComponent.updateRollerSymbolList(modelList:thirdModelList);
    _ratioMachineRollerComponent.updateRollerSymbolList(modelList: ratioModelList);

    ///Demo 順序往下，超過後重複
    _currentDemoIndex +=1;
    _currentDemoIndex  =  _currentDemoIndex >= detailList.length ? 0 : _currentDemoIndex;
    /// 模擬跟後端取得完資料停止 delay 時間
    await Future.delayed(const Duration(milliseconds: 500));
    _stopRolling();
  }

  List<RollerSymbolModel> _getRollerSymbolModelList({required List<String> list}){

    List<RollerSymbolModel> modelList = [];
    for(String symbol in list){
      RollerSymbolType type = symbol.getRollerSymbolType;
      RollerSymbolModel model = RollerSymbolModel(type: type);
      modelList.add(model);
    }
    return modelList;
  }


  Future<void> _stopRolling() async {
    _global.gameStatus = GameStatus.spinStopped;
    _firstMachineRollerComponent.stopRolling();
    await Future.delayed(const Duration(milliseconds: 500));
    _secondMachineRollerComponent.stopRolling();
    await Future.delayed(const Duration(milliseconds: 500));
    _thirdMachineRollerComponent.stopRolling();
    await Future.delayed(const Duration(milliseconds: 500));
    _ratioMachineRollerComponent.stopRolling();
  }

  Future<void> _showAllWinningSymbol() async {
    _firstMachineRollerComponent.showWinningSymbol();
    _secondMachineRollerComponent.showWinningSymbol();
    _thirdMachineRollerComponent.showWinningSymbol();
    _ratioMachineRollerComponent.showWinningSymbol();

    _showScoreBoardComponent();
    await Future.delayed(const Duration(seconds: 3));
    remove(_scoreBoardComponent);
    onCallBack.call();
  }

  /// 是否當前滾輪都是停止狀態
  bool get isStopped {
    if (_rollers.isNotEmpty) {
      for (MachineRollerComponent roller in _rollers) {
        if (roller.currentState != RollerStatus.stopped) {
          return false;
        }
      }
      return true;
    }
    return false;
  }


  @override
  Future<void> onLoad() async {
    _global = Global();
    _machineFrame = SpriteComponent(sprite: await Sprite.load('images/machine_background.png'),size: Vector2(1614,1025),position:Vector2(-162,0));
    add(_machineFrame);
    _intiMachineRollerComponent();
    _initMachineBanner();
    super.onLoad();
  }


  void _intiMachineRollerComponent(){

    _firstMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position: Vector2(35,135),priority:0,onStopCallBack:(){} );
    _secondMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position: Vector2(332,135),priority:1,onStopCallBack:(){});
    _thirdMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.common,position:  Vector2(635,135),priority:0,onStopCallBack:(){});
    _ratioMachineRollerComponent = MachineRollerComponent(rollerType:RollerType.ratio,position: Vector2(930,135),priority:1,onStopCallBack:(){
      _showAllWinningSymbol();
    });
    _rollers.addAll([
      _firstMachineRollerComponent,
      _secondMachineRollerComponent,
      _thirdMachineRollerComponent,
      _ratioMachineRollerComponent
    ]);
    addAll(_rollers);
  }

 void _initMachineBanner() {
    _machineBanner = MachineBannerComponent(priority: 2);
    add(_machineBanner);
  }

  void _showScoreBoardComponent(){
    _scoreBoardComponent = ScoreBoardComponent(type: ScoreBoardType.common);
    double positionX = 0;
    double positionY = localCenter.y/3 - _scoreBoardComponent.size.y/2;
    _scoreBoardComponent.position = Vector2(positionX,positionY);
    _scoreBoardComponent.priority = 3;
    add(_scoreBoardComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);

  }

  @override
  void onTapDown(TapDownEvent event) {
    if(_global.gameStatus == GameStatus.idle){
      _startRolling();
    }
    super.onTapDown(event);

  }
}