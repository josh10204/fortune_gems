
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
  MachineComponent({required this.onStartCallBack,required this.onStopCallBack}) : super(size: Vector2(1290, 2796),anchor: Anchor.topCenter);
  final void Function() onStartCallBack;
  final void Function(int ratio, int luckyRatio, double resultAmount) onStopCallBack;

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

  /// 全部中獎賠付線類型
  List<RollerPayLineType> _allPayLineTypeList = [];
  /// 判斷此局是否有中獎
  bool _isHasWinning = false;
  /// 中獎倍率
  int _ratio = 0;
  /// 幸運輪盤中獎倍率
  int _luckyRatio = 1;
  /// 單局全部中獎分數（不含中獎倍率，除非幸運輪盤）
  double _playResultAmount = 0;


  /// demo資料順序
  int _currentDemoIndex = 2;
  void startRollingMachine(){
    if(_global.gameStatus == GameStatus.idle){
      _global.gameStatus = GameStatus.startSpin;
      onStartCallBack.call();
      _startRolling();
    }
  }

  void autoRollingMachine(bool isEnable){}

  void speedRollingMachine(bool isEnable){}


  Future<void> _startRolling() async {
    for(MachineRollerComponent machineRollerComponent in _rollers){
      machineRollerComponent.startRolling();
    }
    _updateRollerSymbol();
  }
  Future<void> _updateRollerSymbol() async {
    /// 模擬資料
    SlotGameModel gameModel = SlotGameModel.fromJson(DemoData().resultMap);

    /// 顯示盤面處理
    List<Detail> detailList = gameModel.detail??[];
    Detail detail = detailList[_currentDemoIndex];
    _ratio = detail.ratio ?? 0;
    _luckyRatio = detail.luckyRatio ?? 1;
    String ratio = _ratio.toString();
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

    /// 中獎結果處理
    List<Result> resultList =detail.result??[];
    // 是否有中獎
    _isHasWinning = resultList.isNotEmpty;
    // 全部中獎線
    _allPayLineTypeList = [];
    _playResultAmount = 0;
    for (Result result in resultList) {
      _allPayLineTypeList.add(result.line.toString().getRollerPayLineType);
      _playResultAmount += result.playResult ??0;
    }
    if(_ratio !=0 ){
      _playResultAmount = _playResultAmount/_ratio;
    }

    /// 資料轉換成RollerSymbolModel
    List<RollerSymbolModel> firstModelList = _getRollerSymbolModelList(symbolList: firstList,allResultList:resultList);
    List<RollerSymbolModel> secondModelList = _getRollerSymbolModelList(symbolList: secondList,allResultList:resultList);
    List<RollerSymbolModel> thirdModelList = _getRollerSymbolModelList(symbolList: thirdList,allResultList:resultList);
    List<RollerSymbolModel> ratioModelList = _getRollerSymbolModelList(symbolList: ratioList,allResultList:[]);


    /// 更新資料
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

  List<RollerSymbolModel> _getRollerSymbolModelList({required List<String> symbolList,required List<Result> allResultList}){

    List<RollerSymbolModel> modelList = [];
    for(String symbol in symbolList){
      RollerSymbolType type = symbol.getRollerSymbolType;
      RollerSymbolModel model = RollerSymbolModel(type: type);
      modelList.add(model);
    }
    return modelList;
  }


  Future<void> _stopRolling() async {
    _global.gameStatus = GameStatus.stopSpin;
    _firstMachineRollerComponent.stopRolling();
    await Future.delayed(const Duration(milliseconds: 500));
    _secondMachineRollerComponent.stopRolling();
    await Future.delayed(const Duration(milliseconds: 500));
    _thirdMachineRollerComponent.stopRolling();
    await Future.delayed(const Duration(milliseconds: 500));
    _ratioMachineRollerComponent.stopRolling();
  }

  Future<void> _stopResult() async {
    if(_isHasWinning){
      _global.gameStatus = GameStatus.openScoreBoard;
      _showRollerWinningSymbolAnimation();
      onStopCallBack(_ratio, _luckyRatio,_playResultAmount);
    }else{
      await Future.delayed(const Duration(milliseconds: 500));
      _global.gameStatus = GameStatus.stopSpin;
      onStopCallBack(0, 0,0);
    }
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
      _stopResult();
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

  Future<void> _showRollerWinningSymbolAnimation() async {

    _ratioMachineRollerComponent.showWinningSymbol(indexList:[1]);
    bool isPlay = true;
    while(isPlay){
      isPlay =  _global.gameStatus == GameStatus.idle || _global.gameStatus == GameStatus.openScoreBoard || _global.gameStatus == GameStatus.startScoreBoard;
      if (!isPlay) break;
      for(RollerPayLineType payLineType in  _allPayLineTypeList){
        _firstMachineRollerComponent.showWinningSymbol(indexList: payLineType.firstRollerItemIndexList);
        _secondMachineRollerComponent.showWinningSymbol(indexList:payLineType.secondRollerItemIndexList);
        _thirdMachineRollerComponent.showWinningSymbol(indexList:payLineType.thirdIRollerItemIndexList);
        await Future.delayed(const Duration(milliseconds: 2000));

      }
    }
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
    startRollingMachine();
    super.onTapDown(event);

  }
}